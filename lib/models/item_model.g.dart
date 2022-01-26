// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      itemName: json['itemName'] as String?,
      itemHSN: json['itemHSN'] as String?,
      pid: json['pid'] as String?,
      gst: json['gst'] as int?,
      gstInSP: json['gstInSP'] as bool?,
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble() ?? 0,
      sellPrice: (json['sellPrice'] as num?)?.toDouble() ?? 0,
      uom: json['uom'] as String?,
      inStock: (json['inStock'] as num?)?.toDouble(),
      itemDesc: json['itemDesc'] as String?,
      onRent: json['onRent'] as bool?,
      rentAmt: (json['rentAmt'] as num?)?.toDouble() ?? 0,
      securityAmt: (json['securityAmt'] as num?)?.toDouble() ?? 0,
      companyId: json['companyId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'itemName': instance.itemName,
      'itemHSN': instance.itemHSN,
      'pid': instance.pid,
      'gst': instance.gst,
      'gstInSP': instance.gstInSP,
      'purchasePrice': instance.purchasePrice,
      'sellPrice': instance.sellPrice,
      'uom': instance.uom,
      'inStock': instance.inStock,
      'itemDesc': instance.itemDesc,
      'onRent': instance.onRent,
      'rentAmt': instance.rentAmt,
      'securityAmt': instance.securityAmt,
      'companyId': instance.companyId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
