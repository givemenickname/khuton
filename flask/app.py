from flask import Flask, redirect, render_template, request, url_for, jsonify
from DB_handler import DBModule

DB = DBModule()

app = Flask(__name__)

@app.route('/')
def index():
    pass

@app.route("/post/<int:pid>") #pid 기반으로 게시글 정보 가져오기
def post(pid):
    data = DB.get_post(pid)
    if data:
        return jsonify({"result": "success", "data": data}), 200
    else:
        return jsonify({"result": "fail"}), 400


@app.route("/login") # 로그인
def login():
    data = request.get_json()
    id = data.get("id")
    password = data.get("password")

    user = DB.login(id, password)
    if user:
        return jsonify({"result": "success", "uid": user['localId']}), 200
    else:
        return jsonify({"result": "fail"}), 400
 
@app.route("/signin", methods=["POST"]) # 회원가입
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

@app.route("/user/<uid>")  # uid 기반으로 사용자 정보 가져오기
def user(uid):
    data = DB.get_user(uid)
    if data:
        return jsonify({"result": "success", "data": data}), 200
    else:
        return jsonify({"result": "fail"}), 400

@app.route("/write", methods=["POST"]) # 게시글 작성
def write():
    data = request.get_json()
    uid = data.get("uid")
    title = data.get("title")
    contents = data.get("contents")
    capacity = data.get("capacity")
    state = data.get("state", "open")
    pid = DB.write_post(uid, title, contents, capacity, state)
    if pid:
        return jsonify({"result": "success", "pid": pid}), 200
    else:
        return jsonify({"result": "fail"}), 400
    
@app.route("/search", methods=["POST"]) # 게시글 검색(제목)
def search(): 
    data = request.get_json()
    keyword = data.get("keyword")
    posts = DB.search_post(keyword)
    if posts:
        return jsonify({"result": "success", "posts": posts}), 200
    else:
        return jsonify({"result": "fail"}), 400

if __name__ == "__main__":
    app.run(host = "0.0.0.0", debug=True)