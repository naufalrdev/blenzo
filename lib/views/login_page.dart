import 'package:blenzo/extensions/navigations.dart';
import 'package:blenzo/models/regist_user_model.dart';
import 'package:blenzo/services/api/regist_user.dart';
import 'package:blenzo/services/local/shared_prefs_service.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/views/register_screen.dart';
import 'package:blenzo/widgets/botnavbar.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const id = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RegistUserModel? user;
  String? errorMessage;
  bool isVisibility = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground(), buildLayer()]));
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and Password cannot be empty")),
      );
      isLoading = false;
      return;
    }
    try {
      final results = await AuthenticationAPI.loginUser(
        email: email,
        password: password,
      );
      setState(() {
        user = results;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login successful")));
      PreferenceHandler.saveToken(user?.data.token.toString() ?? "");
      context.pushReplacement(BotNavBar1());
      print(user?.toJson());
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage.toString())));
    } finally {
      setState(() {});
      isLoading = false;
    }
  }

  Widget socialButton(String image) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.primary),
        ),
        child: Image.asset(image, width: 24, height: 24),
      ),
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: AppColor.background,
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);

  TextField buildTextField({
    String? labelText,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !isVisibility : false,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.neutral,
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppColor.text,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w100,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility : Icons.visibility_off,
                  color: isVisibility ? AppColor.text : AppColor.text2,
                ),
              )
            : null,
      ),
    );
  }

  SafeArea buildLayer() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome\nBack!",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: AppColor.text,
                ),
              ),
              height(32),
              buildTextField(
                controller: emailController,
                labelText: "Email Address",
              ),
              height(16),
              buildTextField(
                controller: passwordController,
                labelText: "Password",
                isPassword: true,
              ),
              // height(10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColor.primary,
                    ),
                  ),
                ),
              ),
              height(18),
              SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                  ),
                  onPressed: () {
                    loginUser();
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColor.neutral,
                    ),
                  ),
                ),
              ),
              height(30),
              Center(
                child: Text(
                  "- Or Continue with -",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.text,
                  ),
                ),
              ),
              height(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialButton("assets/images/google.png"),
                  width(12),
                  socialButton("assets/images/apple.png"),
                  width(12),
                  socialButton("assets/images/facebook.png"),
                ],
              ),
              height(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create an Account ",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.text,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push(RegisterScreen());
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
