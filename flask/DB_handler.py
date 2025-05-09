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
            }
            new_post_ref = db.child("posts").push(post_data)
            pid = new_post_ref['name']

            db.child("posts").child(pid).update({"pid": pid})
            return pid
        except Exception as e:
            print(f"Failed to write post: {e}")
            return None

    def get_post(self):
        db = self.firebase.database()
        try:
            posts = db.child("posts").get()
            if posts.each():
                return {post.key(): post.val() for post in posts.each()}
            else:
                return {}  # 게시글이 하나도 없는 경우
        except Exception as e:
            print(f"게시글 불러오기 실패: {e}")
            return {}


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
