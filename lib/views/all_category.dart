import 'package:blenzo/models/product/get_product.dart';
import 'package:blenzo/services/api/product_api.dart';
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

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory();
  }

  Future<void> fetchProductsByCategory() async {
    try {
      final result = await AuthenticationApiProduct.getProduct();
      final products = result.data;

      // filter by kategori
      final filtered = products
        ..where((p) => p.categoryId.toString() == widget.categoryId.toString());

      // ambil brand unik (nama saja)
      final uniqueBrands = filtered
          .map((p) => p.brand ?? "")
          .where((b) => b.isNotEmpty)
          .toSet()
          .toList();

      setState(() {
        allProducts = filtered;
        displayedProducts = List.from(allProducts);
        brands = uniqueBrands;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void applyBrandFilter(String brand) {
    setState(() {
      selectedBrand = brand;
      if (brand == "All") {
        displayedProducts = List.from(allProducts);
      } else {
        displayedProducts = allProducts.where((p) => p.brand == brand).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Dropdown filter brand
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Text(
                        "Brand: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: selectedBrand,
                        items: [
                          const DropdownMenuItem(
                            value: "All",
                            child: Text("All Brands"),
                          ),
                          ...brands.map(
                            (b) => DropdownMenuItem(value: b, child: Text(b)),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) applyBrandFilter(value);
                        },
                      ),
                    ],
                  ),
                ),

                // Grid produk
                Expanded(
                  child: displayedProducts.isEmpty
                      ? const Center(child: Text("No products found"))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 kolom
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.65,
                              ),
                          itemCount: displayedProducts.length,
                          itemBuilder: (context, index) {
                            final product = displayedProducts[index];
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // gambar produk
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        product.imageUrls.isNotEmpty
                                            ? product.imageUrls[0]
                                            : "https://via.placeholder.com/150",
                                        height: 140,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product
                                                .name, // sebelumnya product.productName
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.brand ?? "-", // null safe
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "Rp ${product.price}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
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
