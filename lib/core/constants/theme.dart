import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class globalvariable{
  static const primarycolor = Color.fromARGB(255, 137, 4, 181);
  static const backgroundcolor = Color.fromARGB(255,254, 254, 254);
  static const backgroundcard = Color.fromARGB(255, 144, 37, 37);

  static TextStyle headlineSmall=   TextStyle(
    fontSize : 32.sp,
    fontFamily : 'sherika',
    fontWeight : FontWeight.w600,
    color : Color(0xFFFFFFFF),
  );
  static TextStyle headlineMedium= TextStyle(
    fontSize : 24.sp,
    fontFamily : 'sherika',
    fontWeight : FontWeight.w600,
    color : Colors.black,
  );
  static TextStyle headlineLarge= TextStyle(fontFamily: 'Inter',fontWeight: FontWeight.w600, fontSize: 17.sp, fontStyle: FontStyle.italic,color: Colors.white);
  static TextStyle bodySmall= TextStyle(
    fontSize : 14.sp,
    fontFamily : "sherika",
    fontWeight : FontWeight.w500,
    color : Colors.black,
  );
  static TextStyle bodyMedium= TextStyle(
    fontSize :  14.sp ,
    fontFamily : "sherika",
    fontWeight : FontWeight.w500,
    color : Color(0xFF888888),
  );
  static TextStyle bodyLarge= TextStyle(
    fontSize : 24.sp,

    fontFamily : 'sherika',
    fontWeight : FontWeight.w500,
    color : Color(0xFF000000),
  );
  static TextStyle displaySmall= TextStyle(
    fontSize : 12.sp,
    fontFamily: 'Sherika',
    fontWeight : FontWeight.w500,
    color : Color(0xFFFFFFFF),
  );
  static TextStyle displayMedium= TextStyle(
    fontWeight: FontWeight.w400,
    fontSize : 14.sp,
    fontFamily : 'sherika',
    color : Color(0xFFFFFFFF),
  );
  static TextStyle displayLarge= TextStyle(
    fontSize : 16.sp,
    fontFamily :'Sherika',
    fontWeight : FontWeight.w700,
    color : Color(0xFFFFFFFF),
  );
  static TextStyle labelSmall= TextStyle(
    fontSize : 12.sp,
    fontFamily : 'sherika',
    fontWeight : FontWeight.w700,
    color : Color(0xFF9D2EC1),


  );
  static TextStyle labelMedium= TextStyle(
    fontSize : 14.sp,
    fontFamily : 'sherika',
    fontWeight : FontWeight.w500,
    color : Color(0xFF9D2EC1),
  );
  static TextStyle labelLarge= TextStyle(
    fontSize : 16.sp,
    fontFamily : 'sherika',
    fontWeight : FontWeight.w500,
    color : Color(0xFF9D2EC1),
  );

}


class OnePlusPayTheme {
  static ThemeData onePlusPayTheme = ThemeData(
    // Primary color for the app
    primaryColor: Color.fromARGB(255, 137, 4, 181),


    // Accent color for the app
    hintColor: Colors.orange,



    // Text themes for different parts of the app


    // Define the brightness of the theme (light or dark)
    brightness: Brightness.light,

    // Customizable properties
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,

      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),

    ),
    elevatedButtonTheme: ElevatedButtonThemeData(

      style: ElevatedButton.styleFrom(
          padding:EdgeInsets.symmetric(vertical: 15) ,
        backgroundColor: const Color.fromARGB(255, 137, 4, 181),
        shape: const RoundedRectangleBorder(


            borderRadius: BorderRadius.all(Radius.circular(30))),
       textStyle: TextStyle(
         color: Colors.white,
       ),
      ),

    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color.fromARGB(255, 137, 4, 181),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    ),
    // Add more customizations as needed
  );
}
