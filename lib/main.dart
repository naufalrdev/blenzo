import 'package:blenzo/views/onboard_screen.dart';
import 'package:blenzo/views/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  // initializeDateFormatting("id_ID");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // initialRoute: SplashScreen1.id,
      // routes: {
      //   "/login": (context) => Screen1(),
      //   SplashScreen1.id: (context) => SplashScreen1(),
      //   BotNavBar1.id: (context) => BotNavBar1(),
      // },
      home: OnboardScreen(),
    );
  }
}
