import 'package:files_client/Colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  const PrimaryButton({super.key,required this.text,required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width:double.maxFinite,
        decoration: BoxDecoration(
          color: CustomColors.primaryColor,
          borderRadius: BorderRadius.circular(4)
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text("Continue",
              style:TextStyle(fontWeight:FontWeight.w600,color:Colors.white)),
          )
        )
      )
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  const SecondaryButton({super.key,required this.text,required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width:double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color:CustomColors.primaryColor)
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(text,style:TextStyle(fontWeight:FontWeight.w600,color:CustomColors.primaryColor)),
          )
        )
      )
    );
  }
}