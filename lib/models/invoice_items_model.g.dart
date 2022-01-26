// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItemsModel _$InvoiceItemsModelFromJson(Map<String, dynamic> json) =>
    InvoiceItemsModel(
      itemName: json['itemName'] as String?,
      itemId: json['itemId'] as String?,
      uom: json['uom'] as String? ?? 'Pcs',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      taxPercent: (json['taxPercent'] as num?)?.toDouble() ?? 0,
      cgst: (json['cgst'] as num?)?.toDouble() ?? 0,
      sgst: (json['sgst'] as num?)?.toDouble() ?? 0,
      igst: (json['igst'] as num?)?.toDouble() ?? 0,
      cess: (json['cess'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$InvoiceItemsModelToJson(InvoiceItemsModel instance) =>
    <String, dynamic>{
      'itemName': instance.itemName,
      'itemId': instance.itemId,
      'uom': instance.uom,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'total': instance.total,
      'taxPercent': instance.taxPercent,
      'cgst': instance.cgst,
      'sgst': instance.sgst,
      'igst': instance.igst,
      'cess': instance.cess,
    };
