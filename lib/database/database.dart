import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:penon/models/company_model.dart';
import 'package:penon/models/item_model.dart';
import 'package:penon/models/ledger_model.dart';
import 'package:penon/models/party_model.dart';
import 'package:penon/models/purchase_model.dart';
import 'package:penon/models/sale_model.dart';
// import 'package:jiffy/jiffy.dart';

class DatabaseService {
  Future clienttagList(tagname, tagid) async {
    await FirebaseFirestore.instance.collection('clients').doc(tagid).update({
      "tag": tagname,
      // "createdat": Jiffy(DateTime.now()).format("EE MMM do, yyyy")
    });
  }

  Future getInfo(collectionname, docname) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection(collectionname)
        .doc(docname)
        .get();
    return documentSnapshot;
  }

  Future getCollection(collection) async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    return querySnapshot;
  }

  getCollectionWhere(collection, doc, {String wherequery: 'signInMob'}) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where(wherequery, isEqualTo: doc)
        .get();
    return querySnapshot;
  }

  getCollectionWhereAnd(
      {required collection,
      required wherefirst,
      required firstmatch,
      required wheresecond,
      required secondmatch}) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where(wherefirst, isEqualTo: firstmatch)
        .where(wheresecond, isEqualTo: secondmatch)
        .get();
    return querySnapshot;
  }

  Future saveOrderCombine(
      doc1,
      orders,
      orderid,
      carttotal,
      ordertotal,
      taxes,
      discount,
      couponcode,
      status,
      orderaddr,
      ordermob,
      delvierycharge,
      soldto,
      signinmob) async {
    await FirebaseFirestore.instance.collection("Orders").doc(doc1).set({
      "orders": orders,
      "orderid": orderid,
      'createdat':
          DateFormat("dd-MM-yyyy hh:mm").format(DateTime.now()).toString(),
      'updatedat': "",
      'cartTotal': carttotal,
      'orderTotal': ordertotal,
      'taxes': taxes,
      'discount': discount,
      'coupon': couponcode,
      'orderStatus': status,
      'orderAddress': orderaddr,
      'orderMob': ordermob,
      'deliverycharge': delvierycharge,
      'soldTo': soldto,
      "signInMob": signinmob,
      "deliveryDate": "",
      "remark": ""
    });
  }

  Future saveOrder(
      doc1,
      doc2,
      orders,
      orderid,
      carttotal,
      ordertotal,
      taxes,
      discount,
      couponcode,
      status,
      orderaddr,
      ordermob,
      delvierycharge,
      soldto) async {
    await FirebaseFirestore.instance
        .collection("Profile")
        .doc(doc1)
        .collection("Orders")
        .doc(doc2)
        .set({
      "orders": orders,
      "orderid": orderid,
      'createdat':
          DateFormat("dd-MM-yyyy hh:mm").format(DateTime.now()).toString(),
      'updatedat': "",
      'cartTotal': carttotal,
      'orderTotal': ordertotal,
      'taxes': taxes,
      'discount': discount,
      'coupon': couponcode,
      'orderStatus': status,
      'orderAddress': orderaddr,
      'orderMob': ordermob,
      'deliverycharge': delvierycharge,
      'soldTo': soldto
    });
  }

  Future addCompany({required CompanyModel companyDetails}) async {
    // Map<String, dynamic> asd = companyDetails.toJson();
    // asd['saleInvoiceCount'] = FieldValue.increment(1);
    await FirebaseFirestore.instance
        .collection('Company')
        .doc(companyDetails.mob1)
        .set(
          companyDetails.toJson(),
        );
  }

  Future addItem({required ItemModel itemDetails}) async {
    await FirebaseFirestore.instance
        .collection('Items')
        .doc(itemDetails.itemId)
        .set(
          itemDetails.toJson(),
        );
  }

  Future addParty({required PartyModel partyDetails}) async {
    await FirebaseFirestore.instance
        .collection('Parties')
        .doc(partyDetails.pid)
        .set(
          partyDetails.toJson(),
        );
  }

  Future addPurchase({required PurchaseModel purchase}) async {
    // Map<String, dynamic> pur = purchase.toJson();
    // pur['invoiceId'] = FieldValue.increment(1);
    await FirebaseFirestore.instance
        .collection('Purchase')
        .doc("purchase.invoiceId")
        .set(
          purchase.toJson(),
        );
  }

  Future<List<PurchaseModel>> loadPurchaseRegister() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Purchase')
        .where('companyId', isEqualTo: '8874030006')
        .get();
    return querySnapshot.docs
        .map((e) => PurchaseModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<SaleModel>> loadSaleRegister() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Sale')
        .where('companyId', isEqualTo: '8874030006')
        .get();
    return querySnapshot.docs
        .map((e) => SaleModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<LedgerModel>> loadLedger() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Ledger')
        .where('companyId', isEqualTo: '8874030006')
        .get();
    return querySnapshot.docs
        .map((e) => LedgerModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }

  Future newProduct(
      {String? productPic,
      String? productName,
      double? price,
      double? salePrice,
      String? description,
      String? care,
      String? category,
      bool? isFeatured,
      bool? onrent,
      double? rentamt,
      double? rentdeposit,
      bool? cod,
      double? deliveryCharge,
      bool? replaceable,
      String? pid,
      String? audience,
      String? taxPercent,
      String? uom,
      int? maxSaleQty,
      int? stock}) async {
    await FirebaseFirestore.instance.collection('Products').doc(pid).set({
      'productpic': productPic,
      'name': productName,
      "price": price,
      "saleprice": salePrice,
      "desc": description,
      "care": care,
      "category": category,
      "isFeatured": isFeatured,
      "onRent": onrent,
      "rentAmount": rentamt,
      "rentDeposit": rentdeposit,
      "cod": cod,
      "deliveryCharge": deliveryCharge,
      "isReplacable": replaceable,
      "pid": pid,
      'createdat':
          DateFormat("dd-MM-yyyy hh:mm").format(DateTime.now()).toString(),
      "rating": 0,
      "reviews": {},
      "sellCount": FieldValue.increment(1),
      "selectedAudience": audience,
      "taxPercent": taxPercent,
      "uom": uom,
      "maxSaleQty": maxSaleQty,
      "stock": stock
    });
  }

  Future updateProduct(
      {String? productPic,
      String? productName,
      double? price,
      double? salePrice,
      String? description,
      String? care,
      String? category,
      bool? isFeatured,
      bool? onrent,
      double? rentamt,
      double? rentdeposit,
      bool? cod,
      double? deliveryCharge,
      bool? replaceable,
      String? pid,
      String? audience,
      String? taxPercent,
      String? uom,
      int? maxSaleQty,
      int? stock}) async {
    await FirebaseFirestore.instance.collection('Products').doc(pid).update({
      'productpic': productPic,
      'name': productName,
      "price": price,
      "saleprice": salePrice,
      "desc": description,
      "care": care,
      "category": category,
      "isFeatured": isFeatured,
      "onRent": onrent,
      "rentAmount": rentamt,
      "rentDeposit": rentdeposit,
      "cod": cod,
      "deliveryCharge": deliveryCharge,
      "isReplacable": replaceable,
      "selectedAudience": audience,
      "taxPercent": taxPercent,
      "uom": uom,
      "maxSaleQty": maxSaleQty,
      "stock": stock
    });
  }

  Future newSubCategory(
      {required String category, required List subcategory}) async {
    await FirebaseFirestore.instance
        .collection('SubCategory')
        .doc('subcategory')
        .set({
      category: FieldValue.arrayUnion(subcategory),
    }, SetOptions(merge: true));
  }

  Future deleteSubCategory(
      {required String category, required List subcategory}) async {
    await FirebaseFirestore.instance
        .collection('SubCategory')
        .doc('subcategory')
        .update(
      {
        category: subcategory,
      },
    );
  }

  Future newBanner(
    bannerPic,
    bannerName,
    pid,
  ) async {
    await FirebaseFirestore.instance.collection('Banners').doc(pid).set({
      'bannerpic': bannerPic,
      'name': bannerName,
      "pid": pid,
      'createdat':
          DateFormat("dd-MM-yyyy hh:mm").format(DateTime.now()).toString(),
    }).then((value) {
      return value;
    });
  }

  Future createProfile(
    String? mob,
  ) async {
    await FirebaseFirestore.instance.collection('Profile').doc(mob).set({
      'mob': mob,
      'createdat':
          DateFormat("dd-MM-yyyy hh:mm").format(DateTime.now()).toString(),
      "name": "",
      "email": "",
      "address": "",
      "city": "",
      "pincode": "",
      "profilepic": "",
      "verified": false,
      'updatedat': "",
      "dob": "",
      "gender": ""
    }).then((value) {
      return value;
    });
  }

  Future updateProfile(String name, String mob, String email, String address,
      String city, String pincode, String profilepic) async {
    await FirebaseFirestore.instance.collection('Profile').doc(mob).update({
      "name": name,
      "email": email,
      "address": address,
      "city": city,
      "pincode": pincode,
      "profilepic": profilepic,
      "verified": false,
      "dob": "",
      "gender": "Male",
      'updatedat':
          DateFormat("dd-MM-yyyy hh:mm").format(DateTime.now()).toString(),
    });
  }

  Future updateSellCount(String? pid) async {
    return await FirebaseFirestore.instance
        .collection('Products')
        .doc(pid)
        .update({
      "sellCount": FieldValue.increment(1),
    });
  }

  // Future addReviewToProduct(doc1, orderid, rating, ReviewModel review) async {
  //   return await FirebaseFirestore.instance
  //       .collection('Products')
  //       .doc(doc1)
  //       .update({"reviews.$orderid": review.toJson(), "rating": rating});
  // }

  Future addReview(doc1, doc2, productid, rating) async {
    return await FirebaseFirestore.instance
        .collection('Orders')
        .doc(doc2)
        .update({"orders.$productid.rating": rating});
  }

  Future updateOrder(orderid, Map order) async {
    return await FirebaseFirestore.instance
        .collection('Orders')
        .doc(orderid)
        .update({
      "orderStatus": order['orderStatus'],
      "deliveryDate": order['deliveryDate'],
      'remark': order['remark']
    });
  }

  Future associatelist() async {
    return FirebaseFirestore.instance.collection("associates").snapshots();
  }

  Future clientlist(id) async {
    return FirebaseFirestore.instance
        .collection("clients")
        .where('associateid', isEqualTo: id)
        .snapshots();
  }

  Future clientSearch(id, param) async {
    return FirebaseFirestore.instance
        .collection("clients")
        .where('clientname', isGreaterThanOrEqualTo: param)
        .where('clientname', isLessThan: param + 'z')
        .where('associateid', isEqualTo: id)
        .snapshots();
  }

  Future notelistclient(id) async {
    return FirebaseFirestore.instance
        .collection("notes")
        .where('clientid', isEqualTo: id)
        .snapshots();
  }

  Future packagelist() async {
    return await FirebaseFirestore.instance.collection("package").snapshots();
  }
}
