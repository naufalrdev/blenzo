import 'package:blenzo/extensions/navigations.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/views/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  Widget buildPage({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 250, child: Image.asset(image)),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColor.text,
          ),
        ),
        SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColor.text2,
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  final PageController _controller = PageController();
  bool onLastPage = false;
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${currentPage + 1}",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColor.text,
                          ),
                        ),
                        TextSpan(
                          text: "/3",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColor.text2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: () => _controller.jumpToPage(2),
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColor.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                    onLastPage = index == 2;
                  });
                },
                children: [
                  buildPage(
                    image: "assets/images/choose_product_removebg.png",
                    title: "Choose Products",
                    subtitle: "Pilih Produk",
                  ),
                  buildPage(
                    image: "assets/images/make_payment_removebg.png",
                    title: "Make Payment",
                    subtitle: "Pembayaran",
                  ),
                  buildPage(
                    image: "assets/images/get_order_removebg.png",
                    title: "Get Your Order",
                    subtitle: "TERUMUKUSU",
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    // style: TextButton.styleFrom(
                    //   foregroundColor: currentPage == 0
                    //       ? AppColor.text2
                    //       : AppColor.text,
                    // ),
                    onPressed: currentPage == 0
                        ? null
                        : () {
                            _controller.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                    child: Text(
                      "Prev",
                      style: TextStyle(fontSize: 18, color: AppColor.text2),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColor.text,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColor.secondary,
                    ),
                    onPressed: () {
                      if (onLastPage) {
                        context.push(HomeScreen());
                      } else {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },

                    child: Text(
                      onLastPage ? "Get Started" : "Next",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
