import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penon/models/company_model.dart';
import 'package:penon/models/party_model.dart';

class PartyController extends GetxController {
  List<PartyModel> allParties = <PartyModel>[].obs;

  // int get countitems => cartItems.length;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    // GetStorage().erase();
    var parties = GetStorage().read('allparties') ?? <PartyModel>[];
    if (GetStorage().read('selfcompanyinfo') == null) {
      CompanyModel company = await getCompanyData();
      GetStorage().write('selfcompanyinfo', company.toJson());
    }

    if (parties.length == 0) {
      allParties = await getData();
      GetStorage().write('allparties', allParties);
    } else {
      parties.forEach((element) {
        allParties.add(PartyModel.fromJson(element));
      });
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

  Future<CompanyModel> getCompanyData() async {
    print(GetStorage().read('mob1'));
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('Company')
        .doc('8874030006')
        .get();
    // print(object)
    return CompanyModel.fromDoc(docSnapshot);
    // return docSnapshot
    //     .map((m) => PartyModel.fromJson(m.data() as Map<String, dynamic>))
    //     .toList();
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
