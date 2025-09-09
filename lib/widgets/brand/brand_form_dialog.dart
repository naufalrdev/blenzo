import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blenzo/services/api/brand_api.dart';
import 'package:blenzo/models/brand/add_brand.dart';

Future<AddBrandModel?> showBrandFormDialog({
  required BuildContext context,
  int? id,
  String? initialName,
  String? initialImageUrl,
}) {
  final TextEditingController nameController = TextEditingController(
    text: initialName ?? "",
  );
  File? imageFile;
  bool isLoading = false;

  return showDialog<AddBrandModel>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> _pickImage() async {
            final picked = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            if (picked != null) {
              setState(() {
                imageFile = File(picked.path);
              });
            }
          }

          Future<void> _submit() async {
            if (nameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Nama brand wajib diisi")),
              );
              return;
            }

            setState(() => isLoading = true);

            try {
              AddBrandModel result;
              if (id == null) {
                // ADD
                if (imageFile == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Gambar wajib dipilih")),
                  );
                  setState(() => isLoading = false);
                  return;
                }
                result = await AuthenticationApiBrand.addBrand(
                  name: nameController.text,
                  image: imageFile!,
                );
              } else {
                // EDIT
                result = await AuthenticationApiBrand.updateBrand(
                  id: id,
                  name: nameController.text,
                  image: imageFile,
                );
              }

              if (context.mounted) Navigator.pop(context, result);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal simpan brand: $e")),
                );
              }
            } finally {
              setState(() => isLoading = false);
            }
          }

          return AlertDialog(
            title: Text(id == null ? "Tambah Brand" : "Edit Brand"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Nama Brand"),
                  ),
                  const SizedBox(height: 16),
                  if (imageFile != null)
                    Image.file(imageFile!, height: 120, fit: BoxFit.cover)
                  else if (initialImageUrl != null)
                    Image.network(
                      initialImageUrl,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                  else
                    const Text("Belum ada gambar"),
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text("Pilih Gambar"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text(id == null ? "Tambah" : "Simpan"),
                    ),
            ],
          );
        },
      );
    },
  );
}
