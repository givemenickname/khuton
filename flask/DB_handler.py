import pyrebase
import json

class DBModule:
    def __init__(self):
        with open("./auth/firebase_config.json") as f:
            config = json.load(f)

        self.firebase = pyrebase.initialize_app(config)