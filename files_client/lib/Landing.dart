import 'package:files_client/Buttons.dart';
import 'package:files_client/Utils.dart';
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

  TextEditingController controller = TextEditingController();
  bool loading = false;
  String? invalidAddressMessage;

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

  proceed() async {
    setState(() {
      loading = true;
    });
    print(controller.text.trim());
    if(Utils.checkIPandPort(controller.text.trim())){
      if((await http.get(Uri.parse("http://${controller.text.trim()}/test"))).statusCode==200){
        Future.delayed(Duration(seconds:3),(){
          setState(() {
            loading = false;
            invalidAddressMessage = null;
          });
          Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: Duration(seconds:1),
            reverseTransitionDuration: Duration(milliseconds:800),
            pageBuilder: (context,animation,secondaryAnimation)=>MyHomePage(address:controller.text.trim()),
            transitionsBuilder: (context,animation,secondaryAnimation,child)=>SlideTransition(
              position: animation.drive(Tween(begin:Offset(1.0,0.0),end:Offset.zero).chain(CurveTween(curve:Curves.easeInOut))),
              child:child
            ),
          )); 
        });  
        return;      
      }else{
        setState(() {
          invalidAddressMessage = "Server not responding";
        });
      }
    }else{
      setState(() {
        invalidAddressMessage = "Invalid address";
      });
    } 
    setState(() {
      loading = false;
    });    
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:SingleChildScrollView(
          child: Container(
            height:MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(                      
                    tag: 'hc',
                    child: Logo()
                  ),
                  SizedBox(height:100),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextField(       
                      autofocus: false,                                                           
                      controller: controller,
                      onSubmitted: (val)=>proceed(),  
                      decoration: InputDecoration( 
                        errorText: invalidAddressMessage,                      
                        filled: true,                     
                        hintText: "Enter valid fileserver URL",
                        hintStyle: TextStyle(color:Color(0xFF898989)),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,                                 
                        fillColor: Color(0xFFEDEDED),                      
                      ),
                    ),
                  ),     
                  SizedBox(height:50),               
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:12),
                    child: PrimaryButton(
                      text: "Continue",
                      onPressed: ()=>proceed(),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:12),
                    child: SecondaryButton(
                      text: "Scan QR Code",
                      onPressed: qrScan,
                    )
                  ),
                  SizedBox(height:60),
                  AnimatedOpacity(
                    opacity: loading?1:0,
                    duration: Duration(milliseconds:450),
                    child: LoadingAnimationWidget.threeArchedCircle(color:CustomColors.primaryColor, size:34),
                  )                
                ],
              )
            ),
          ),
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
        Future.delayed(Duration(seconds:3),(){
          Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: Duration(seconds:1),
            reverseTransitionDuration: Duration(seconds:1),
            pageBuilder: (context,animation,secondaryAnimation)=>MyHomePage(address:url),
            transitionsBuilder: (context,animation,secondaryAnimation,child)=>SlideTransition(
              position: animation.drive(Tween(begin:Offset(1.0,0.0),end:Offset.zero)),
              child:child
            ),
          )); 
        });  
        return;      
      }     
    }
    instance.clear();
    Future.delayed(Duration(seconds:3),(){
      Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: Duration(seconds:1),
        reverseTransitionDuration: Duration(seconds:1),
        pageBuilder: (context,animation,secondaryAnimation)=>ServerAddressForm(),
        transitionsBuilder: (context,animation,secondaryAnimation,child)=>SlideTransition(
          position: animation.drive(Tween(begin:Offset(1.0,0.0),end:Offset.zero).chain(CurveTween(curve:Curves.easeInOut))),
          child:child
        ),
      )); 
    });
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
                Hero(
                  tag: 'hc',
                  child: Logo(),
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