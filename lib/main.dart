import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'authservice.dart';
import 'check_out_confirm_online_payment.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try {
    await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: '6LfPHMsgAAAAAE_h3m2CBb6V2Sc6BBcDquZaZkPQ',
    );
  } catch (e) {
    // Handle the 'already-activated' error
    if (e.toString().contains('already-activated')) {
      print('Firebase App Check is already activated.');
    } else {
      print('Error activating Firebase App Check: $e');
    }
  }

  runApp(
      const MyApp()
  );
  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Clean Code',
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: (

                Image.asset('assets/images/Logo final2.png')
            ),
            nextScreen: const MyAppExtended(),
            splashTransition: SplashTransition.fadeTransition,
            //pageTransitionType: PageTransitionType.scale,
            backgroundColor: Colors.white));
  }
}

class MyAppExtended extends StatelessWidget {
  const MyAppExtended({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: AuthService().handleAuth(),
      //home: SuperHomeScreen(),
      //home:MyLoginPage(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}