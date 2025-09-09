import 'package:blenzo/extensions/navigations.dart';
import 'package:blenzo/models/product/get_product.dart';
import 'package:blenzo/services/api/product_api.dart';
import 'package:blenzo/services/api/brand_api.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/currency_format.dart';
import 'package:blenzo/views/product/product_detail.dart';
import 'package:flutter/material.dart';

class ProductByCategoryPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const ProductByCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ProductByCategoryPage> createState() => _ProductByCategoryPageState();
}

class _ProductByCategoryPageState extends State<ProductByCategoryPage> {
  List<Datum> allProducts = [];
  List<Datum> displayedProducts = [];
  List<String> brands = [];
  String selectedBrand = "All";
  bool isLoading = true;

  /// simpan logo brand dari API
  Map<String, String?> brandLogos = {}; // name → imageUrl

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory();
    fetchBrands();
  }

  /// ambil produk by kategori
  Future<void> fetchProductsByCategory() async {
    try {
      final result = await AuthenticationApiProduct.getProduct();
      final products = result.data;

      // filter by category
      final filtered = products
          .where((p) => p.categoryId.toString() == widget.categoryId.toString())
          .toList();

      // ambil brand unik dari produk
      final uniqueBrands = filtered
          .map((p) => p.brand ?? "")
          .where((b) => b.isNotEmpty)
          .toSet()
          .toList();

      setState(() {
        allProducts = filtered;
        displayedProducts = List.from(allProducts);
        brands = ["All", ...uniqueBrands];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  /// ambil data brand (logo)
  Future<void> fetchBrands() async {
    try {
      final result = await AuthenticationApiBrand.getBrand();
      final brandData = result.data;

      setState(() {
        brandLogos = {for (var b in brandData) b.name: b.imageUrl};
      });
    } catch (e) {
      print("Error fetchBrands: $e");
    }
  }

  void applyBrandFilter(String brand) {
    setState(() {
      selectedBrand = brand;
      if (brand == "All") {
        displayedProducts = List.from(allProducts);
      } else {
        displayedProducts = allProducts
            .where((p) => (p.brand ?? "") == brand)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: Text(
          widget.categoryName,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
            color: AppColor.text,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand filter pakai ChoiceChip + Logo
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: brands.map((brand) {
                      final isSelected = selectedBrand == brand;
                      final logo = brandLogos[brand];

                      return ChoiceChip(
                        avatar:
                            (logo != null && logo.isNotEmpty && brand != "All")
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(logo),
                                backgroundColor: Colors.transparent,
                              )
                            : null,
                        label: Text(
                          brand == "All" ? "All Brands" : brand,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500,
                            color: isSelected ? Colors.white : AppColor.text,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColor.primary,
                        backgroundColor: Colors.white,
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isSelected
                                ? AppColor.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        onSelected: (_) => applyBrandFilter(brand),
                      );
                    }).toList(),
                  ),
                ),

                // Grid produk
                Expanded(
                  child: displayedProducts.isEmpty
                      ? Center(child: Text("No products found"))
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.60,
                              ),
                          itemCount: displayedProducts.length,
                          itemBuilder: (context, index) {
                            final p = displayedProducts[index];
                            final discount =
                                int.tryParse(p.discount ?? "0") ?? 0;
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
                                          borderRadius: BorderRadius.vertical(
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
                                                    child: Icon(
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
                                                style: TextStyle(
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
                                      padding: EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              style: TextStyle(
                                                fontSize: 13,
                                                decoration:
                                                    TextDecoration.lineThrough,
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
                        ),
                ),
              ],
            ),
    );
  }
}
