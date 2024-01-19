// ignore_for_file: file_names

import 'dart:io';

import 'package:files_client/DirectoryEntry.dart';

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
}