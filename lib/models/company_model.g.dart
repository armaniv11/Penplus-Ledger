// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) => CompanyModel(
      firmName: json['firmName'] as String?,
      firmAddress: json['firmAddress'] as String?,
      state: json['state'] as String?,
      emailID: json['emailID'] as String?,
      mob1: json['mob1'] as String?,
      mob2: json['mob2'] as String?,
      gstType: json['gstType'] as String?,
      gstNo: json['gstNo'] as String?,
      website: json['website'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
      session: json['session'] as String? ?? '2021-22',
    );

Map<String, dynamic> _$CompanyModelToJson(CompanyModel instance) =>
    <String, dynamic>{
      'firmName': instance.firmName,
      'firmAddress': instance.firmAddress,
      'state': instance.state,
      'emailID': instance.emailID,
      'mob1': instance.mob1,
      'mob2': instance.mob2,
      'gstType': instance.gstType,
      'gstNo': instance.gstNo,
      'website': instance.website,
      'session': instance.session,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
