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
            pass

        def signin(self, id, password, name, gender, birth, address, mbti, plant):
            pass

        def write_post(self, user, contents, capacity):
            pass

        def post_list(self):
            pass

        def post_detail(self, pid):
            pass

        def get_user(self, uid):
            pass