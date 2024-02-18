from genericpath import isfile
import os
import json
import uuid

from file_handling import generate_thumbnail_and_encode

def get_size(path,curr_path=''):
    if curr_path != '':
        curr_path += "\\"
    curr_path += path
    if os.path.isfile(curr_path):
        return os.path.getsize(curr_path)  
    else:
        size = 0
        for f in os.listdir(curr_path):
            size += get_size(f,curr_path=curr_path)
        return size

#print(get_size('files'))

def debug_print(text):
    print(f"[DEBUG] {text}")

def get_dir(path,curr_path=''):
    if curr_path != '':
        curr_path += "\\"
    curr_path += path
    
    files = []

    if os.path.isdir(curr_path):
        return {
            'id':str(uuid.uuid4()),
            'name': path,
            'path': curr_path,
            'type':'dir',
            'size':get_size(curr_path),
            'children':[get_dir(f,curr_path=curr_path) for f in os.listdir(curr_path)]
        }

    else:    
        return {
            'id':str(uuid.uuid4()),
            'name': path,
            'path': curr_path,
            'type':'file',
            'thumbnail': generate_thumbnail_and_encode(curr_path) if curr_path.endswith('.jpg') or curr_path.endswith('.jpeg') or curr_path.endswith('.png') else None,                
            'size':get_size(curr_path)
        }            



with open('filestrcuture.json','w') as f:
    f.write(json.dumps(get_dir('files')))

#print(os.listdir("files\\folder\\folder1"))

