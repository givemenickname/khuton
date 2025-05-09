from flask import Flask, redirect, render_template, request, url_for, jsonify
from DB_handler import DBModule

DB = DBModule()

app = Flask(__name__)

@app.route('/')
def index():
    pass


@app.route("/list")
def post_list():
    pass

@app.route("/post/<int:pid>")
def post():
    pass

@app.route("/login")
def login():
    data = request.get_json()
    id = data.get("id")
    password = data.get("password")

    user = DB.login(id, password)
    if user:
        return jsonify({"result": "success", "uid": user['localId']}), 200
    else:
        return jsonify({"result": "fail"}), 400
 
@app.route("/signin", methods=["POST"])
def signin():
    data = request.get_json()
    id = data.get("id")
    password = data.get("password")
    name = data.get("name")
    gender = data.get("gender")
    birth = data.get("birth")
    address = data.get("address")
    mbti = data.get("mbti", None)
    plant = data.get("plant", None)

    result = DB.signin(id, password, name, gender, birth, address, mbti, plant)
    if result:
        return jsonify({"result": "success"}), 200
    else:
        return jsonify({"result": "fail"}), 400

@app.route("/user/<uid>")
def user(uid):
    data = DB.get_user(uid)
    if data:
        return jsonify({"result": "success", "data": data}), 200
    else:
        return jsonify({"result": "fail"}), 400

@app.route("/write", methods=["POST"])
def write():
    data = request.get_json()
    author_uid = data.get("author_uid")
    title = data.get("title")
    contents = data.get("contents")
    capacity = data.get("capacity")
    state = data.get("state", "open")
    timestamp = data.get("timestamp", None)
    pid = DB.write_post(author_uid, title, contents, capacity, state, timestamp)
    if pid:
        return jsonify({"result": "success", "pid": pid}), 200
    else:
        return jsonify({"result": "fail"}), 400

@app.route("/write_done", methods=["POST"])
def write_done():
    pass

if __name__ == "__main__":
    app.run(host = "0.0.0.0", debug=True)