import 'package:blenzo/extensions/navigations.dart';
import 'package:blenzo/models/user/regist_user.dart';
import 'package:blenzo/services/api/user_api.dart';
import 'package:blenzo/services/local/shared_prefs_service.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/views/auth/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const id = "/register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
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

  void registUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final name = nameController.text;
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Name, Email, and Password cannot be empty"),
        ),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final results = await AuthenticationAPIUser.registerUser(
        email: email,
        password: password,
        name: name,
      );

      setState(() {
        user = results;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration was successful")),
      );

      PreferenceHandler.saveToken(user?.data.token.toString() ?? "");
      context.pop(LoginScreen());

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
      setState(() {
        isLoading = false;
      });
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
                "Create an\naccount",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: AppColor.text,
                ),
              ),
              height(32),
              buildTextField(controller: nameController, labelText: "Name"),
              height(16),
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
              height(14),
              Text.rich(
                textAlign: TextAlign.justify,
                TextSpan(
                  text: "By clicking the ",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.text,
                  ),
                  children: [
                    TextSpan(
                      text: "Register",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColor.primary,
                      ),
                    ),
                    TextSpan(
                      text: " button, you agree\n",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColor.text,
                      ),
                    ),
                    TextSpan(
                      text: "to the public offer",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColor.text,
                      ),
                    ),
                  ],
                ),
              ),

              height(24),
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
                    isLoading ? null : registUser();
                  },
                  child: Text(
                    "Create Account",
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
            ],
          ),
        ),
      ),
    );
  }
}
