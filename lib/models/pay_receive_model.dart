import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:penon/models/party_model.dart';
part 'pay_receive_model.g.dart';

@JsonSerializable()
class PayReceiveModel {
  String? payRecId;
  PartyModel partyId;
  double creditAmount;
  double debitAmount;
  String transactionType;
  String? narration;
  bool isDeleted;
  String companyId;
  String paymentNo;
  @TimestampConvertDatetime()
  DateTime? paymentDate;
  @TimestampConvertDatetime()
  DateTime? createdAt;
  @TimestampConvertDatetime()
  DateTime? updatedAt;

  PayReceiveModel(
      {required this.payRecId,
      required this.partyId,
      required this.creditAmount,
      required this.debitAmount,
      required this.transactionType,
      this.narration,
      this.isDeleted = false,
      required this.paymentNo,
      required this.companyId,
      this.createdAt,
      required this.paymentDate,
      this.updatedAt});

  factory PayReceiveModel.fromJson(Map<String, dynamic> json) =>
      _$PayReceiveModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayReceiveModelToJson(this);
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
