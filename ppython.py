from flask import Flask, request, render_template_string

app = Flask(__name__)

# HTML 폼 템플릿
signup_form = '''
<!DOCTYPE html>
<html>
<head><title>Signup</title></head>
<body>
    <h2>회원가입</h2>
    <form method="POST">
        이름: <input type="text" name="name"><br>
        이메일: <input type="email" name="email"><br>
        비밀번호: <input type="password" name="password"><br>
        <input type="submit" value="가입하기">
    </form>
</body>
</html>
'''

# 결과 출력 템플릿
result_page = '''
<!DOCTYPE html>
<html>
<head><title>Signup Result</title></head>
<body>
    <h2>가입 완료</h2>
    <p>이름: {{ name }}</p>
    <p>이메일: {{ email }}</p>
</body>
</html>
'''

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        password = request.form['password']

        # 여기서 DB 저장 또는 검증 로직을 넣을 수 있음
        print(f"이름: {name}, 이메일: {email}, 비밀번호: {password}")

        return render_template_string(result_page, name=name, email=email)
    
    return signup_form

if __name__ == '__main__':
    app.run(debug=True)
