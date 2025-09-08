import 'package:blenzo/models/brand/get_brand.dart';
import 'package:flutter/material.dart';
import 'package:blenzo/services/api/brand_api.dart';
import 'package:blenzo/widgets/brand_card.dart';
import 'package:blenzo/widgets/brand_form_dialog.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({super.key});

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  late Future<GetBrandModel> _brands;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _brands = AuthenticationApiBrand.getBrand();
    });
  }

  Future<void> _confirmDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Brand"),
        content: const Text("Apakah kamu yakin ingin menghapus brand ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final result = await AuthenticationApiBrand.deleteBrand(brandsId: id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.message ?? "Brand berhasil dihapus")),
          );
        }
        _refresh();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Gagal hapus brand: $e")));
        }
      }
    }
  }

  /// 🔹 Tambah Brand
  Future<void> _openAddDialog() async {
    final result = await showBrandFormDialog(context: context);

    if (result != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Berhasil tambah brand: ${result.message}")),
        );
      }
      _refresh();
    }
  }

  /// 🔹 Edit Brand
  Future<void> _openEditDialog(BrandDetail brand) async {
    final result = await showBrandFormDialog(
      context: context,
      id: brand.id,
      initialName: brand.name,
      initialImageUrl: brand.imageUrl,
    );

    if (result != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Berhasil update brand: ${result.message}")),
        );
      }
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Brand")),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddDialog,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<GetBrandModel>(
        future: _brands,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(child: Text("Belum ada brand"));
          }

          final brands = snapshot.data!.data;
          return ListView.builder(
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return BrandCard(
                brand: brand,
                onEdit: () => _openEditDialog(brand),
                onDelete: () => _confirmDelete(brand.id),
              );
            },
          );
        },
      ),
    );
  }
}
