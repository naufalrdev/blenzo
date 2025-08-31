import 'package:blenzo/views/home_screen.dart';
import 'package:blenzo/views/login_screen.dart';
import 'package:blenzo/views/onboard_screen.dart';
import 'package:blenzo/views/register_screen.dart';
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
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        OnboardScreen.id: (context) => const OnboardScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
      },
      // home: SplashScreen(),
    );
  }
}
