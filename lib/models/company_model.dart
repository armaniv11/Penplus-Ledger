import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'company_model.g.dart';

@JsonSerializable()
class CompanyModel {
  String? firmName;
  String? firmAddress;
  String? state;
  String? emailID;
  String? mob1;
  String? mob2;
  String? gstType;
  String? gstNo;
  String? website;
  String? session;
  @TimestampConvertDatetime()
  DateTime? createdAt;
  @TimestampConvertDatetime()
  DateTime? updatedAt;

  CompanyModel(
      {this.firmName,
      this.firmAddress,
      this.state,
      this.emailID,
      this.mob1,
      this.mob2,
      this.gstType,
      this.gstNo,
      this.website,
      this.createdAt,
      this.updatedAt,
      this.session = '2021-22'});

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);

  factory CompanyModel.fromDoc(DocumentSnapshot doc) {
    return CompanyModel(
        // Extra fields
        firmName: doc["firmName"],
        firmAddress: doc['firmAddress'],
        state: doc['state'],
        emailID: doc['emailID'],
        mob1: doc['mob1'],
        mob2: doc['mob2'],
        gstType: doc['gstType'],
        gstNo: doc['gstNo'],
        website: doc['website'],
        createdAt: doc['createdAt'],
        session: doc['session'] ?? "2021-22" // just incude the firebase import
        );
  }
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
