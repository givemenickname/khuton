# firebase_init.py
import firebase_admin
from firebase_admin import credentials, firestore, auth

cred = credentials.Certificate("path/to/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()
