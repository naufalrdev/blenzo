import 'package:blenzo/models/brand/get_brand.dart';
import 'package:blenzo/models/categories/get_categories.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:flutter/material.dart';

class CategoriesCard extends StatelessWidget {
  final GetCat categories;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const CategoriesCard({
    super.key,
    required this.categories,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          categories.name,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          categories.id.toString() ?? "",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onEdit,
              icon: Icon(Icons.edit, color: AppColor.primary),
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
