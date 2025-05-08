from flask import Flask 
app = Flask(__name__)


@app.route('/')
def index():
    return '''<doctype html>
    <html>
        <body>
            <h1><a href = "/read/1/">html</a></li>
            <o1>
                <li><a href="read/1/">html</a></li>
                <li><a href="read/2/">css</a></li>
                <li><a href="read/3/">javascript</a></li>
            </o1>
            <h2>Welcome</h2>
            Hello, Web
        </body>
    </html>
'''

@app.route('/create/')
def create():
    return 'create'

@app.route('/read/<id>/')
def read(id):
    print (id)

    return 'read ' + id


app.run(debug=True)