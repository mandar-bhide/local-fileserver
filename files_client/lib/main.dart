import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:files_client/Colors.dart';
import 'package:files_client/Landing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DirectoryEntry.dart';
import 'package:file_picker/file_picker.dart';

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
      home: LandingPage(),
      theme: ThemeData(
        fontFamily: 'Montserrat',      
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.address});
  final String address;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  File? file;    
  List<String> currentPath = [];
  List<DirectoryEntry> currentDirectory = [];
  final client = http.Client();
  bool? loading;

  @override
  void initState(){
    saveUrl();
    loading = true;
    getDirectory();
    super.initState();
  }

  saveUrl() async {
    (await SharedPreferences.getInstance()).setString("baseUrl",widget.address);
  }

  Future<void> getDirectory({String? directory}) async { 
    if(directory==null){
      directory="";
    }
    setState(() {
      loading = true;
    });
    var path = currentPath;    
    path.add(directory);    
    final res = await http.post(Uri.parse("http://${widget.address}/directory"),
      body: jsonEncode({
        "path":path
      })
    );
    final decoded = jsonDecode(res.body);
    if(decoded['status']==200){
      List<DirectoryEntry> dir_temp = [];
      decoded['files'].forEach((e)=>dir_temp.add(DirectoryEntry.fromJson(e)));
      setState(() {
        currentDirectory = dir_temp;
        currentPath = path.where((element) => element!='').toList();
        loading = false;
      });    
    }  else{
      setState(() {
        loading=false;
      });
    }  
  }

  getFile(String filename) async {
    final dir = (await getTemporaryDirectory()).path;
    List<List<int>> chunks = List<List<int>>.empty(growable:true);    
    final request = http.Request("POST",Uri.parse("http://${widget.address}/file"))
      ..headers['Content-Type'] = 'application/json'; 
    request.body = jsonEncode({'path':currentPath+[filename]});
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

  getPath(){
    String pathString = "";
    currentPath.forEach((element) {pathString+=element+" > ";});
    return pathString;
  }

  uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(      
      allowCompression: false,      
    );

    final request = http.MultipartRequest('POST',Uri.parse("http://${widget.address}/upload"));
    request.fields['path'] = currentPath.join('\\');
    request.files.add(await http.MultipartFile.fromPath('file',result!.paths.first!));
    final response = await client.send(request);
    if(response.statusCode==200){
      showFileDialog(true);      
      getDirectory();      
    }else{
      showFileDialog(false);
    }
    Future.delayed(Duration(seconds:2),(){Navigator.of(context).pop();});
    await FilePicker.platform.clearTemporaryFiles();
  }

  closeServerDialog() async {
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        backgroundColor: Colors.white,
        icon: Icon(Icons.error_outline_rounded,color:Colors.red.shade700,size:40),
        title: Text("Disconnect server?"),
        content: Text("You will need host and port or QR code to reconnect.",style:TextStyle(fontSize:14)),
        actions: [          
          TextButton(
            onPressed:closeServer,
            child: Text("Proceed",style:TextStyle(color:Colors.red.shade700,fontSize:17)),
          ),
          TextButton(
            onPressed:(){Navigator.of(context).pop();},
            child: Text("Cancel",style:TextStyle(color:Colors.black,fontSize:17)),
          )
        ],
      )
    );
  }

  closeServer() async {
    (await SharedPreferences.getInstance()).clear();
    final navigator = Navigator.of(context);
    while(navigator.canPop()){
      navigator.pop();
    }
    navigator.push(MaterialPageRoute(
      builder: (context)=>ServerAddressForm()
    ));
  }

  showFileDialog(isSuccess){
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context){
        return Dialog(
          surfaceTintColor:CustomColors.getBgColor(),
          insetPadding: EdgeInsets.symmetric(vertical:300,horizontal:50),
          child: Center(
            child: Container(                                        
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isSuccess?"File upload successful!":"Something went wrong",style:TextStyle(color:CustomColors.getTextColor(),fontWeight:FontWeight.bold)),
                    SizedBox(height:20),
                    Container(
                      width:60,height:60,
                      decoration: BoxDecoration(
                        color: isSuccess? Colors.green[600]:Colors.red[600],
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Icon(isSuccess?Icons.done:Icons.error_outline,color:Colors.white)
                    )
                  ],
                )
              )
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop){
        if(currentPath.length>0){
          setState(() {
            currentPath.removeLast();            
            loading = true;
          });          
          getDirectory();
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: RichText(
              text:TextSpan(
                children: [
                  TextSpan(text:"Home",style:TextStyle(fontWeight:FontWeight.w700,fontSize:25,color:CustomColors.primaryColor.withOpacity(1))),
                  TextSpan(text:"Cloud",style:TextStyle(fontWeight:FontWeight.w700,fontSize:25,color:Colors.black))
                ]
              )
            ),
            actions: [
              IconButton(
                onPressed: closeServerDialog,
                icon: Icon(Icons.logout,color:Colors.red.shade700)
              )
            ],
          ),
          backgroundColor: CustomColors.getBgColor(),
          floatingActionButton: FloatingActionButton(
            onPressed: uploadFile,
            child:Icon(Icons.add),
            backgroundColor:CustomColors.primaryColor,
            foregroundColor:Colors.white,
            elevation:0,
          ),
          body: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical:5,horizontal:5),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Icon(Icons.home,color:CustomColors.getTextColor()),
                        onTap: (){
                          setState(() {
                            currentPath = [];
                            currentDirectory = [];                          
                            loading = true;
                          });
                          getDirectory();
                        }
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: SizedBox(
                        width:200,
                        height:30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: currentPath.length,
                          itemBuilder: (context,index)=>
                            GestureDetector(
                              onTap:(){
                                setState(() {
                                  currentPath.removeRange(index+1,currentPath.length);
                                });
                                getDirectory();
                              },
                              child: ClipPath(
                                clipper: Pentagon(),
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: CustomColors.lightLight,
                                      borderRadius:BorderRadius.circular(5)
                                    ),
                                    child:Padding(
                                      padding: EdgeInsets.only(left:8,top:2,bottom:2,right:14),
                                      child: Text(currentPath[index],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color:Colors.black
                                        ),
                                      ),
                                    )
                                  ),
                                ),
                              ),
                            ),
                        )
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: loading! ? 
                Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation(CustomColors.primaryColor)))
                :currentDirectory.length==0
                ? Center(child:Text("No files",style:TextStyle(color:CustomColors.getTextColor()))):              
                ListView.builder(
                  itemCount:currentDirectory.length,
                  itemBuilder: (context,index)=>DirectoryEntryTile(
                    entry:currentDirectory[index],
                    onLongPress:(){
                      if(currentDirectory[index].type=="file"){
                        
                      }
                    },
                    onPressed:(){
                      switch(currentDirectory[index].type){
                        case "folder": getDirectory(directory:currentDirectory[index].name);break;
                        case "file": getFile(currentDirectory[index].name);break;                      
                      }
                    },
                  ),
                )
              ),
            ],
          )
        ),
      ),
    );
  }
}

class Pentagon extends CustomClipper<Path>{
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;

  @override
  Path getClip(Size size){
    Path path = Path();
    
    path.moveTo(0,0);

    path.lineTo(0.8*size.width, 0);
    path.lineTo(size.width, 0.5*size.height);
    path.lineTo(0.8*size.width, size.height);
    path.lineTo(0,size.height);
    path.lineTo(0,0);

    return path;
  }
}