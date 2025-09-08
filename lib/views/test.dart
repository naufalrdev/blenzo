import 'dart:io';

import 'package:blenzo/services/api/brand_api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TestDart extends StatefulWidget {
  const TestDart({super.key});

  @override
  State<TestDart> createState() => _TestDartState();
}

class _TestDartState extends State<TestDart> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;
  pickFoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print(image);
    print(image?.path);
    setState(() {
      pickedFile = image;
    });

    if (image == null) {
      return;
    } else {
      final response = await AuthenticationApiBrand.addBrand(
        name: "ACAK",
        image: File(image.path),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Berhasil upload gambar")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          pickedFile != null
              ? Image.file(File(pickedFile?.path ?? ""))
              : Container(
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  height: 200,
                  width: 200,

                  child: Text("Gambar belum di upload"),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: pickFoto, child: Text("Ambil Foto")),
            ],
          ),
        ],
      ),
    );
  }
}
