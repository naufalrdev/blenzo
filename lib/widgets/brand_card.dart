import 'package:blenzo/models/brand/get_brand.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:flutter/material.dart';

class BrandCard extends StatelessWidget {
  final BrandDetail brand;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const BrandCard({
    super.key,
    required this.brand,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: brand.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  brand.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(Icons.image, size: 40),
        title: Text(
          brand.name,
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          brand.id.toString() ?? "",
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
