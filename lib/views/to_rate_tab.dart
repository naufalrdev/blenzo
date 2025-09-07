import 'package:blenzo/models/co_with_product.dart';
import 'package:blenzo/services/api/co_with_product.dart';
import 'package:flutter/material.dart';

class ToRateTab extends StatefulWidget {
  const ToRateTab({super.key});

  @override
  State<ToRateTab> createState() => _ToRateTabState();
}

class _ToRateTabState extends State<ToRateTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CheckoutWithProduct>>(
      future: CheckoutService().getCheckoutsWithProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Belum ada produk untuk dinilai"));
        }

        final list = snapshot.data!;

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Image.network(item.product.imageUrls.first),
                title: Text(item.product.name),
                subtitle: Text(item.product.brand ?? ""),
                trailing: ElevatedButton(
                  onPressed: () {
                    // TODO: buka halaman untuk kasih review
                  },
                  child: const Text("Nilai"),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
