import 'package:files_client/Colors.dart';
import 'package:files_client/main.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<QRScan> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {

  QRViewController? qrViewController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,          
          elevation:0,          
          leading:IconButton(
            onPressed: ()=>Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios_new_rounded,color:Colors.white)
          ),          
        ),
        body:Container(
          child:QRView(
            formatsAllowed: [BarcodeFormat.qrcode],
            overlay:QrScannerOverlayShape(
              cutOutSize: 300,
              borderRadius: 12,
              borderWidth: 15,
              borderColor:CustomColors.primaryColor,
              overlayColor:Colors.black87
            ),
            key: GlobalKey(debugLabel: 'QR'), 
            onQRViewCreated: (qrController){
              this.qrViewController = qrController;
              qrViewController!.scannedDataStream.listen((event) async {
                qrViewController!.pauseCamera();
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context,animation,secondaryAnimation)=>MyHomePage(address:event.code.toString()),
                  transitionsBuilder: (context,animation,secondaryAnimation,child)=>SlideTransition(
                    position: animation.drive(Tween(begin:Offset(1,0),end:Offset.zero).chain(CurveTween(curve:Curves.easeIn))),
                    child:child
                  ),
                ));
              });
            }
          ),
        )
      ),
    );
  }
}