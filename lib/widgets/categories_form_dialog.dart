import 'package:blenzo/services/api/categories_api.dart';
import 'package:flutter/material.dart';
import 'package:blenzo/models/categories/add_categories.dart';

Future<AddCategoriesModel?> showCategoryFormDialog({
  required BuildContext context,
  int? categoryId,
  String? initialName,
}) {
  return showDialog<AddCategoriesModel>(
    context: context,
    builder: (context) {
      return _CategoryFormDialog(
        categoryId: categoryId,
        initialName: initialName,
      );
    },
  );
}

class _CategoryFormDialog extends StatefulWidget {
  final int? categoryId;
  final String? initialName;

  const _CategoryFormDialog({this.categoryId, this.initialName});

  @override
  State<_CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<_CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) {
      _nameController.text = widget.initialName!;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      AddCategoriesModel result;
      if (widget.categoryId == null) {
        // ➕ Add
        result = await AuthenticationApiCat.addCategories(
          name: _nameController.text,
        );
      } else {
        // ✏️ Update
        result = await AuthenticationApiCat.updateCategories(
          id: widget.categoryId!,
          name: _nameController.text,
        );
      }

      if (mounted) Navigator.pop(context, result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.categoryId == null ? "Add Category" : "Edit Category"),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: "Category Name"),
          validator: (value) =>
              value == null || value.isEmpty ? "Name required" : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _save,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Save"),
        ),
      ],
    );
  }
}
