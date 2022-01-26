import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penon/models/party_model.dart';

class PartyController extends GetxController {
  List<PartyModel> allParties = <PartyModel>[].obs;
  // double cartTaxes = 0.obs as double;
  // double cartBeforeTax = 0.obs as double;

  // int get countitems => cartItems.length;

  // double get cartPrice => cartItems.fold(
  //     0,
  //     (sum, element) =>
  //         sum +
  //         (element.saleprice! * element.quantity!) +
  //         element.deliveryCharge);

  // double get cartShipping =>
  //     cartItems.fold(0, (sum, element) => sum + (element.deliveryCharge));

  // String get cartBeforeTax {
  //   double asd = cartItems.fold(
  //       0,
  //       (sum, element) =>
  //           sum +
  //           (element.saleprice! * element.quantity!) +
  //           element.deliveryCharge);
  //   return (asd - getCartTax).toStringAsFixed(2);
  // }

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    var parties = GetStorage().read('allparties') ?? [];
    print(parties.length);
    parties.forEach((element) {
      allParties.add(PartyModel.fromJson(element));
    });
    if (parties.length == 0) {
      allParties = await getData();
      GetStorage().write('allparties', allParties);
    }
  }

  Future<List<PartyModel>> getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Parties').get();
    return querySnapshot.docs
        .map((m) => PartyModel.fromJson(m.data() as Map<String, dynamic>))
        .toList();
    // return products;
  }

  addPartyToLocal(PartyModel item) {
    // String msg = "${product.name} added to Cart !";
    //   cartItems.add(items);
    allParties.add(item);
    print("Cart Length: ${allParties.length}");
    GetStorage().write('allparties', allParties);
  }
}
