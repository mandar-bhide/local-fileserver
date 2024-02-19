from flask import Flask, send_file, request, jsonify, render_template
import os
import json
import socket
from db import FileEntry, FileDB
from file_handling import FileHandler

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
    data = json.loads(request.data)
    path = '\\'.join(data['path'])    
    if os.path.exists(f'files\\{path}'): 
        try:
            FileDB().change_last_modified(data['path'].split('\\')[-1])
            return send_file(f'files\\{path}')
        except Exception as e:
            return jsonify({'error':str(e)}), 500
    return 404

@app.route('/upload',methods=['POST'])
def upload_file():
    try:
        path = request.form.get('path')
        file = request.files['file']           
        if os.path.exists(f"files\\{path}"):
            FileHandler().create_file(file=file,path=path)
        print(f"No such directory {path}")
        return "Directory not found",404
    except Exception as e:
        print(e)
        return str(e), 500
    
@app.route('/create-dir',methods=['POST'])
def create_dir():
    data = json.loads(request.data)
    f = FileEntry.new(
        name = data['name'],
        parent_id = data['path'].split("\\")[-1],
        thumbnail = None,
        type = "folder"
    )
    try:
        FileDB().create_file_entry(f)
        return jsonify({'inserted_id':f.id}), 200
    except Exception as e:
        return jsonify({'error':str(e)}), 500
    pass

@app.route('/test')
def test():
    return "",200

if __name__=='__main__':    
    app.run(debug=True,host=ip)

