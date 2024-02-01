from flask import Flask, send_file, request, jsonify, render_template
import os
import json
import socket

from file_handling import FileEntry


app = Flask(__name__)
ip = socket.gethostbyname(socket.gethostname())

@app.route('/')
def index():
    host = request.headers.get('Host')
    print(host)    
    return render_template('index.html',address=ip+":"+host.split(':')[1])

@app.route('/directory',methods=['POST'])
def directory():
    path = '\\'.join(json.loads(request.data)['path'])
    if os.path.exists(f"files\\{path}"):
        return jsonify({'status':200,'files':[FileEntry.from_path(f"{path}\\{f}").to_json() for f in os.listdir(f"files\\{path}")]})

    return jsonify({'status':404})

@app.route('/file',methods=['POST'])
def file():
    path = '\\'.join(json.loads(request.data)['path'])
    if os.path.exists(f'files\\{path}'):        
        return send_file(f'files\\{path}')
    return 404

@app.route('/upload',methods=['POST'])
def upload_file():
    try:
        path = request.form.get('path')
        file = request.files['file']        
        if os.path.exists(f"files\\{path}"):
            file.save(f"files\\{path}\\{file.filename}")
            return "", 200
        print(f"No such directory {path}")
        return "Directory not found",404
    except Exception as e:
        print(e)
        return str(e), 500
    
@app.route('/test')
def test():
    return "",200

if __name__=='__main__':    
    app.run(debug=True,host=ip)

