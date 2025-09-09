import 'package:blenzo/extensions/navigations.dart';
import 'package:blenzo/models/product/get_product.dart';
import 'package:blenzo/services/api/product_api.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/currency_format.dart';
import 'package:blenzo/views/product/all_products.dart';
import 'package:blenzo/views/product/product_detail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Future<GetProdukModel> futureProduct;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  final promoBanners = [
    {
      "title": "24% off shipping today\non shoes purchases",
      "image": "assets/images/shoes.png",
    },
    {
      "title": "Special discount for\nnew arrivals",
      "image": "assets/images/shirt.png",
    },
    {
      "title": "Buy 1 Get 1 Free\non bag purchases",
      "image": "assets/images/bag.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    futureProduct = AuthenticationApiProduct.getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Carousel Promo Banner
          CarouselSlider(
            items: promoBanners.map((banner) {
              return Container(
                // margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        banner["title"]!,
                        style: const TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Image.asset(banner["image"]!, height: 150),
                  ],
                ),
              );
            }).toList(),
            carouselController: _carouselController,
            options: CarouselOptions(
              height: 140,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.95,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),

          /// Dots Indicator
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: promoBanners.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: _currentIndex == entry.key ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _currentIndex == entry.key
                        ? AppColor.primary
                        : Colors.grey[400],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          /// New Arrivals
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "New Arrivals!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat",
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.pushReplacementNamed(AllProductsPage.id);
                },
                child: Text("See All", style: TextStyle(color: AppColor.text2)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Product List
          FutureBuilder(
            future: futureProduct,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                return const Center(child: Text("No Products found"));
              }
              final productList = snapshot.data!.data.take(5).toList();
              return GridView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: productList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.60,
                ),
                itemBuilder: (context, index) {
                  final p = productList[index];
                  final discount = int.tryParse(p.discount ?? "0") ?? 0;
                  return GestureDetector(
                    onTap: () {
                      context.push(ProductDetailPage(product: p));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.neutral,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// product image + discount badge
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: p.imageUrls.isNotEmpty
                                      ? Image.network(
                                          p.imageUrls[0],
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.image,
                                            size: 50,
                                          ),
                                        ),
                                ),
                              ),
                              if (discount > 0)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColor.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      "-$discount%",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          /// product info
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// name
                                Text(
                                  p.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.text,
                                  ),
                                ),
                                SizedBox(height: 10),

                                /// price + discount price
                                if (discount > 0) ...[
                                  Text(
                                    formatRupiah(p.price),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                                Text(
                                  discount > 0
                                      ? formatRupiah(
                                          (int.parse(p.price) *
                                                  (100 - discount) ~/
                                                  100)
                                              .toString(),
                                        )
                                      : formatRupiah(p.price),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
