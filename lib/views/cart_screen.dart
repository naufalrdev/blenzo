import 'package:blenzo/models/checkout/add_checkout.dart';
import 'package:blenzo/services/api/checkout_api.dart';
import 'package:blenzo/services/local/shared_prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:blenzo/models/cart/get_cart.dart';
import 'package:blenzo/services/api/cart_api.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/currency_format.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<GetCart> cartItems = [];
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> doCheckout() async {
    final selectedItems = cartItems.where((e) => e.selected).toList();
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih produk dulu sebelum checkout")),
      );
      return;
    }

    try {
      final userId =
          await PreferenceHandler.getUserId(); // dapetin userId dari prefs

      // mapping ke Item dari model kamu
      final items = selectedItems.map((item) {
        return Item(
          product: BuyNow(
            id: item.product.id, // sesuaikan field id di model product kamu
            name: item.product.name,
            price: item.product.price,
          ),
          quantity: item.quantity.toString(),
        );
      }).toList();

      final total = totalPrice;

      final response = await AuthenticationApiCheckOut.addCheckout(
        userId: userId!,
        items: items,
        total: total,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      // kosongkan cart (opsional)
      // setState(() {
      //   cartItems.removeWhere((e) => e.selected);
      // });

      Navigator.pop(context); // tutup bottomsheet
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Checkout gagal: $e")));
    }
  }

  Future<void> fetchCart() async {
    try {
      final result = await AuthenticationApiCart.getCart();
      setState(() {
        cartItems = result.data;
      });
    } catch (e) {
      print("Error get cart: $e");
    }
  }

  int get totalPrice {
    int sum = 0;
    for (var item in cartItems) {
      if (item.selected) {
        sum += getDiscountedPrice(item.product) * item.quantity;
      }
    }
    return sum;
  }

  int getDiscountedPrice(Product product) {
    final int price = int.tryParse(product.price) ?? 0;
    final int discount = int.tryParse(product.discount) ?? 0;
    if (discount > 0) {
      return price - ((price * discount) ~/ 100);
    }
    return price;
  }

  void showCheckoutBottomSheet() {
    final selectedItems = cartItems.where((e) => e.selected).toList();
    if (selectedItems.isEmpty) return;

    final subtotal = totalPrice;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                "Konfirmasi Checkout",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // list produk terpilih
              ...selectedItems.map((e) {
                final price = getDiscountedPrice(e.product);
                return ListTile(
                  leading: Image.network(
                    e.product.imageUrls.isNotEmpty
                        ? e.product.imageUrls.first
                        : "https://via.placeholder.com/40",
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    e.product.name,
                    style: const TextStyle(fontFamily: "Montserrat"),
                  ),
                  subtitle: Text("x${e.quantity}"),
                  trailing: Text(
                    formatRupiah((price * e.quantity).toString()),
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),

              const Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatRupiah(subtotal.toString()),
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // tombol checkout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await doCheckout();
                  },
                  child: const Text(
                    "Checkout",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Keranjang Saya (${cartItems.length})",
          style: const TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Ubah",
              style: TextStyle(color: AppColor.primary),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final priceAfterDiscount = getDiscountedPrice(item.product);

                return Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Checkbox(
                        value: item.selected,
                        onChanged: (val) {
                          setState(() {
                            item.selected = val ?? false;
                          });
                          if (val == true) {
                            showCheckoutBottomSheet();
                          }
                        },
                      ),
                      Image.network(
                        item.product.imageUrls.isNotEmpty
                            ? item.product.imageUrls.first
                            : "https://via.placeholder.com/70",
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if ((int.tryParse(item.product.discount) ?? 0) >
                                    0)
                                  Text(
                                    formatRupiah(item.product.price),
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                const SizedBox(width: 6),
                                Text(
                                  formatRupiah(priceAfterDiscount.toString()),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (item.quantity > 1) {
                                      setState(() => item.quantity--);
                                    }
                                  },
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text(item.quantity.toString()),
                                IconButton(
                                  onPressed: () {
                                    setState(() => item.quantity++);
                                  },
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ==== Bottom Bar ====
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: selectAll,
                  onChanged: (val) {
                    setState(() {
                      selectAll = val ?? false;
                      for (var item in cartItems) {
                        item.selected = selectAll;
                      }
                    });
                  },
                ),
                const Text("Semua"),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      formatRupiah(totalPrice.toString()),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    showCheckoutBottomSheet();
                  },
                  child: Text(
                    "Checkout (${cartItems.where((e) => e.selected).length})",
                    style: const TextStyle(
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
