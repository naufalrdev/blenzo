import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/views/product/all_products.dart';
import 'package:blenzo/views/auth/onboard_screen.dart';
import 'package:blenzo/views/splash/splash_screen.dart';
import 'package:blenzo/widgets/botnavbar.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.background),
      ),

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        OnboardScreen.id: (context) => OnboardScreen(),
        BotNavBar1.id: (context) => BotNavBar1(),
        AllProductsPage.id: (context) => AllProductsPage(),
      },
      // home: LoginScreen(?),
    );
  }
}
