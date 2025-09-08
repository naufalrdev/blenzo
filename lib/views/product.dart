import 'package:blenzo/models/product/add_product.dart';
import 'package:flutter/material.dart';
import 'package:blenzo/models/product/get_product.dart';
import 'package:blenzo/services/api/product_api.dart';
import 'package:blenzo/services/api/categories_api.dart';
import 'package:blenzo/services/api/brand_api.dart';
import 'package:blenzo/widgets/product_card.dart';
import 'package:blenzo/widgets/product_form_dialog.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Datum> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    try {
      final result = await AuthenticationApiProduct.getProduct();
      setState(() {
        _products = result.data;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat produk: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  /// Ambil data kategori dan brand dari API
  Future<Map<String, List<Map<String, dynamic>>>>
  _fetchCategoryAndBrandLists() async {
    final kategoriData = await AuthenticationApiCat.getCategories();
    final brandData = await AuthenticationApiBrand.getBrand();

    final kategoriList = kategoriData.data
        .map((k) => {'id': k.id, 'name': k.name})
        .toList();

    final brandList = brandData.data
        .map((b) => {'id': b.id, 'name': b.name})
        .toList();

    return {'kategori': kategoriList, 'brand': brandList};
  }

  /// Tambah produk
  Future<void> _showAddDialog() async {
    final data = await _fetchCategoryAndBrandLists();

    final result = await showProductFormDialog(
      context: context,
      id: null,
      initialData: null,
      kategoriList: data['kategori']!,
      brandList: data['brand']!,
    );

    if (result != null) _loadProducts();
  }

  /// Edit produk
  Future<void> _showEditDialog(Datum product) async {
    final data = await _fetchCategoryAndBrandLists();

    final initialData = Data(
      id: product.id,
      name: product.name,
      description: product.description,
      price: int.tryParse(product.price) ?? 0,
      stock: int.tryParse(product.stock) ?? 0,
      discount: int.tryParse(product.discount) ?? 0,
      category: product.category ?? "",
      categoryId: int.tryParse(product.categoryId ?? "0") ?? 0,
      brand: product.brand ?? "",
      brandId: int.tryParse(product.brandId ?? "0") ?? 0,
      imageUrls: product.imageUrls ?? [],
      imagePaths: [], // kosongkan karena ini hanya untuk upload file baru
    );

    final result = await showProductFormDialog(
      context: context,
      id: product.id,
      initialData: initialData,
      kategoriList: data['kategori']!,
      brandList: data['brand']!,
    );

    if (result != null) _loadProducts();
  }

  Future<void> _deleteProduct(int id) async {
    try {
      await AuthenticationApiProduct.deleteProduct(productId: id);
      _loadProducts();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menghapus produk: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Produk"),
        actions: [IconButton(onPressed: _showAddDialog, icon: Icon(Icons.add))],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? Center(child: Text("Belum ada produk"))
          : GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ProductCard(
                  product: product,
                  onEdit: () => _showEditDialog(product),
                  onDelete: () => _deleteProduct(product.id),
                );
              },
            ),
    );
  }
}
