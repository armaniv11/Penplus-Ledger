// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseModel _$PurchaseModelFromJson(Map<String, dynamic> json) =>
    PurchaseModel(
      partyName: json['partyName'] as String?,
      invoiceDate: json['invoiceDate'] == null
          ? null
          : DateTime.parse(json['invoiceDate'] as String),
      invoiceNo: json['invoiceNo'] as String?,
      cashDiscount: (json['cashDiscount'] as num?)?.toDouble() ?? 0,
      grandTotal: (json['grandTotal'] as num?)?.toDouble() ?? 0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0,
      dueAmount: (json['dueAmount'] as num?)?.toDouble() ?? 0,
      invoiceId: json['invoiceId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      companyId: json['companyId'] as String?,
      invoiceItems: (json['invoiceItems'] as List<dynamic>?)
          ?.map((e) => InvoiceItemsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PurchaseModelToJson(PurchaseModel instance) =>
    <String, dynamic>{
      'partyName': instance.partyName,
      'invoiceNo': instance.invoiceNo,
      'invoiceDate': instance.invoiceDate?.toIso8601String(),
      'cashDiscount': instance.cashDiscount,
      'grandTotal': instance.grandTotal,
      'paidAmount': instance.paidAmount,
      'dueAmount': instance.dueAmount,
      'invoiceId': instance.invoiceId,
      'companyId': instance.companyId,
      'invoiceItems': instance.invoiceItems,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
