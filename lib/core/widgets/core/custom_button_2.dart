import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onepluspay/core/constants/theme.dart';
class CustomButton2 extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String tag;
  const CustomButton2({Key? key,
    required this.onPressed,
    required this.title,
    required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Hero(
      transitionOnUserGestures: true,
      tag: tag,
      // flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
      //   return RotationTransition(turns: animation,
      //   child: SizedBox(
      //     width: 300.w,
      //     child: ElevatedButton(
      //         onPressed: onPressed,
      //         child: Text(title,style: globalvariable.displayMedium,)),
      //   ),);
      // } ,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: onPressed,
            child: Text(title,style:
            TextStyle(
              fontWeight: FontWeight.w400,
              fontSize : 14,
              fontFamily : 'sherika',
              color : Color(0xFFFFFFFF),
            ),)),
      ),
    );
  }
}
