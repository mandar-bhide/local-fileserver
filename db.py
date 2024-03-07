from datetime import datetime
import subprocess
import uuid
import psycopg2
from psycopg2.extras import RealDictCursor


class FileEntry:    
   def __init__(self,id,name,type,date_modified,size,thumbnail,date_created,parent_id,path):
      self.id = id,
      self.name = name
      self.type = type
      self.date_modified = date_modified
      self.size = size
      self.thumbnail = thumbnail
      self.date_created = date_created,
      self.parent_id = parent_id
      self.path = path

   staticmethod
   def new(name,type,parent_id,path,size=0,thumbnail=None):
      now = datetime.now()
      return FileEntry(
         id = str(uuid.uuid4()).replace("-",""),
         name = name,
         type = type,
         size = size,
         date_created = now,
         thumbnail = thumbnail,
         date_modified = now,
         parent_id = parent_id,
         path=path
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
         "parent_id" : self.parent_id,
         "path" : self.path
      }
      
   staticmethod
   def from_db(db_row:list):
      return FileEntry(
         id = db_row['id'],
         name = db_row['display_name'],
         parent_id = db_row['parent_id'],
         size = db_row['size'],
         type = db_row['type'],
         thumbnail = db_row['thumbnail'],
         date_created = db_row['date_created'],
         date_modified = db_row['date_modified'],
         path = db_row['path']
      )
   
   def __str__(self) -> str:
      return f"id: {self.id} display_name: {self.name} parent_id: {self.parent_id} size: {self.size} type: {self.type} thumbnail: {self.thumbnail} date_created: {self.date_created} date_modified: {self.date_modified}"

class FileDB:
   def __init__(self,tablename="filesystem"):
      self.connection = FileDB.connect()
      self.cursor = self.connection.cursor(cursor_factory=RealDictCursor)
      self.tablename = tablename

   def close(self):
      self.cursor.close()
      self.connection.close()
      print(subprocess.Popen(['pg_ctl','stop','-D',"F:\\Postgresql\\data"]).wait())

   staticmethod
   def connect(): 
      #TODO Check this line at end   
      print(subprocess.Popen(['pg_ctl','start','-D',"F:\\Postgresql\\data"]).wait())
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
         file.date_modified,
         file.path
      )
      try:
         self.cursor.execute(f"INSERT INTO {self.tablename} (size,type,id,display_name,parent_id,thumbnail,date_created,date_modified,path) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",data)
         if file.type=="file":
            self.cursor.execute(f"UPDATE {self.tablename} SET size=size+%s WHERE id=%s",(file.size,file.parent_id,))
         self.connection.commit()
      except Exception as e:
         self.connection.rollback()
         raise e

   #Checked
   def get_directory(self,directory_id):
      try:
         self.cursor.execute(f"SELECT * FROM {self.tablename} WHERE parent_id=%s",(directory_id,))
         rows = self.cursor.fetchall()
         return [FileEntry.from_db(x).to_json() for x in rows]
      except Exception as e:
         print(str(e))

   #Checked
   def get_db_entry(self,id)->FileEntry:
      try:
         self.cursor.execute(f"SELECT * FROM {self.tablename} WHERE id=%s",(id,))
         rows = self.cursor.fetchall()
         if len(rows)>0:
            return FileEntry.from_db(rows[0])
         return None
      except Exception as e:
         print(str(e))
   
   #Checked
   def delete_directory(self,directory_id):
      now = datetime.now()
      try:         
         d = self.get_db_entry(id=directory_id)         
         self.cursor.execute(f"DELETE FROM {self.tablename} WHERE id=%s",(d.id,))
         self.cursor.execute(f"DELETE FROM {self.tablename} WHERE parent_id=%s",(d.id,))    
         self.cursor.execute(f"UPDATE {self.tablename} SET date_modified=%s,size=size-%s WHERE id=%s",(now,d.size,d.parent_id))     
         self.connection.commit()         
      except Exception as e:
         self.connection.rollback()
         raise e

   #Checked      
   def delete_file(self,file_id):
      now = datetime.now()
      try:
         d = self.get_db_entry(id=file_id)
         self.cursor.execute(f"DELETE FROM {self.tablename} WHERE id=%s",(file_id,))
         self.cursor.execute(f"UPDATE {self.tablename} SET date_modified=%s,size=size-%s WHERE id=%s",(now,d.size,d.parent_id,))
         self.connection.commit()
      except Exception as e:
         self.connection.rollback()
         raise e
      
   #Checked
   def rename_file_folder(self,file_id,new_name):
      now = datetime.now()
      try:
         self.cursor.execute(f"UPDATE {self.tablename} SET display_name=%s, date_modified=%s  WHERE id=%s",(new_name,now,file_id))
         self.connection.commit()
      except Exception as e:
         self.connection.rollback()
         raise e
      
   #Checked
   def move_file_folder(self,file_id,new_parent_id):
      now = datetime.now()
      try:
         self.cursor.execute(f"UPDATE {self.tablename} SET parent_id=%s, date_modified=%s WHERE id=%s",(new_parent_id,now,file_id))
         self.connection.commit()
      except Exception as e:
         self.connection.rollback()
         raise e
      
   #Checked
   def change_last_modified(self,file_id):
      now = datetime.now()
      try:
         self.cursor.execute(f"UPDATE {self.tablename} SET date_modified=%s WHERE id=%s",(now,file_id))
         self.connection.commit()
      except Exception as e:
         self.connection.rollback()
         raise e
      
def create_mock_data(db:FileDB):
   folder = FileEntry.new(
      name = "NewFolder",
      type = "folder",
      parent_id = "files",
      size = 0
   )
   files = [FileEntry.new(
      name = f"NewFile{x}.jpg",
      type = "file",
      parent_id = folder.id,
      size = 100*x
   ) for x in range(5)]

   db.create_file_entry(folder)
   for f in files:
      db.create_file_entry(f)
   
if __name__=='__main__':   
   db = FileDB()   
   # DO SOMETHING
   print(db.get_directory(directory_id="eaad924951744459be64b81c4184bef2"))
   db.close()
   
      
           



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
#  path  | text
