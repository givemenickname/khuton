from flask import Flask, redirect, render_template, request, url_for
from DB_handler import DBModule

DB = DBModule()

app = Flask(__name__)

@app.route('/')
def index():
    pass


@app.route("list")
def post_list():
    pass

@app.route("/post/<int:pid>")
def post():
    pass

@app.route("/login")
def longin():
    pass
 
@app.route("/signin")
def signin():
    pass

@app.route("/user/<uid>")
def user():
    pass

@app.route("/write")
def write():
    pass

@app.route("/write_done", methods=["GET"])
def write_done():
    pass

if __name__ == "__main__":
    app.run(host = "0.0.0.0", debug=True)