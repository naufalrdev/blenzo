import 'package:blenzo/models/brand/get_brand.dart';
import 'package:blenzo/models/product/get_product.dart';
import 'package:blenzo/services/api/brand_api.dart';
import 'package:blenzo/services/api/product_api.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/brand_image.dart';
import 'package:blenzo/widgets/brand_carousel.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<GetBrandModel> futureBrand;
  late Future<GetProdukModel> futureProduct;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    futureBrand = AuthenticationApiBrand.getBrand();
    futureProduct = AuthenticationApiProduct.getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [buildBackground(), buildLayer()]));
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

  SafeArea buildLayer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.neutral,
                  hintText: "Search any product..",
                  hintStyle: TextStyle(color: AppColor.text2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              searchQuery = "";
                              searchController.clear();
                            });
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
              height(16),

              // Section Brand
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "All Featured",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColor.text,
                  ),
                ),
              ),
              height(12),

              // Brand List
              FutureBuilder<GetBrandModel>(
                future: futureBrand,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                    return const Center(child: Text("No Brands found"));
                  }

                  final brands = snapshot.data!.data;
                  return SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: brands.length,
                      itemBuilder: (BuildContext context, int index) {
                        final brand = brands[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    getBrandImage(brand.name),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),

                              height(6),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  brand.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              // height(16),
              BrandCarousel(),
              FutureBuilder(
                future: futureProduct,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                    return const Center(child: Text("No Brands found"));
                  }
                  final productList = snapshot.data!.data;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: productList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final p = productList[index];
                        return Container(
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
                              ClipRRect(
                                borderRadius: BorderRadiusGeometry.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: p.imageUrls.isNotEmpty
                                    ? Image.network(
                                        p.imageUrls[0],
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 150,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.image, size: 50),
                                      ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  p.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.text,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  p.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.text,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      "Rp${p.price}",
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.text,
                                      ),
                                    ),
                                    width(6),
                                    Text(
                                      "Rp100000",
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontFamily: "Montserrat",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.text,
                                      ),
                                    ),
                                    width(6),
                                    Text(
                                      "${p.discount}%Off",
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
