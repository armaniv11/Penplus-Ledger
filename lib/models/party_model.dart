import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'party_model.g.dart';

@JsonSerializable()
class PartyModel {
  String partyName;
  String? address;
  String? pid;
  String? gstType;
  String? gstNo;
  String? state;
  String? mob1;
  String? email;
  String? openingBal;
  String? openingType;
  String companyId;
  bool isDeleted;
  @TimestampConvertDatetime()
  DateTime? createdAt;
  @TimestampConvertDatetime()
  DateTime? updatedAt;

  PartyModel(
      {required this.partyName,
      this.address,
      this.gstType,
      this.gstNo,
      this.pid,
      this.state,
      this.mob1,
      this.email,
      this.openingBal,
      this.openingType,
      this.isDeleted = false,
      required this.companyId});

  factory PartyModel.fromJson(Map<String, dynamic> json) =>
      _$PartyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PartyModelToJson(this);

  // factory PartyModel.fromDoc(DocumentSnapshot doc) {
  //   return PartyModel(
  //     // Extra fields
  //     firmName: doc["firmName"],
  //     firmAddress: doc['firmAddress'],
  //     state: doc['state'],
  //     emailID: doc['emailID'],
  //     mob1: doc['mob1'],
  //     mob2: doc['mob2'],
  //     gstType: doc['gstType'],
  //     gstNo: doc['gstNo'],
  //     website: doc['website'],
  //     createdAt: doc['createdAt'], // just incude the firebase import
  //   );
  // }
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
