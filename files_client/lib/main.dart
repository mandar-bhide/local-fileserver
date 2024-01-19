// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'DirectoryEntry.dart';
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,      
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  File? file;  
  final _baseUrl = "192.168.0.106:5000";
  String currentPath = "";

  Future<List<DirectoryEntry>> getFiles() async {
    List<DirectoryEntry> directoryEntries = [];
    final res = await http.get(Uri.http(_baseUrl,currentPath==""?'files':'files/$currentPath'));
    final decoded = jsonDecode(res.body);
    decoded.forEach((el){
      directoryEntries.add(DirectoryEntry.fromJson(el));
    });
    return directoryEntries;
  }

  getFile(String filename) async {
    final dir = (await getTemporaryDirectory()).path;
    List<List<int>> chunks = List<List<int>>.empty(growable:true);
    final client = http.Client();
    final request = http.Request("GET",Uri.http(_baseUrl,"file/$filename"));
    final res = client.send(request);
    res.asStream().listen((http.StreamedResponse response) {
      response.stream.listen((chunk) {
        chunks.add(chunk);
      })
        .onDone(() async {
          file = File("$dir/$filename");
          final Uint8List bytes = Uint8List(response.contentLength!);
          int offset = 0;
          for (List<int> chunk in chunks) {
            bytes.setRange(offset, offset + chunk.length, chunk);
            offset += chunk.length;
          }            
          file!.writeAsBytes(bytes).then(
            (value) async {
              await OpenFilex.open(value.path);
            }
          );                    
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical:5,horizontal:5),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.home,color:Colors.black54),
                    onPressed: (){
                      setState(() {
                        currentPath = "";
                      });
                    },
                  ),
                  Text(
                    "/$currentPath",
                    style:TextStyle(fontSize:16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getFiles(),//Utils.loadMockData(),
                builder:(ctx,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  } else if(snapshot.hasError){
                    return Center(
                      child: Text("Something went wrong!")
                    );
                  }else if(snapshot.data!.isEmpty){
                    return Center(child: Text("No files",style:TextStyle(color:Colors.black87,fontSize:17)));
                  }else{
                    return ListView.builder(
                      itemBuilder: (ctx,index)
                        =>DirectoryEntryTile(
                          entry:snapshot.data![index],
                          onPressed: (){
                            if(snapshot.data![index].type=="folder"){     
                              if(currentPath==''){
                                setState(() {
                                  currentPath+=snapshot.data![index].name;
                                });
                              }else{
                                setState(() {
                                  currentPath+="/${snapshot.data![index].name}";
                                });
                              }                         
                              
                            }else{
                              getFile("$currentPath/${snapshot.data![index].name}");
                            }
                          },
                        ),
                      itemCount:snapshot.data!.length,
                    );
                  }
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}





