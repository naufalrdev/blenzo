import 'package:blenzo/models/product/get_product.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/currency_format.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final Datum product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final int price = int.tryParse(p.price) ?? 0;
    final discount = int.tryParse(p.discount ?? "0") ?? 0;
    final int basePrice = discount > 0
        ? (price * (100 - discount) ~/ 100)
        : price;
    final int totalPrice = basePrice * quantity;

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ==== SCROLLABLE CONTENT ====
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // IMAGE
                  SizedBox(
                    height: 350,
                    child: PageView(
                      children: p.imageUrls.map((url) {
                        return Image.network(url, fit: BoxFit.cover);
                      }).toList(),
                    ),
                  ),

                  // DETAIL
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColor.neutral,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Produk + Qty
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                p.name,
                                style: const TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.text,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (quantity > 1) {
                                      setState(() => quantity--);
                                    }
                                  },
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() => quantity++);
                                  },
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 6),
                        Row(
                          children: [
                            Spacer(),
                            Text(
                              "Available in stock",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                color: AppColor.text2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),

                        // Deskripsi
                        Text(
                          "Description",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat",
                            color: AppColor.text,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          p.description,
                          style: const TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 14,
                            color: AppColor.text2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 150),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ==== FIXED PRICE + BUTTON ====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: AppColor.neutral),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Harga
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                        color: AppColor.text,
                      ),
                    ),
                    Text(
                      formatRupiah(totalPrice.toString()),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),

                // Tombol Add to Cart
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
