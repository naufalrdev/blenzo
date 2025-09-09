import 'package:blenzo/models/categories/get_categories.dart';
import 'package:blenzo/services/api/categories_api.dart';
import 'package:blenzo/widgets/categories_form_dialog.dart';
import 'package:flutter/material.dart';

class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  State<CategoriesListScreen> createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  late Future<GetCatModel> _futureCategories;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _futureCategories = AuthenticationApiCat.getCategories();
    });
  }

  Future<void> _addCategory() async {
    final result = await showCategoryFormDialog(context: context);
    if (result != null) {
      _loadCategories();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Category added: ${result.data.name}")),
      );
    }
  }

  Future<void> _editCategory(int id, String name) async {
    final result = await showCategoryFormDialog(
      context: context,
      categoryId: id,
      initialName: name,
    );
    if (result != null) {
      _loadCategories();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Category updated: ${result.data.name}")),
      );
    }
  }

  Future<void> _deleteCategory(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Category"),
        content: const Text("Are you sure you want to delete this category?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await AuthenticationApiCat.deleteCategories(categoriesId: id);
        _loadCategories();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Category deleted")));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: $e")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addCategory),
        ],
      ),
      body: FutureBuilder<GetCatModel>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(child: Text("No categories found"));
          }

          final categories = snapshot.data!.data;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category.name),
                subtitle: Text(category.id.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _editCategory(category.id, category.name),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteCategory(category.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
