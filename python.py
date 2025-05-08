from flask import Flask 
app = Flask(__name__)


@app.route('/')
def index():
    return 'Welcome'

@app.route('/create/')
def create():
    return 'create'

app.route('/read/1/')
def read():
    return 'read 1 '

