import 'dart:convert';
import 'dart:typed_data';
import 'package:files_client/CustomFileIcon.dart';
import 'package:files_client/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Colors.dart';

class DirectoryEntry{
  String name,type;
  DateTime? lastModified;
  int? size;  
  Uint8List? thumbnail;
  DirectoryEntry({required this.name,required this.type,this.lastModified,this.size,this.thumbnail});  

  factory DirectoryEntry.fromJson(response) =>
    DirectoryEntry(
      name: response['name'],
      type: response['type'],
      thumbnail: response['thumbnail']!="none"?base64Decode(response['thumbnail']):null,
      lastModified: response['type']=='file'?
        DateTime.fromMillisecondsSinceEpoch((response['lastm']*1000).toInt()):
        null,
      size: response['type']=='file'?
        response['size']:
        null     
    );

}

class DirectoryEntryTile extends StatefulWidget {
  const DirectoryEntryTile({super.key,required this.entry, this.onPressed, this.onLongPress});
  final DirectoryEntry entry;
  final Function()? onPressed; 
  final Function()? onLongPress;
  @override
  State<DirectoryEntryTile> createState() => _DirectoryEntryTileState();
}

class _DirectoryEntryTileState extends State<DirectoryEntryTile> {

  bool isSelected = false;

  getSizeText()=>widget.entry.type=='file'
    ? Text(Utils.formatFileSize(widget.entry.size!),style:TextStyle(color:CustomColors.getTextColor().withOpacity(0.45),fontSize:12))
    : const SizedBox(height:0,width:0);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: DirectoryEntryIcon(entry:widget.entry),
      title: Text(widget.entry.name,style:TextStyle(fontSize:16,color:CustomColors.getTextColor(),fontWeight:FontWeight.w500),maxLines:1),
      trailing: getSizeText(),  
      selected: isSelected,
      selectedTileColor: CustomColors.lightLight.withOpacity(0.2),
      contentPadding: EdgeInsets.symmetric(vertical:4,horizontal:12),
      onTap: (){
        if(isSelected){
          setState(() {
            isSelected = false;
          });
        }else{
          widget.onPressed!();
        }                
      },
      onLongPress: (){
        setState(() {
          isSelected = !isSelected;
        });
        widget.onLongPress!();
      },    
    );
  }
}

class DirectoryEntryIcon extends StatelessWidget {
  final DirectoryEntry entry;
  const DirectoryEntryIcon({super.key,required this.entry});
  @override
  Widget build(BuildContext context) {
    return Container(
      width:45,
      height:47,
      decoration:BoxDecoration(
        color:entry.type=="folder"
          ? Color(0x00000000)
          : entry.thumbnail != null 
            ? Color(0x00000000)
            : CustomColors.getLightColor(),
        borderRadius:BorderRadius.circular(12)
      ),
      child:Center(
        child:entry.type=="folder"
          ?Icon(CupertinoIcons.folder,size:30,color:CustomColors.primaryColor)
          :entry.thumbnail!=null
            ?Image.memory(entry.thumbnail!,width:45)
            :Icon(FileIcon(entry.name)),
      )
    );
  }
}