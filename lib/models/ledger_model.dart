import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:penon/models/party_model.dart';
part 'ledger_model.g.dart';

@JsonSerializable()
class LedgerModel {
  String? ledgerId;
  PartyModel partyId;
  double creditAmount;
  double debitAmount;
  String transactionType;
  String? narration;
  bool isDeleted;
  @TimestampConvertDatetime()
  DateTime? createdAt;
  @TimestampConvertDatetime()
  DateTime? updatedAt;

  LedgerModel(
      {required this.ledgerId,
      required this.partyId,
      required this.creditAmount,
      required this.debitAmount,
      required this.transactionType,
      this.narration,
      this.isDeleted = false,
      this.createdAt,
      this.updatedAt});

  factory LedgerModel.fromJson(Map<String, dynamic> json) =>
      _$LedgerModelFromJson(json);

  Map<String, dynamic> toJson() => _$LedgerModelToJson(this);
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
