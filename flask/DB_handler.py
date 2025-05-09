import pyrebase
import json
import os
import datetime
import firebase_admin
from firebase_admin import credentials, db

base_dir = os.path.abspath(os.path.dirname(__file__))
auth_path = os.path.join(base_dir, "auth", "firebaseAuth.json")
cred_path = os.path.join(base_dir, "firebase-adminsdk.json")
cred = credentials.Certificate(cred_path)


class DBModule:
    def __init__(self):
        with open(auth_path) as f:
            config = json.load(f)

        self.firebase = pyrebase.initialize_app(config)

    def login(self, id, password):
        auth = self.firebase.auth()
        try:
            user = auth.sign_in_with_email_and_password(id, password)
            return user
        except Exception as e:
            print(f"Login failed: {e}")
            return None

    def signin(self, id, password, name, gender, birth, address, mbti, plant):
        auth = self.firebase.auth()
        db = self.firebase.database()

        try:
            user = auth.create_user_with_email_and_password(id, password)
            uid = user['localId']
            user_data = {
                "name": name,
                "id": id,
                "gender" : gender,
                "birth" : birth,
                "address" : address,
            }
            if mbti:
                user_data["mbti"] = mbti
            if plant:
                user_data["plant"] = plant

            db.child("users").child(uid).set(user_data)
            return True
        except:
            return False
    def get_user(self, uid):
        db = self.firebase.database()
        try:
            user_data = db.child("users").child(uid).get()
            if user_data.val():
                return user_data.val()  # 딕셔너리 형태로 반환
            else:
                return None  # 해당 UID 없음
        except Exception as e:
            print(f"사용자 정보 불러오기 실패: {e}")
            return None

    def write_post(self, uid, title, contents, capacity, state):
        db = self.firebase.database()
        try:
            post_data = {
                "title": title,
                "contents": contents,
                "capacity": capacity,
                "state": state,
                "author_uid": uid,
                "comment": [],
                "people": f"0/{capacity}명",
            }

            new_post_ref = db.child("posts").push(post_data)
            pid = new_post_ref['name']

            # 게시글에 pid 추가
            db.child("posts").child(pid).update({"pid": pid})

            # 🔥 여기 중요! 사용자 posts에 덮어쓰지 말고 update로 추가
            db.child("users").child(uid).child("posts").update({pid: True})

            return pid
        except Exception as e:
            print(f"Failed to write post: {e}")
            return None


    def get_post(self): #전체 게시글 불러오기
        db = self.firebase.database()
        try:
            posts = db.child("posts").get()
            if posts.each():
                return {post.key(): post.val() for post in posts.each()}
            else:
                return {}  
        except Exception as e:
            print(f"게시글 불러오기 실패: {e}")
            return {}
        
    def get_post_by_pid(self, pid): # PID로 게시글 불러오기
        db = self.firebase.database()
        try:
            post_data = db.child("posts").child(pid).get()
            if post_data.val():
                return post_data.val()  # 딕셔너리 형태로 반환
            else:
                return None  # 해당 PID 없음
        except Exception as e:
            print(f"게시글 불러오기 실패: {e}")
            return None
        
    def get_post_member(self, pid): # PID로 게시글 멤버 불러오기
        db = self.firebase.database()
        try:
            post_data = db.child("posts").child(pid).child("member").get()
            if post_data.val():
                return post_data.val()  # 딕셔너리 형태로 반환
            else:
                return None  # 해당 PID 없음
        except Exception as e:
            print(f"게시글 멤버 불러오기 실패: {e}")
            return None
    def apply_to_post(self, pid, user):
        db = self.firebase.database()
        uid = user["localId"]

        try:
            db.child("posts").child(pid).child("requests").child(uid).set({
                "uid": uid,
                "username": user.get("name", "익명"),
                "applied_at": self._get_timestamp()
            })
            return True
        except Exception as e:
            print(f"참가 신청 실패: {e}")
            return False
           
    def append_post_member(self, pid, uid):
        db = self.firebase.database()
        try:
            post_data = db.child("posts").child(pid).child("member").get()
            if post_data.val():
                member = post_data.val()
                if uid not in member:
                    member.append(uid)
                    db.child("posts").child(pid).child("member").set(member)
                    return True
                else:
                    return False  # 이미 멤버인 경우
            else:
                return None  # 해당 PID 없음
        except Exception as e:
            print(f"게시글 멤버 추가 실패: {e}")
            return None
        
    def create_chatroom(self, pid):
        db = self.firebase.database()
        try:
            # 1. 해당 게시글의 멤버 리스트 불러오기
            member_data = db.child("posts").child(pid).child("member").get()
            if member_data.val():
                members = member_data.val()
            else:
                members = []  # 멤버가 없을 경우 빈 리스트

            # 2. 채팅방 데이터 구성
            chatroom_data = {
                "pid": pid,
                "members": members,         # ← 모든 멤버 포함
                "messages": []
            }

            # 3. chatrooms에 push
            new_chatroom_ref = db.child("chatrooms").push(chatroom_data)
            chatroom_id = new_chatroom_ref['name']

            # 4. 해당 게시글에 chatroom_id 추가
            db.child("posts").child(pid).update({"chatroom_id": chatroom_id})

            return chatroom_id
        except Exception as e:
            print(f"채팅방 생성 실패: {e}")
            return None
        
    def send_message(self, chatroom_id, sender_uid, content):
        db = self.firebase.database()
        message_data = {
            "sender_uid": sender_uid,
            "content": content,
            "timestamp": self._get_timestamp()
        }

        try:
            db.child("chatrooms").child(chatroom_id).child("messages").push(message_data)
            return True
        except Exception as e:
            print(f"메시지 전송 실패: {e}")
            return None
        
    def write_comment(self, pid, user, content):
        db = self.firebase.database()
        comment_data = {
            "uid": user["localId"],  # 댓글 작성자의 ID
            "username": user.get("name", "익명"),  # 사용자 이름 (없으면 "익명")
            "content": content,
            "timestamp": self._get_timestamp()
        }

        try:
            
            db.child("posts").child(pid).child("comments").push(comment_data)
            return True
        except Exception as e:
            print(f"사용자 정보 불러오기 실패: {e}")
            return None
    
    
    def search_post(self, keyword):
        db = self.firebase.database()
        try:
            posts = db.child("posts").get()
            if posts.each():
                result = {}
                for post in posts.each():
                    post_data = post.val()
                    title = post_data.get("title", "")
                    content = post_data.get("content", "")
                    if keyword in title or keyword in content:
                        result[post.key()] = post_data
                return result
            else:
                return {}
        except Exception as e:
            print(f"게시글 검색 실패: {e}")
            return {}

    def to_do_list(self, pid):
        db = self.firebase.database()

        try:
            # 1. 해당 게시글의 멤버 목록 가져오기
            member_ref = db.child("posts").child(pid).child("member")
            member_data = member_ref.get()
            if not member_data.val():
                return []

            members = member_data.val()  # uid 리스트
            result = []

            # 2. 각 멤버의 ToDoList 가져오기
            for uid in members:
                user_todo_ref = db.child("users").child(uid).child("todo")
                todo_data = user_todo_ref.get()

                if todo_data.val():
                    result.append({
                        "uid": uid,
                        "todo": todo_data.val()
                    })

            return result
    
        except Exception as e:
            print(f"[to_do_list] 에러: {e}")
            return []
    def write_todo_list(self, uid, new_task):
        db = self.firebase.database()
        try:
            # 1. 현재 사용자의 todo 리스트 가져오기
            todo_ref = db.child("users").child(uid).child("todo")
            existing_todo = todo_ref.get()

            # 2. 다음 인덱스 계산 (기존 항목 수 or 0)
            if existing_todo.val():
                next_index = str(len(existing_todo.val()))
            else:
                next_index = "0"

            # 3. 새 항목 추가
            todo_ref.child(next_index).set(new_task)
            return True
        except Exception as e:
            print(f"[write_todo_list] 에러: {e}")
            return False
    def add_calendar_event(self, pid, date, event):
        db = self.firebase.database()
        try:
            db.child("calendar").child(pid).child(date).set(event)
            return True
        except Exception as e:
            print(f"[add_calendar_event] 에러: {e}")
            return False
    def get_calendar_events(self, pid):
        db = self.firebase.database()
        try:
            events = db.child("calendar").child(pid).get()
            if events.val():
                return events.val()
            else:
                return {}
        except Exception as e:
            print(f"[get_calendar_events] 에러: {e}")
            return {}

    def _get_timestamp(self):
        return datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
