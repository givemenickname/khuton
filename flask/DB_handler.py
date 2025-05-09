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

    def write_post(self, uid, title, contents, capacity):
        post_data = {
            "uid": uid,
            "title" : title,
            "contents": contents,
            "capacity": capacity,
            "createdAt": datetime.datetime.now().isoformat()
        }

        try:
            self.db.child("posts").push(post_data)
            print("Post successfully written.")
        except Exception as e:
            print(f"Failed to write post: {e}")



    def post_list(self,pid):
        pass

    def post_detail(self, pid):
        pass

    def get_user(self, uid):
        pass