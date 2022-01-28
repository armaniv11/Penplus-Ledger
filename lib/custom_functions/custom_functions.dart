import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:penon/models/item_model.dart';
import 'package:penon/models/party_model.dart';

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

Future<List<ItemModel>> searchItem(
    List<ItemModel> products, String searchText) async {
  List<ItemModel> asd = <ItemModel>[];
  products.forEach((element) {
    print(element.itemName);
    print(searchText);
    if (element.itemName.contains(searchText)) {
      print(element.itemName);
      print("found");
      asd.add(element);
    }
  });
  return asd;
}

Future<List<PartyModel>> searchParty(
    List<PartyModel> products, String searchText) async {
  List<PartyModel> asd = <PartyModel>[];
  products.forEach((element) {
    // print(element.itemName);
    print(searchText);
    if (element.partyName!.contains(searchText)) {
      print(element.partyName);
      print("found");
      asd.add(element);
    }
  });
  return asd;
}


// Future<List<ProductModel>> getAllProducts() async {
//   QuerySnapshot querySnapshot =
//       await FirebaseFirestore.instance.collection('Products').get();
//   return querySnapshot.docs
//       .map((m) => ProductModel.fromJson(m.data() as Map<String, dynamic>))
//       .toList();
// }
