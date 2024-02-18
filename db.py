from datetime import datetime
import uuid
import psycopg2
from io import BytesIO
from PIL import Image
import base64

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
   def __init__(self,id,name,type,date_modified,size,thumbnail,date_created,parent_id):
      self.id = id,
      self.name = name
      self.type = type
      self.date_modified = date_modified
      self.size = size
      self.thumbnail = thumbnail
      self.date_created = date_created,
      self.parent_id = parent_id

   staticmethod
   def new(name,type,parent_id,size=0,thumbnail=None):
      now = datetime.now()
      return FileEntry(
         id = str(uuid.uuid4()),
         name = name,
         type = type,
         size = size,
         date_created = now,
         thumbnail = thumbnail,
         date_modified = now,
         parent_id = parent_id
      )     
   
   def to_json(self):
      return {
         "id" : self.id,
         "name" : self.name,
         "type" : self.type,
         "size" : self.size,
         "date_created" : self.date_created,
         "date_modified" : self.date_modified,
         "thumbnail" : self.thumbnail,
         "parent_id" : self.parent_id
      }
      

class FileDB:
   def __init__(self,tablename="filesystem"):
      self.connection = FileDB.connect()
      self.cursor = self.connection.cursor()
      self.tablename = tablename

   def close(self):
      self.cursor.close()
      self.connection.close()

   staticmethod
   def connect():    
      return psycopg2.connect(
         database="fileserver_db", user='postgres', password='mandar', host='127.0.0.1', port= '5432'
      )
   
   #Checked
   def create_file_entry(self,file:FileEntry):
      data = (
         file.size,
         file.type,
         file.id,                  
         file.name,
         file.parent_id,
         file.thumbnail,
         file.date_created,
         file.date_modified
      )
      try:
         self.cursor.execute(f"INSERT INTO {self.tablename} (size,type,id,display_name,parent_id,thumbnail,date_created,date_modified) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",data)
         self.connection.commit()
      except Exception as e:
         self.connection.rollback()
         raise e

   def get_directory(self,directory_id):
      try:
         self.cursor.execute(f"SELECT * FROM {self.tablename} WHERE parent_id=%s",(directory_id,))
         rows = self.cursor.fetchall()
         return rows
      except Exception as e:
         print(str(e))

   # Checked      
   def delete_file(self,file_id):
      try:
         self.cursor.execute(f"DELETE FROM {self.tablename} WHERE id=%s",(file_id,))
         self.connection.commit()
      except Exception as e:
         self.connection.rollback()
         raise e
      
   # Checked
   def rename_file(self,file_id,new_name):
      try:
         self.cursor.execute(f"UPDATE {self.tablename} SET display_name=%s WHERE id=%s",(new_name,file_id))
         self.connection.commit()
      except Exception as e:
         self.connection.rollback()
         raise e
      
   # Checked
   def move_file(self,file_id,new_parent_id):
      try:
         self.cursor.execute(f"UPDATE {self.tablename} SET parent_id=%s WHERE id=%s",(new_parent_id,file_id))
         self.connection.commit()
      except Exception as e:
         self.connection.rollback()
         raise e
      
   # Checked
   def change_last_modified(self,file_id):
      now = datetime.now()
      try:
         self.cursor.execute(f"UPDATE {self.tablename} SET date_modified=%s WHERE id=%s",(now,file_id))
         self.connection.commit()
      except Exception as e:
         self.connection.rollback()
         raise e
      
   
if __name__=='__main__':   
   db = FileDB()
   for item in db.get_directory("files"):
      for val in item:
         print(val)



#   column_name  | data_type
# ---------------+-----------
#  type          | text
#  size          | integer
#  parent_id     | text
#  thumbnail     | text
#  date_created  | text
#  id            | text
#  date_modified | text
#  display_name  | text
