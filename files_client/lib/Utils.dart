import 'dart:io';

import 'package:file_icon/file_icon.dart';
import 'package:files_client/DirectoryEntry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class Utils{
  static String formatFileSize(int fileSizeInBytes) {
    const int kilobyte = 1024;
    const int megabyte = kilobyte * 1024;
    const int gigabyte = megabyte * 1024;

    if (fileSizeInBytes >= gigabyte) {
      double sizeInGB = fileSizeInBytes / gigabyte;
      return '${sizeInGB.toStringAsFixed(2)} GB';
    } else if (fileSizeInBytes >= megabyte) {
      double sizeInMB = fileSizeInBytes / megabyte;
      return '${sizeInMB.toStringAsFixed(2)} MB';
    } else if (fileSizeInBytes >= kilobyte) {
      double sizeInKB = fileSizeInBytes / kilobyte;
      return '${sizeInKB.toStringAsFixed(2)} KB';
    } else {
      return '$fileSizeInBytes bytes';
    }
  }

  static Future<List<DirectoryEntry>> loadMockData() async {
    Future.delayed(const Duration(milliseconds:600));
    return List.empty();
    /*return List<DirectoryEntry>.of([
      DirectoryEntry(
        name:"folder", 
        type:"folder",
        lastModified:DateTime.fromMillisecondsSinceEpoch((1699599645.411268*1000).toInt())
      ),
      DirectoryEntry(
        name:"file.jpg", 
        type:"file",
        lastModified:DateTime.fromMillisecondsSinceEpoch((1699599645.411268*1000).toInt())
      )]);*/
  }

  static loadIcon(List<String> path, DirectoryEntry entry) async {
    if(entry.type=="folder") return Icon(CupertinoIcons.folder,size:32,color:const Color(0xFFC84B31));
    if(entry.name.endsWith(".jpg") || entry.name.endsWith(".jpeg") || entry.name.endsWith(".png")){
      final dir = (await getTemporaryDirectory()).path;
      File file = File(dir);
      final bytes = await FlutterImageCompress.compressWithList(await file.readAsBytes(),minWidth:50,minHeight:50,quality:85);
      return Image.memory(bytes);
    }else{
      return FileIcon(entry.name);
    }
  }
}