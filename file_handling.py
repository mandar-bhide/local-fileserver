import os
import shutil
from werkzeug.datastructures import FileStorage
from io import BytesIO
from PIL import Image
import base64
from db import FileEntry, FileDB
from flask import jsonify

def generate_thumbnail_and_encode(path):
   original_image = Image.open(path)
   thumbnail = original_image.copy()
   thumbnail.thumbnail((80,80))
   thumbnail_stream = BytesIO()
   thumbnail.save(thumbnail_stream, format="JPEG")
   thumbnail_bytes = thumbnail_stream.getvalue()
   base64_encoded_thumbnail = base64.b64encode(thumbnail_bytes).decode("utf-8")
   return base64_encoded_thumbnail

class FileHandler:
    def __init__(self,file_root="files"):
        self.file_root= file_root

    def create_file(self,file:FileStorage,path:str,db:FileDB):
        thumb = None
        file.save(f"files\\{path}\\{file.filename}")
        if file.path.endswith('.jpg') or file.path.endswith('.png') or file.path.endswith('.jpeg'):
            thumb = generate_thumbnail_and_encode(f"files\\{path}\\{file.filename}") 
        f = FileEntry.new(
            name = file.filename,
            parent_id = path.split("\\")[-1],
            size = os.path.getsize(f"files\\{path}\\{file.filename}"),
            thumbnail = thumb,
            type = "file",
            path = path
        )
        try:
            db.create_file_entry(f)
            return jsonify({'inserted_id':f.id}), 200
        except Exception as e:
            return jsonify({'error':str(e)}), 500
    
    def delete(self,id:str,db:FileDB):
        f = db.get_db_entry(id=id)
        if f.type=='file':
            db.delete_file(file_id=id)
            os.remove(f"files\\{f.path}\\{f.name}")
        elif f.type=='folder':
            db.delete_directory(directory_id=id)
            shutil.rmtree(f"files\\{f.path}\\{f.name}")
        
    