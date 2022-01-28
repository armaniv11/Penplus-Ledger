// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartyModel _$PartyModelFromJson(Map<String, dynamic> json) => PartyModel(
      partyName: json['partyName'] as String?,
      address: json['address'] as String? ?? '',
      gstType: json['gstType'] as String? ?? 'Unregistered',
      gstNo: json['gstNo'] as String? ?? '',
      pid: json['pid'] as String?,
      state: json['state'] as String?,
      mob1: json['mob1'] as String?,
      email: json['email'] as String?,
      openingBal: json['openingBal'] as String?,
      openingType: json['openingType'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      companyId: json['companyId'] as String,
    )
      ..createdAt = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String)
      ..updatedAt = json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String);

Map<String, dynamic> _$PartyModelToJson(PartyModel instance) =>
    <String, dynamic>{
      'partyName': instance.partyName,
      'address': instance.address,
      'pid': instance.pid,
      'gstType': instance.gstType,
      'gstNo': instance.gstNo,
      'state': instance.state,
      'mob1': instance.mob1,
      'email': instance.email,
      'openingBal': instance.openingBal,
      'openingType': instance.openingType,
      'companyId': instance.companyId,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
