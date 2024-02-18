import 'package:files_client/Colors.dart';
import 'package:files_client/DirectoryEntry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  static checkIPandPort(String val){    
    final RegExp ipRegex =
        RegExp(r'^([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.'
              r'([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.'
              r'([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.'
              r'([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$',);
    final RegExp portRegex = RegExp(r'^(0|6553[0-5]|655[0-2]\d|65[0-4]\d{2}|6[0-4]\d{3}|[1-5]\d{4}|\d{1,4})$');
    List<String> parts = val.split(':');
    if (parts.length != 2) {
      return false; 
    }
    return ipRegex.hasMatch(parts[0]) && portRegex.hasMatch(parts[1]);
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


}

class Logo extends StatelessWidget {
  const Logo({super.key, this.size = 45.0});
  final double? size;
  @override
  Widget build(BuildContext context) {
    return RichText(
      text:TextSpan(
        children: [
          TextSpan(text:"Home",style:TextStyle(fontWeight:FontWeight.w700,fontSize:size,color:CustomColors.primaryColor.withOpacity(1))),
          TextSpan(text:"Cloud",style:TextStyle(fontWeight:FontWeight.w700,fontSize:size,color:Colors.black))
        ]
      )
    );
  }
}