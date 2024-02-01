import 'package:files_client/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:files_client/QRScan.dart';
import 'package:files_client/Colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServerAddressForm extends StatefulWidget {
  const ServerAddressForm({super.key});
  @override
  State<ServerAddressForm> createState() => _ServerAddressFormState();
}

class _ServerAddressFormState extends State<ServerAddressForm> {
  qrScan() async {
    if(await Permission.camera.status.isGranted){
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context)=>QRScan()
      ));
    }else{
      final status = await Permission.camera.request();
      if(status.isGranted){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context)=>QRScan()
        ));
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:Container(
          child:Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(  
                      onSubmitted: (val){                        
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (context,animation,secondaryAnimation)=>MyHomePage(address:val.trim().toString()),
                          transitionsBuilder: (context,animation,secondaryAnimation,child)=>SlideTransition(
                            position: animation.drive(Tween(begin:Offset(1.0,0.0),end:Offset.zero)),
                            child:child
                          ),
                        )); 
                      },                
                      decoration: InputDecoration(                      
                        label: Text("Enter valid fileserver URL",style:TextStyle(color:Colors.black)),
                        border: OutlineInputBorder(borderRadius:BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(5),borderSide:BorderSide(color:CustomColors.primaryColor))
                      ),
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.symmetric(vertical:20),
                    child: Text("OR",style:TextStyle(fontWeight:FontWeight.w500,fontSize:16))
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:12,horizontal:48),
                    child: MaterialButton(
                      color:CustomColors.primaryColor,
                      elevation:0,
                      onPressed: qrScan,
                      child:Padding(
                        padding: const EdgeInsets.symmetric(vertical:10),
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_rounded,color:Colors.white),
                            SizedBox(width:12),
                            Text("Scan QR code",style:TextStyle(fontWeight:FontWeight.w500,color:Colors.white))
                          ],
                        ),
                      )
                    ),
                  )

                ],
              ),
            ),
          )
        )
      ),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState(){
    checkUrl();
    super.initState();
  }

  checkUrl() async {
    final instance = await SharedPreferences.getInstance();
    final url = instance.getString("baseUrl");
    if(url!=null){
      if((await http.get(Uri.parse("http://${url}/test"))).statusCode==200){
        Future.delayed(Duration(seconds:5),(){
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context,animation,secondaryAnimation)=>MyHomePage(address:url),
            transitionsBuilder: (context,animation,secondaryAnimation,child)=>SlideTransition(
              position: animation.drive(Tween(begin:Offset(1.0,0.0),end:Offset.zero)),
              child:child
            ),
          )); 
        });        
      }else{
        instance.clear();
        Future.delayed(Duration(seconds:5),(){
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context,animation,secondaryAnimation)=>ServerAddressForm(),
            transitionsBuilder: (context,animation,secondaryAnimation,child)=>SlideTransition(
              position: animation.drive(Tween(begin:Offset(1.0,0.0),end:Offset.zero)),
              child:child
            ),
          )); 
        });        
      }      
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        body:Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Welcome to",style:TextStyle(fontWeight:FontWeight.w500,fontSize:22)),
                SizedBox(height:12),
                RichText(
                  text:TextSpan(
                    children: [
                      TextSpan(text:"Home",style:TextStyle(fontWeight:FontWeight.w700,fontSize:45,color:CustomColors.primaryColor.withOpacity(1))),
                      TextSpan(text:"Cloud",style:TextStyle(fontWeight:FontWeight.w700,fontSize:45,color:Colors.black))
                    ]
                  )
                ),
                SizedBox(height:100),
                LoadingAnimationWidget.threeArchedCircle(color:CustomColors.primaryColor.withOpacity(1),size:50),
                SizedBox(height:200),
              ],
            )
          ),
        )
      )
    );
  }
}