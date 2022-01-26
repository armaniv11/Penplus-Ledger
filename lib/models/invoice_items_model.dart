import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:penon/models/item_model.dart';
part 'invoice_items_model.g.dart';

@JsonSerializable()
class InvoiceItemsModel {
  ItemModel? item;
  String? itemId;
  String? uom;
  double? quantity;
  double? unitPrice;
  double? total;
  double? taxPercent;
  double? cgst;
  double? sgst;
  double? igst;
  double? cess;

  InvoiceItemsModel({
    this.item,
    this.itemId,
    this.uom = 'Pcs',
    this.quantity = 1,
    this.unitPrice = 0,
    this.total = 0,
    this.taxPercent = 0,
    this.cgst = 0,
    this.sgst = 0,
    this.igst = 0,
    this.cess = 0,
  });

  factory InvoiceItemsModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceItemsModelToJson(this);

  // // factory InvoiceItemsModel.fromDoc(DocumentSnapshot doc) {
  // //   return InvoiceItemsModel(
  // //     // Extra fields
  // //     firmName: doc["firmName"],
  // //     firmAddress: doc['firmAddress'],
  // //     state: doc['state'],
  // //     emailID: doc['emailID'],
  // //     mob1: doc['mob1'],
  // //     mob2: doc['mob2'],
  // //     gstType: doc['gstType'],
  // //     gstNo: doc['gstNo'],
  // //     website: doc['website'],
  // //     createdAt: doc['createdAt'], // just incude the firebase import
  // //   );
  // // }
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
