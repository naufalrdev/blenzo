import 'package:blenzo/models/history/get_history.dart';
import 'package:blenzo/services/api/history_api.dart';
import 'package:flutter/material.dart';

class MyReviewsTab extends StatefulWidget {
  const MyReviewsTab({super.key});

  @override
  State<MyReviewsTab> createState() => _MyReviewsTabState();
}

class _MyReviewsTabState extends State<MyReviewsTab> {
  bool _loading = true;
  List<Kultum> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final history = await AuthenticationApiHistory.getHistory();

      if (!mounted) return; // ✅ pastikan widget masih aktif
      setState(() {
        _transactions = history.data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return; // ✅ pastikan widget masih aktif
      setState(() {
        _loading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load history: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final reviewed = _transactions
        .expand(
          (kultum) => kultum.items.map(
            (item) => {"item": item, "transactionId": kultum.id},
          ),
        )
        .where((map) => (map["item"] as Goods).hasReviewed)
        .toList();

    if (reviewed.isEmpty) {
      return const Center(
        child: Text("You haven’t reviewed any products yet."),
      );
    }

    return ListView.builder(
      itemCount: reviewed.length,
      itemBuilder: (BuildContext context, int index) {
        final goods = reviewed[index]["item"] as Goods;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text(goods.product.name),
            subtitle: Text(
              "Qty: ${goods.quantity} | Harga: ${goods.product.price}",
            ),
            trailing: const Text(
              "Reviewed",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
