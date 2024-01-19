// ignore_for_file: file_names
import 'package:files_client/Utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DirectoryEntry{
  String name,type;
  DateTime? lastModified;
  int? size;
  DirectoryEntry({required this.name,required this.type,this.lastModified,this.size});

  factory DirectoryEntry.fromJson(response) =>
    DirectoryEntry(
      name: response['name'],
      type: response['type'],
      lastModified: response['type']=='file'?
        DateTime.fromMillisecondsSinceEpoch((response['lastm']*1000).toInt()):
        null,
      size: response['type']=='file'?
        response['size']:
        null     
    );

  
}

class DirectoryEntryTile extends StatelessWidget {
  const DirectoryEntryTile({super.key,required this.entry, this.onPressed});
  final DirectoryEntry entry;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:4,vertical:18),
        child:Row(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Icon(entry.type=='file'?Icons.description_outlined:Icons.folder_outlined,size:32,color:const Color(0xFFC84B31)),
            const SizedBox(width:20),
            Expanded(
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Text(entry.name,style:const TextStyle(fontSize:16)),
                  entry.type=='file'?Text(
                    "Last modified: ${DateFormat('dd/MM/yyyy hh:mm a').format(entry.lastModified!)}",
                    style: const TextStyle(color:Colors.black54)
                  ):const SizedBox(height:0,width:0)
                ],
              ),
            ),
            entry.type=='file'?
              Text(Utils.formatFileSize(entry.size!)):const SizedBox(height:0,width:0)
          ],
        )
      ),
    );
  }
}