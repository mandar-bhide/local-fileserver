import base64
from io import BytesIO
import os
from PIL import Image
import uuid

def generate_thumbnail_and_encode(path):
    original_image = Image.open(path)
    thumbnail = original_image.copy()
    thumbnail.thumbnail((80,80))
    thumbnail_stream = BytesIO()
    thumbnail.save(thumbnail_stream, format="JPEG")
    thumbnail_bytes = thumbnail_stream.getvalue()
    base64_encoded_thumbnail = base64.b64encode(thumbnail_bytes).decode("utf-8")
    return base64_encoded_thumbnail

class FileEntry:    
    def __init__(self,id,name,type,last_modified,size,thumbnail):
        self.id = id,
        self.name = name
        self.type = type
        self.last_modified = last_modified
        self.size = size
        self.thumbnail = thumbnail

    def from_path(path):  
        if path.endswith('.jpg') or path.endswith('.png') or path.endswith('.jpeg'):
            thumb = generate_thumbnail_and_encode(f"files\\{path}") 
        else:
            thumb = "none"
        return FileEntry(
            name = os.path.basename(path),
            thumbnail = thumb, 
            type = 'file' if os.path.isfile(f'files/{path}') 
                else 'folder' if os.path.isdir(f'files/{path}') 
                else None,            
            last_modified = os.path.getmtime(f'files/{path}') if os.path.isfile(f'files/{path}') else None,
            size = os.path.getsize(f'files/{path}') if os.path.isfile(f'files/{path}') else None
        )
    
    def to_json(self):
        return {
            "name":self.name,
            "type":self.type,
            "lastm":self.last_modified,
            "size":self.size,
            "thumbnail":self.thumbnail
        }
    
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