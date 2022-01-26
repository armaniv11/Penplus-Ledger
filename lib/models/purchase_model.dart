import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:penon/models/invoice_items_model.dart';
part 'purchase_model.g.dart';

@JsonSerializable()
class PurchaseModel {
  String? partyName;
  String? invoiceNo;
  @TimestampConvertDatetime()
  DateTime? invoiceDate;
  double? cashDiscount;
  double? grandTotal;
  double? paidAmount;
  double? dueAmount;
  String invoiceId;
  String? companyId;
  bool isDeleted;
  List<InvoiceItemsModel>? invoiceItems;
  @TimestampConvertDatetime()
  DateTime? createdAt;
  @TimestampConvertDatetime()
  DateTime? updatedAt;

  PurchaseModel(
      {this.partyName,
      this.invoiceDate,
      required this.invoiceNo,
      this.cashDiscount = 0,
      this.grandTotal = 0,
      this.paidAmount = 0,
      this.dueAmount = 0,
      required this.invoiceId,
      this.createdAt,
      this.companyId,
      this.invoiceItems,
      this.isDeleted = false,
      this.updatedAt});

  factory PurchaseModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseModelFromJson(json);
  // factory PurchaseModel.fromJson(dynamic json) {
  //   var list = json['invoiceItems'] as List;
  //   print(list.runtimeType); //returns List<dynamic>
  //   List<InvoiceItemsModel> invoiceItems =
  //       list.map((i) => InvoiceItemsModel.fromJson(i)).toList();
  //   return PurchaseModel(
  //       partyName: json['partyName'] as String,
  //       invoiceNo: json['invoiceNo'] as String,
  //       invoiceId: json['invoiceId'] as String,
  //       cashDiscount: (json['cashDiscount'] as num?)?.toDouble() ?? 0,
  //       grandTotal: (json['grandTotal'] as num?)?.toDouble() ?? 0,
  //       paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0,
  //       dueAmount: (json['dueAmount'] as num?)?.toDouble() ?? 0,
  //       invoiceItems: invoiceItems);
  // }

  Map<String, dynamic> toJson() => _$PurchaseModelToJson(this);

  // factory PurchaseModel.fromJson(Map<String, dynamic> json) =>
  //     _$PurchaseModelFromJson(json);

  // Map<String, dynamic> _$PurchaseModelToJson(PurchaseModel instance) =>
  //   <String, dynamic>{
  //     'partyName': instance.partyName,
  //     'invoiceDate': instance.invoiceDate,
  //     'invoiceNo': instance.invoiceNo,
  //     'gstType': instance.gstType,
  //     'gstNo': instance.gstNo,
  //     'state': instance.state,
  //     'mob1': instance.mob1,
  //     'email': instance.email,
  //     'openingBal': instance.openingBal,
  //     'openingType': instance.openingType,
  //     'companyId': instance.companyId,
  //     'createdAt': instance.createdAt?.toIso8601String(),
  //     'updatedAt': instance.updatedAt?.toIso8601String(),
  //   };

  // factory PurchaseModel.fromDoc(DocumentSnapshot doc) {
  //   return PurchaseModel(
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
