import base64
from io import BytesIO
import os
from PIL import Image

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
    
    def __init__(self,name,type,last_modified,size,thumbnail):
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