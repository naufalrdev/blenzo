// import 'dart:convert';
// import 'dart:io';

// class ImageHelper {
//   static Future<String?> pickImageAsBase64() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       final bytes = await File(pickedFile.path).readAsBytes();
//       return base64Encode(bytes);
//     }
//     return null;
//   }
// }
