# app.py
from flask import Flask, jsonify, request
from firebase_init import db

app = Flask(__name__)

@app.route('/add-user', methods=['POST'])
def add_user():
    data = request.json
    doc_ref = db.collection('users').document()
    doc_ref.set(data)
    return jsonify({'status': 'user added'}), 200

if __name__ == '__main__':
    app.run(debug=True)
