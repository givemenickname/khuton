from flask import Flask, redirect, render_template, request, url_for, jsonify
from DB_handler import DBModule
from flask_cors import CORS
DB = DBModule()

app = Flask(__name__)
CORS(app)

@app.route('/')
def index():
    pass

@app.route("/post/<int:pid>") #pid 기반으로 게시글 정보 가져오기
def post(pid):
    data = DB.get_post_by_pid(pid)
    if data:
        return jsonify({"result": "success", "data": data}), 200
    else:
        return jsonify({"result": "fail"}), 400


@app.route("/login", methods = []) # 로그인
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
    
@app.route("/chat/send", methods=["POST"])
def send_chat_message():
    data = request.get_json()
    chatroom_id = data.get("chatroom_id")
    sender_uid = data.get("sender_uid")
    content = data.get("content")

    success = DB.send_message(chatroom_id, sender_uid, content)
    if success:
        return jsonify({"result": "success"}), 200
    else:
        return jsonify({"result": "fail"}), 400

@app.route("/todo/add", methods=["POST"])
def add_todo():
    data = request.get_json()
    uid = data.get("uid")
    task = data.get("task")

    if not uid or not task:
        return jsonify({"result": "fail", "message": "uid 또는 task 누락"}), 400

    success = DB.write_todo_list(uid, task)
    if success:
        return jsonify({"result": "success", "message": "할 일 추가 완료"}), 200
    else:
        return jsonify({"result": "fail", "message": "서버 오류"}), 500

@app.route("/todo/group/<pid>", methods=["GET"])
def get_group_todo(pid):
    result = DB.to_do_list(pid)
    return jsonify({"result": "success", "data": result}), 200

@app.route("/calendar/add", methods=["POST"])
def calendar_add():
    data = request.get_json()
    pid = data.get("pid")
    date = data.get("date")  # 형식: YYYY-MM-DD
    event = data.get("event")

    if not pid or not date or not event:
        return jsonify({"result": "fail", "message": "필수 항목 누락"}), 400

    success = DB.add_calendar_event(pid, date, event)
    if success:
        return jsonify({"result": "success", "message": "일정 등록 완료"}), 200
    else:
        return jsonify({"result": "fail", "message": "등록 실패"}), 500

@app.route("/calendar/<pid>", methods=["GET"])
def calendar_get(pid):
    data = DB.get_calendar_events(pid)
    return jsonify({"result": "success", "data": data}), 200


if __name__ == "__main__":
    app.run(host = "0.0.0.0", port=5000, debug=True)