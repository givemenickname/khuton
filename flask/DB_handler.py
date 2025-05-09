import pyrebase
import json
import os
import datetime

base_dir = os.path.abspath(os.path.dirname(__file__))
auth_path = os.path.join(base_dir, "auth", "firebaseAuth.json")

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

    def write_post(self, uid, title, contents, capacity, state, time):
        db = self.firebase.database()

        try:
            post_data = {
            "title" : title,
            "contents": contents,
            "capacity": capacity,
            "state": state,
            "author_uid": uid,
            "timestamp": time.time(),
            "comment": [],
            }
            new_post_ref = db.child("posts").push(post_data)
            pid = new_post_ref['name']

            db.child("posts").child(pid).update({"pid": pid})

            user_posts_reg = db.child("users").child(uid).child("posts")
            user_posts = user_posts_reg.get().val()
            if user_posts is None:
                user_posts = []
            user_posts.append(pid)
            user_posts_reg.set(user_posts)
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
    
    def search_post(self, keyword):
        db = self.firebase.database()
        try:
            posts = db.child("posts").get()
            if posts.each():
                result = {}
                for post in posts.each():
                    if keyword in post.val()["title"]:
                        result[post.key()] = post.val()
                return result
            else:
                return {}  # 게시글이 하나도 없는 경우
        except Exception as e:
            print(f"게시글 검색 실패: {e}")
            return {}

