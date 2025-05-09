from flask import Flask
from DB_handler import DBModule

DB = DBModule()

app = Flask(__name__)

 