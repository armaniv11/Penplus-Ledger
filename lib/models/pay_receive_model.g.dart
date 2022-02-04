// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay_receive_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayReceiveModel _$PayReceiveModelFromJson(Map<String, dynamic> json) =>
    PayReceiveModel(
      payRecId: json['payRecId'] as String?,
      partyId: PartyModel.fromJson(json['partyId'] as Map<String, dynamic>),
      creditAmount: (json['creditAmount'] as num).toDouble(),
      debitAmount: (json['debitAmount'] as num).toDouble(),
      transactionType: json['transactionType'] as String,
      narration: json['narration'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      paymentNo: json['paymentNo'] as String,
      companyId: json['companyId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      paymentDate: json['paymentDate'] == null
          ? null
          : DateTime.parse(json['paymentDate'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PayReceiveModelToJson(PayReceiveModel instance) =>
    <String, dynamic>{
      'payRecId': instance.payRecId,
      'partyId': instance.partyId.toJson(),
      'creditAmount': instance.creditAmount,
      'debitAmount': instance.debitAmount,
      'transactionType': instance.transactionType,
      'narration': instance.narration,
      'isDeleted': instance.isDeleted,
      'companyId': instance.companyId,
      'paymentNo': instance.paymentNo,
      'paymentDate': instance.paymentDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
