import 'package:blenzo/models/product/get_product.dart';
import 'package:blenzo/services/api/product_api.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/currency_format.dart';
import 'package:blenzo/views/product_detail.dart';
import 'package:flutter/material.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  late Future<GetProdukModel> futureProduct;
  String query = "";
  String selectedFilter = "Semua";

  @override
  void initState() {
    super.initState();
    futureProduct = AuthenticationApiProduct.getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: TextField(
          decoration: const InputDecoration(
            hintText: "Cari produk...",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              query = value.toLowerCase();
            });
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "Semua", child: Text("Semua Produk")),
              const PopupMenuItem(
                value: "Murah",
                child: Text("Harga Termurah"),
              ),
              const PopupMenuItem(
                value: "Mahal",
                child: Text("Harga Termahal"),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<GetProdukModel>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(child: Text("No Products found"));
          }

          var productList = snapshot.data!.data;

          // filter by search
          if (query.isNotEmpty) {
            productList = productList
                .where((p) => p.name.toLowerCase().contains(query))
                .toList();
          }

          // filter by harga
          if (selectedFilter == "Murah") {
            productList.sort(
              (a, b) => int.parse(a.price).compareTo(int.parse(b.price)),
            );
          } else if (selectedFilter == "Mahal") {
            productList.sort(
              (a, b) => int.parse(b.price).compareTo(int.parse(a.price)),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: productList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) {
              final p = productList[index];
              final discount = int.tryParse(p.discount ?? "0") ?? 0;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: p),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.neutral,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image, size: 50),
                                    ),
                            ),
                          ),
                          if (discount > 0)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColor.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  "-$discount%",
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.text,
                              ),
                            ),
                            if (discount > 0)
                              Text(
                                formatRupiah(p.price),
                                style: const TextStyle(
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            Text(
                              discount > 0
                                  ? formatRupiah(
                                      (int.parse(p.price) *
                                              (100 - discount) ~/
                                              100)
                                          .toString(),
                                    )
                                  : formatRupiah(p.price),
                              style: const TextStyle(
                                fontSize: 13,
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
    );
  }
}
