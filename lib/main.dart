import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onepluspay/core/constants/firebase_api.dart';
import 'package:onepluspay/core/constants/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onepluspay/test/screens/main_screen.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

   runApp(
       DevicePreview(
         enabled: !kReleaseMode,
         builder: (context) =>    const ProviderScope(child:

         MyApp()), // Wrap your app
       ),
    );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String? note;

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: OnePlusPayTheme.onePlusPayTheme,
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          home: child,
        );
      },
      child:
      SignIn()

      ,
    );
  }
}

