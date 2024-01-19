from genericpath import isfile
from flask import Flask,send_file,request,jsonify
import os

from file_handling import FileEntry


app = Flask(__name__)

@app.route('/')
def index():
    host = request.headers.get('Host')
    return f'<h1>Works! {host}</h1>'

@app.route('/files/<string:path>')
def files(path):
    files = os.listdir(f'files/{path}')
    resp = []
    for file in files:        
        resp.append(FileEntry.from_path(file).to_json())
    return jsonify(resp)

@app.route('/files')
def files_root():
    files = os.listdir('files')
    resp = []
    for file in files:        
        resp.append(FileEntry.from_path(file).to_json())
    return jsonify(resp)

@app.route('/file/<string:path>')
def get_file(path):
    if os.path.exists(f'files/{path}'):
        print('exists')
        return send_file(f'files/{path}')
    return f'<h1> Error 404. Path {path} not found'

if __name__=='__main__':
    app.run(debug=True,host='192.168.0.106',port=5000)