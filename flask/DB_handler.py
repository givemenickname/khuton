import pyrebase
import json

class DBModule:
    def __init__(self):
        with open("./auth/firebase_config.json") as f:
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