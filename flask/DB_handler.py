import pyrebase
import json
import os

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

    def write_post(self, user, contents, capacity):
        pass

    def post_list(self):
        pass

    def post_detail(self, pid):
        pass

    def get_user(self, uid): #데이터 베이스에서 user 정보 받아오기
        db = self.firebase.database()
        try:
            user_data = db.child("users").child(uid).get()
            if user_data.val():
                return user_data.val()
            else:
                return None 
        except Exception as e:
            print(f"Error fetching user data: {e}")
            return None