import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onepluspay/core/constants/theme.dart';
class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const CustomButton({Key? key, required this.onPressed, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Hero(
      transitionOnUserGestures: true,
      tag: 'button',

      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: onPressed,
            child: Text(title,style: globalvariable.displayMedium,)),
      ),
    );
  }
}
