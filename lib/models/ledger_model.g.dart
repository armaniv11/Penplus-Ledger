// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LedgerModel _$LedgerModelFromJson(Map<String, dynamic> json) => LedgerModel(
      ledgerId: json['ledgerId'] as String?,
      partyId: PartyModel.fromJson(json['partyId'] as Map<String, dynamic>),
      creditAmount: (json['creditAmount'] as num).toDouble(),
      debitAmount: (json['debitAmount'] as num).toDouble(),
      transactionType: json['transactionType'] as String,
      narration: json['narration'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      invoiceId: json['invoiceId'] as String,
      companyId: json['companyId'] as String,
      invoiceNo: json['invoiceNo'] as String,
      invoiceDate: DateTime.parse(json['createdAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LedgerModelToJson(LedgerModel instance) =>
    <String, dynamic>{
      'ledgerId': instance.ledgerId,
      'partyId': instance.partyId.toJson(),
      'creditAmount': instance.creditAmount,
      'debitAmount': instance.debitAmount,
      'transactionType': instance.transactionType,
      'narration': instance.narration,
      'isDeleted': instance.isDeleted,
      'invoiceId': instance.invoiceId,
      'companyId': instance.companyId,
      'invoiceNo': instance.invoiceNo,
      'invoiceDate': instance.invoiceDate,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
