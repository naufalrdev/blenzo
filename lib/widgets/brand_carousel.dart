import 'package:blenzo/utils/app_color.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BrandCarousel extends StatefulWidget {
  const BrandCarousel({super.key});

  @override
  State<BrandCarousel> createState() => _BrandCarouselState();
}

class _BrandCarouselState extends State<BrandCarousel> {
  int _currentIndex = 0;

  final List<Map<String, String>> banners = [
    {
      "title": "50-40% OFF",
      "subtitle": "Now in (product)\nAll colours",
      "image": "assets/images/women_shope_removebg.png",
    },
    {
      "title": "30% OFF",
      "subtitle": "Best deals on fashion\nBlenzo now!",
      "image": "assets/images/handsome_removebg.png",
    },
    {
      "title": "New Arrivals",
      "subtitle": "Trendy collections\nAll categories",
      "image": "assets/images/women_removebg.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: banners.map((banner) {
            return Builder(
              builder: (BuildContext context) {
                return Stack(
                  clipBehavior: Clip.none, // biar gambar bisa keluar
                  children: [
                    // Background card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColor.primary,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            banner["title"]!,
                            style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.neutral,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            banner["subtitle"]!,
                            style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColor.neutral,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              foregroundColor: AppColor.neutral,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppColor.neutral),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text("Shop Now →"),
                          ),
                        ],
                      ),
                    ),

                    // Gambar di kanan, keluar sedikit
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: Image.asset(
                          banner["image"]!,
                          height: 135,
                          width: 126,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }).toList(),
        ),

        // Dot indicator
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: banners.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? AppColor.primary
                    : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
