import 'package:blenzo/extensions/navigations.dart'; // kalau kamu pakai context.push
import 'package:blenzo/models/history/get_history.dart';
import 'package:blenzo/services/api/history_api.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/currency_format.dart';
import 'package:blenzo/views/review/add_review.dart'; // pastikan sudah ada halaman ini
import 'package:flutter/material.dart';

class ToRateTab extends StatefulWidget {
  final Function(Kultum)? onReviewed;

  const ToRateTab({super.key, this.onReviewed});

  @override
  State<ToRateTab> createState() => _ToRateTabState();
}

class _ToRateTabState extends State<ToRateTab> {
  bool _loading = true;
  List<History> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await AuthenticationApiHistory.getHistory();
      if (!mounted) return;
      setState(() {
        _transactions = history.data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load history: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Ambil item yang belum direview
    final toRate = _transactions
        .expand(
          (h) => h.items.map((item) => {"item": item, "transactionId": h.id}),
        )
        .where((map) => !(map["item"] as Kultum).hasReviewed)
        .toList();

    if (toRate.isEmpty) {
      return const Center(child: Text("There are no products to review"));
    }

    return ListView.builder(
      itemCount: toRate.length,
      itemBuilder: (context, index) {
        final item = toRate[index]["item"] as Kultum;
        final transactionId = toRate[index]["transactionId"] as int;

        return Card(
          color: AppColor.neutral,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar produk
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item.product.imageUrls.isNotEmpty
                          ? Image.network(
                              item.product.imageUrls.first,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                    ),

                    const SizedBox(width: 12),

                    // Detail produk
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(formatRupiah(item.product.price)),
                          Text("Qty: ${item.quantity}"),
                        ],
                      ),
                    ),

                    // Tombol review → navigasi ke AddReview
                    ElevatedButton(
                      onPressed: () async {
                        final result = await context.push(
                          ReviewPage(item: item, transactionId: transactionId),
                        );

                        if (result == true) {
                          setState(() {
                            item.hasReviewed = false;
                          });
                          if (widget.onReviewed != null) {
                            widget.onReviewed!(item);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                      ),
                      child: const Text(
                        "Review",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          color: AppColor.neutral,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Rating bintang kosong
                Row(
                  children: List.generate(5, (i) {
                    return const Icon(Icons.star_border, color: Colors.orange);
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
