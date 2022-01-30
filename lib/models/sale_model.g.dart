// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleModel _$SaleModelFromJson(Map<String, dynamic> json) => SaleModel(
      party: PartyModel.fromJson(json['party'] as Map<String, dynamic>),
      invoiceDate: const TimestampConvertDatetime()
          .fromJson(json['invoiceDate'] as Timestamp),
      invoiceNo: json['invoiceNo'] as String,
      cashDiscount: (json['cashDiscount'] as num?)?.toDouble() ?? 0,
      grandTotal: (json['grandTotal'] as num?)?.toDouble() ?? 0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0,
      dueAmount: (json['dueAmount'] as num?)?.toDouble() ?? 0,
      invoiceId: json['invoiceId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      companyId: json['companyId'] as String?,
      invoiceItems: (json['invoiceItems'] as List<dynamic>)
          .map((e) => InvoiceItemsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isDeleted: json['isDeleted'] as bool? ?? false,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SaleModelToJson(SaleModel instance) {
  var asd = instance.invoiceItems.map((e) => e.toJson()).toList();
  return <String, dynamic>{
    'party': instance.party.toJson(),
    'invoiceNo': instance.invoiceNo,
    'invoiceDate':
        const TimestampConvertDatetime().toJson(instance.invoiceDate),
    'cashDiscount': instance.cashDiscount,
    'grandTotal': instance.grandTotal,
    'paidAmount': instance.paidAmount,
    'dueAmount': instance.dueAmount,
    'invoiceId': instance.invoiceId,
    'companyId': instance.companyId,
    'isDeleted': instance.isDeleted,
    'invoiceItems': asd,
    'createdAt': instance.createdAt?.toIso8601String(),
    'updatedAt': instance.updatedAt?.toIso8601String(),
  };
}
