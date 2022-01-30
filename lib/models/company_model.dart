import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'company_model.g.dart';

@JsonSerializable()
class CompanyModel {
  String firmName;
  String? firmAddress;
  String? state;
  String? emailID;
  String? mob1;
  String? mob2;
  String? gstType;
  String? gstNo;
  String? website;
  String? session;
  List? permissions;
  bool isDeleted;
  int saleInvoiceCount;
  @TimestampConvertDatetime()
  DateTime? createdAt;
  @TimestampConvertDatetime()
  DateTime? updatedAt;

  CompanyModel(
      {this.firmName = '',
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
      this.isDeleted = false,
      this.permissions,
      this.saleInvoiceCount = 0,
      this.session = '2021-22'});

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);

  factory CompanyModel.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return CompanyModel(
        // Extra fields
        firmName: json['firmName'],
        firmAddress: json['firmAddress'],
        state: json['state'],
        emailID: json['emailID'],
        mob1: json['mob1'], //this is the company Id
        mob2: json['mob2'],
        gstType: json['gstType'],
        gstNo: json['gstNo'],
        website: json['website'],
        createdAt: DateTime.parse(json['createdAt'] as String),
        session:
            json['session'] ?? '2021-22', // just incude the firebase import,
        isDeleted: json['isDeleted'] ?? false,
        permissions: json['permissions'],
        saleInvoiceCount: json['saleInvoiceCount'] ?? 0,
        updatedAt: DateTime.parse(json['createdAt'] as String));
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
