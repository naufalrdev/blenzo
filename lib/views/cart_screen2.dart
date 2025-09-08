import 'package:blenzo/extensions/navigations.dart';
import 'package:blenzo/models/checkout/add_checkout.dart';
import 'package:blenzo/services/api/checkout_api.dart';
import 'package:blenzo/services/local/shared_prefs_service.dart';
import 'package:blenzo/utils/get_discount.dart';
import 'package:flutter/material.dart';
import 'package:blenzo/models/cart/get_cart.dart';
import 'package:blenzo/services/api/cart_api.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/currency_format.dart';

class CartPage2 extends StatefulWidget {
  const CartPage2({super.key});

  @override
  State<CartPage2> createState() => _CartPage2State();
}

class _CartPage2State extends State<CartPage2> {
  List<GetCart> cartItems = [];
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    fetchCart();
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

  Future<void> doCheckout() async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("There are no items in your cart")),
      );
      return;
    }

    try {
      final userId = await PreferenceHandler.getUserId();

      final items = cartItems.map((item) {
        return Item(
          product: BuyNow(
            id: item.product.id,
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

      context.pop(); // tutup bottomsheet
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Checkout failed: $e")));
    }
  }

  Future<void> deleteItem(int cartId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete Product",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w400,
              color: AppColor.text,
            ),
          ),
          content: const Text(
            "Do you want to remove this item from your cart?",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w400,
              color: AppColor.text,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w400,
                  color: AppColor.text,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
              ),
              onPressed: () => context.pop(true),
              child: const Text(
                "Delete",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await AuthenticationApiCart.deleteCart(cartId: cartId);
      setState(() {
        cartItems.removeWhere((item) => item.id == cartId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item removed successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to remove item: $e")));
    }
  }

  Future<void> deleteAllItems() async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Your cart is empty")));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete All",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w400,
              color: AppColor.text,
            ),
          ),
          content: const Text(
            "Are you sure you want to clear all items from your cart?",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w400,
              color: AppColor.text,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w400,
                  color: AppColor.text,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
              ),
              onPressed: () => context.pop(true),
              child: const Text(
                "Delete All",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      for (var item in List.from(cartItems)) {
        await AuthenticationApiCart.deleteCart(cartId: item.id);
      }
      if (!mounted) return;
      setState(() {
        cartItems.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All items were successfully removed from your cart"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Oops! Couldnt delete all items: $e")),
      );
    }
  }

  int get totalPrice {
    int sum = 0;
    for (var item in cartItems) {
      sum += getDiscountedPrice(item.product) * item.quantity;
    }
    return sum;
  }

  void showCheckoutBottomSheet() {
    if (cartItems.isEmpty) return;

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
                "Confirmation of Checkout",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
              ),
              const SizedBox(height: 12),
              ...cartItems.map((e) {
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
        title: const Text(
          "My cart",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
            color: AppColor.text,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isEditMode = !isEditMode;
              });
            },
            child: Text(
              isEditMode ? "Done" : "Edit",
              style: const TextStyle(color: AppColor.primary),
            ),
          ),
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () => deleteAllItems(),
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
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            if (!isEditMode)
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (item.quantity > 1) {
                                        setState(() => item.quantity--);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
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
                      if (isEditMode)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteItem(item.id),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColor.background,
              border: Border(top: BorderSide(color: AppColor.text2)),
            ),
            child: Row(
              children: [
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
                        color: AppColor.primary,
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
                  child: const Text(
                    "Checkout",
                    style: TextStyle(
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
