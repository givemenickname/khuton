import pyrebase

const firebaseConfig = {
  "apiKey": "AIzaSyBcShzZyTXx3R5iuWrhfYdL8FbAz1HMgLI",
  "authDomain": "new-project-1aae0.firebaseapp.com",
  "databaseURL": "https://new-project-1aae0-default-rtdb.firebaseio.com",
  "projectId": "new-project-1aae0",
  "storageBucket": "new-project-1aae0.appspot.com",
  "messagingSenderId": "752770395693",
  "appId": "1:752770395693:web:b78e73190827ab867512a4",
  "measurementId": "G-T5ES1ZH0PJ"
};

firebase = pyrebase.initialize_app(firebaseConfig)
db = firebase.database()