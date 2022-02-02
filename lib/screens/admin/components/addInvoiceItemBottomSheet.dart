import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/controllers/invoiceItemsController.dart';
import 'package:penon/custom_widgets/widgets.dart';
import 'package:penon/database/database.dart';
import 'package:penon/models/company_model.dart';
import 'package:penon/models/invoice_items_model.dart';
import 'package:penon/models/ledger_model.dart';
import 'package:penon/models/party_model.dart';
import 'package:penon/models/invoice_model.dart';

import 'package:penon/screens/admin/components/invoice_items_grid.dart';
import 'package:random_string/random_string.dart';

class AddInvoiceItemBottomSheet extends StatefulWidget {
  final PartyModel partyName;
  final String invoiceNo;
  final String invoiceDate;
  final String invoiceType;

  const AddInvoiceItemBottomSheet(
      {Key? key,
      required this.partyName,
      required this.invoiceNo,
      required this.invoiceDate,
      required this.invoiceType})
      : super(key: key);
  // final ValueChanged<bool> callback;

  @override
  _AddInvoiceItemBottomSheetState createState() =>
      _AddInvoiceItemBottomSheetState();
}

class _AddInvoiceItemBottomSheetState extends State<AddInvoiceItemBottomSheet> {
  final DatabaseService databaseService = DatabaseService();
  final InvoiceItemsController invoiceItemsController = Get.find();
  TextEditingController discountController = TextEditingController();
  TextEditingController paidController = TextEditingController();
  TextEditingController dueController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  var db = FirebaseFirestore.instance;
//Create a batch

