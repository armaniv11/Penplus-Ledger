import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'item_model.g.dart';

@JsonSerializable()
class ItemModel {
  String? itemName;
  String? itemHSN;
  String? itemId;
  int? gst;
  bool? gstInSP;
  double? purchasePrice;
  double? sellPrice;
  String? uom;
  double? inStock;
  String? itemDesc;
  bool? onRent;
  double? rentAmt;
  double? securityAmt;
  String? companyId;
  bool isDeleted;
  @TimestampConvertDatetime()
  DateTime? createdAt;
  @TimestampConvertDatetime()
  DateTime? updatedAt;

  ItemModel(
      {this.itemName,
      this.itemHSN,
      this.itemId,
      this.gst,
      this.gstInSP,
      this.purchasePrice = 0,
      this.sellPrice = 0,
      this.uom,
      this.inStock,
      this.itemDesc,
      this.onRent,
      this.rentAmt = 0,
      this.securityAmt = 0,
      this.companyId,
      this.createdAt,
      this.isDeleted = false,
      this.updatedAt});

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemModelToJson(this);

  // factory ItemModel.fromDoc(DocumentSnapshot doc) {
  //   return ItemModel(
  //     // Extra fields
  //     firmName: doc["firmName"],
  //     firmAddress: doc['firmAddress'],
  //     state: doc['state'],
  //     emailID: doc['emailID'],
  //     mob1: doc['mob1'],
  //     mob2: doc['mob2'],
  //     gstType: doc['gstType'],
  //     gstNo: doc['gstNo'],
  //     website: doc['website'],
  //     createdAt: doc['createdAt'], // just incude the firebase import
  //   );
  // }
}

class TimestampConvertDatetime implements JsonConverter<DateTime, Timestamp> {
  const TimestampConvertDatetime();
  @override
  DateTime fromJson(Timestamp json) {
    return json.toDate();
  }

  @override
  Timestamp toJson(DateTime object) {
    return Timestamp.fromDate(object);
  }
}
