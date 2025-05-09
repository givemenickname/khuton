import firebase_admin
from firebase_admin import credentials, db

# 서비스 계정 키 경로 (네가 받은 JSON 파일 경로)
cred = credentials.Certificate("auth/firebaseKey.json")

# Firebase 프로젝트의 Realtime Database URL
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://khuthon-ff826-default-rtdb.asia-southeast1.firebasedatabase.app'
})


# 테스트: 데이터 읽기/쓰기
ref = db.reference('test')
ref.set({
    'message': 'Firebase 연결 성공!'
})

print("✅ Firebase에 성공적으로 연결되었습니다.")
