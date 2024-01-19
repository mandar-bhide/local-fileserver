import json
import os

class FileEntry:
    
    def __init__(self,name,type,last_modified,size):
        self.name = name
        self.type = type
        self.last_modified = last_modified
        self.size = size

    def from_path(path):
        return FileEntry(
            name = os.path.basename(path),
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
            "size":self.size
        }