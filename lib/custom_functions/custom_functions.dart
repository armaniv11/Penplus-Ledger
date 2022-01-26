import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

Future<String> customGetImage() async {
  // await Future.delayed(Duration(milliseconds: 500));
  ImagePicker picker = ImagePicker();
  String filepath = '';
  final pickedFile =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
  // setState(() {
  if (pickedFile != null) {
    print("imageselected");
    var img = File(pickedFile.path);
    filepath = pickedFile.path;
  }
  return filepath;
}


// Future<List<ProductModel>> getAllProducts() async {
//   QuerySnapshot querySnapshot =
//       await FirebaseFirestore.instance.collection('Products').get();
//   return querySnapshot.docs
//       .map((m) => ProductModel.fromJson(m.data() as Map<String, dynamic>))
//       .toList();
// }
