import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penon/models/item_model.dart';

class ItemController extends GetxController {
  List<ItemModel> allItems = <ItemModel>[].obs;
  List<ItemModel> rentedProducts = <ItemModel>[].obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    var items = GetStorage().read('allitems') ?? <ItemModel>[];
    print(items.length);
    items.forEach((element) {
      allItems.add(ItemModel.fromJson(element));
    });
    if (items.length == 0 || items == null) {
      allItems = await getData();
      GetStorage().write('allitems', allItems);
    }
  }

  Future<List<ItemModel>> getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Items').get();
    return querySnapshot.docs
        .map((m) => ItemModel.fromJson(m.data() as Map<String, dynamic>))
        .toList();
    // return products;
  }

  Future<List<ItemModel>> getRentedProducts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .where('onRent', isEqualTo: true)
        .get();
    return querySnapshot.docs
        .map((m) => ItemModel.fromJson(m.data() as Map<String, dynamic>))
        .toList();
    // return products;
  }

  addItemToLocal(ItemModel item) {
    // String msg = "${product.name} added to Cart !";
    //   cartItems.add(items);
    allItems.add(item);
    print("Cart Length: ${allItems.length}");
    GetStorage().write('allitems', allItems);
  }

  // Future<List<ItemModel>> filterByCategory(String catname) async {
  //   if (catname == 'All') return products;
  //   List<ItemModel> pro = <ItemModel>[];
  //   products.forEach((element) {
  //     element.category == catname ? pro.add(element) : null;
  //   });
  //   return pro;
  // }

  // Future<List<ItemModel>> filterByRentable({bool isRentable = true}) async {
  //   // if (catname == 'All') return products;
  //   List<ItemModel> pro = <ItemModel>[];
  //   rentedProducts.forEach((element) {
  //     element.onRent == isRentable ? pro.add(element) : null;
  //   });
  //   return pro;
  // }
}