  savePurchase() async {
    final box = GetStorage();
    CompanyModel companyInfo =
        CompanyModel.fromJson(box.read('selfcompanyinfo'));
    setState(() {
      isLoading = true;
    });
    var batch = db.batch();
    List<dynamic> asd = [];

    print(widget.partyName.mob1);
    String invId = randomAlphaNumeric(12);
    InvoiceModel invoice = InvoiceModel(
        party: widget.partyName,
        invoiceDate: DateTime.parse(widget.invoiceDate),
        invoiceItems: invoiceItemsController.invoiceItems,
        invoiceNo: widget.invoiceNo,
        invoiceId: invId,
        createdAt: DateTime.now(),
        invoiceType: widget.invoiceType,
        grandTotal: double.tryParse(invoiceItemsController.totalAfterDeduction),
        cashDiscount: invoiceItemsController.cashDiscount.value,
        paidAmount: invoiceItemsController.paidAmount.value,
        dueAmount: double.tryParse(dueController.text) ?? 0,
        companyId: '8874030006');
    // List<InvoiceItemsModel> asdf = <InvoiceItemsModel>[];

    // PartyModel par = PartyModel(partyName: 'asdff', companyId: '12');
    // });Timestamp.fromDate(currentPhoneDate)

    LedgerModel ledgerCredit = LedgerModel(
        ledgerId: randomAlphaNumeric(10),
        partyId: widget.partyName,
        creditAmount:
            double.tryParse(invoiceItemsController.totalAfterDeduction)!,
        debitAmount: 0,
        transactionType: widget.invoiceType,
        invoiceId: invId,
        companyId: '8874030006',
        invoiceNo: widget.invoiceNo,
        createdAt: DateTime.now(),
        invoiceDate: DateTime.parse(widget.invoiceDate));
    LedgerModel ledgerDebit = LedgerModel(
      ledgerId: randomAlphaNumeric(6),
      partyId: widget.partyName,
      creditAmount: 0,
      debitAmount: double.tryParse(paidController.text) ?? 0,
      invoiceId: invId,
      companyId: '8874030006',
      invoiceNo: widget.invoiceNo,
      createdAt: DateTime.now(),
      transactionType: widget.invoiceType,
      invoiceDate: DateTime.parse(widget.invoiceDate),
    );

    if (widget.invoiceType == 'Sale') {
      batch.update(db.collection('Company').doc(companyInfo.mob1), {
        'saleInvoiceCount': FieldValue.increment(1),
      });
    }

    batch.set(
      db.collection('Invoices').doc(invoice.invoiceId),
      invoice.toJson(),
    );

    batch.set(
      db.collection('Ledger').doc(ledgerCredit.ledgerId),
      ledgerCredit.toJson(),
    );
    batch.set(
      FirebaseFirestore.instance.collection('Ledger').doc(ledgerDebit.ledgerId),
      ledgerDebit.toJson(),
    );
    batch.commit().then((value) {
      invoiceItemsController.clearInvoiceItems();
      return Flushbar(
        title: "Success",
        message: "${widget.invoiceType} Invoice created Successfully!!",
        duration: Duration(seconds: 2),
      )..show(context).then((value) {
          setState(() {
            isLoading = false;
          });
        });
    });

    // });
  }

  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
  }

  loadData() async {
    if (invoiceItemsController.dueAmount != 0.0)
      dueController.text = invoiceItemsController.dueAfterPaid;
  }

  changeDisc(String data) async {
    await invoiceItemsController.addCashDiscount(data);
    print("$data change disc");
    print("${invoiceItemsController.cashDiscount} printing cashd");
    print(invoiceItemsController.totalAfterDeduction);
    dueController.text = invoiceItemsController.dueAfterPaid;
  }

  changePaid(String data) async {
    invoiceItemsController.addPaidAmount(data);

    dueController.text = invoiceItemsController.dueAfterPaid;
  }

  void deleteClicked(int index) {
    setState(() {
      invoiceItemsController.deleteIndex(index);
      discountController.text = invoiceItemsController.cashDiscount.toString();
      paidController.text = invoiceItemsController.paidAmount.toString();
      dueController.text =
          invoiceItemsController.totalAfterDeduction.toString();
    });
  }

  void editClicked(int Index) {
    Navigator.pop(context, Index);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, top: 30),
        child: Container(
          // padding: EdgeInsets.only(top: 6),
          // height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24), topLeft: Radius.circular(24))),
          child:
              // ListView(
              //   children: <Widget>[
              Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 6, bottom: 6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.edgesensor_high,
                        color: Colors.transparent,
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: Text(
                          "Invoice Items",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GetX<InvoiceItemsController>(builder: (controller) {
                        return Text(
                          " (${controller.countitems})",
                          style: TextStyle(
                              color: Colors.black,
                              // fontSize: 30,
                              fontWeight: FontWeight.bold),
                        );
                      }),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: size.height * 0.65,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GetBuilder<InvoiceItemsController>(
                            builder: (controller) {
                          return ListView.builder(
                              shrinkWrap: true,
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.invoiceItems.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return InvoiceItemGrid(
                                  index: index + 1,
                                  invoiceItem: controller.invoiceItems[index],
                                  isEditable: true,
                                  callback: deleteClicked,
                                  callbackItemIndex: editClicked,
                                );
                              });
                        })),
                  ),
                ),
                Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.blue[900]!, Colors.grey[800]!]),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: size.width / 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 4),
                              child: GetX<InvoiceItemsController>(
                                  builder: (controller) {
                                return TextFormField(
                                    keyboardType: TextInputType.number,
                                    initialValue:
                                        controller.cashDiscount.toString(),
                                    decoration: const InputDecoration(
                                        label: Text('Disc (Rs)'),
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        fillColor: Colors.white,
                                        filled: true,
                                        isDense: true,
                                        border: InputBorder.none),
                                    onChanged: (val) {
                                      changeDisc(val);
                                    });
                              }),
                            ),
                          ),
                          Container(
                            width: size.width / 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 4),
                              child: GetX<InvoiceItemsController>(
                                  builder: (controller) {
                                return TextFormField(
                                    keyboardType: TextInputType.number,
                                    initialValue:
                                        controller.paidAmount.toString(),
                                    decoration: const InputDecoration(
                                        label: Text('Paid (Rs)'),
                                        labelStyle:
                                            TextStyle(color: Colors.black),
                                        fillColor: Colors.white,
                                        filled: true,
                                        isDense: true,
                                        border: InputBorder.none),
                                    onChanged: (val) {
                                      changePaid(val);
                                    });
                              }),
                            ),
                          ),
                          Container(
                            width: size.width / 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 4),
                              child: TextFormField(
                                enabled: false,
                                keyboardType: TextInputType.number,
                                controller: dueController,
                                decoration: const InputDecoration(
                                    label: Text('Due (Rs)'),
                                    labelStyle: TextStyle(color: Colors.black),
                                    fillColor: Colors.white,
                                    filled: true,
                                    isDense: true,
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GetX<InvoiceItemsController>(builder: (controller) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 6, right: 6, bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Invoice Total",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    controller.totalAfterDeduction,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }),
                          Expanded(
                            child: InkWell(
                                onTap: () {
                                  // saveSubCategory();
                                  savePurchase();
                                },
                                child: customButton("Add",
                                    width: size.width / 2.1,
                                    backgroundColor: Colors.yellow,
                                    padding: 4,
                                    containerHeight: 50)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
