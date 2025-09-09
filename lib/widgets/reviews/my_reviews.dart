import 'package:blenzo/models/history/get_history.dart';
import 'package:blenzo/services/api/history_api.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/currency_format.dart';
import 'package:flutter/material.dart';

class MyReviewsTab extends StatefulWidget {
  const MyReviewsTab({super.key});

  @override
  State<MyReviewsTab> createState() => _MyReviewsTabState();
}

class _MyReviewsTabState extends State<MyReviewsTab> {
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

    // Ambil semua items lalu filter yang sudah direview
    final reviewed = _transactions
        .expand(
          (history) => history.items.map(
            (item) => {"item": item, "transactionId": history.id},
          ),
        )
        .where((map) => (map["item"] as Kultum).hasReviewed)
        .toList();

    if (reviewed.isEmpty) {
      return const Center(
        child: Text("You haven't reviewed any products yet."),
      );
    }

    return ListView.builder(
      itemCount: reviewed.length,
      itemBuilder: (context, index) {
        final item = reviewed[index]["item"] as Kultum;

        return Card(
          color: AppColor.neutral,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: ClipRRect(
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
            title: Text(
              item.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Qty: ${item.quantity}"),
                Text(formatRupiah(item.product.price)),
              ],
            ),
            trailing: const Text(
              "Reviewed",
              style: TextStyle(
                fontFamily: "Montserrat",
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
