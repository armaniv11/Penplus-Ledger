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
import 'package:penon/models/purchase_model.dart';
import 'package:penon/models/sale_model.dart';
import 'package:penon/screens/admin/components/invoice_items_grid.dart';
import 'package:random_string/random_string.dart';

class AddInvoiceItemBottomSheet extends StatefulWidget {
  final PartyModel partyName;
  final String invoiceNo;
  final invoiceDate;
  final String invoiceType;

  const AddInvoiceItemBottomSheet(
      {Key? key,
      required this.partyName,
      required this.invoiceNo,
      required this.invoiceDate,
      this.invoiceType = 'Purchase'})
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
  List<dynamic> asd = [];
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
    invoiceItemsController.invoiceItems.forEach((element) {
      asd.add(element.toJson());
    });
    print(widget.partyName.mob1);
    String invId = randomAlphaNumeric(6);
    // List<InvoiceItemsModel> asdf = <InvoiceItemsModel>[];

    // PartyModel par = PartyModel(partyName: 'asdff', companyId: '12');
    // });
    SaleModel purchase = SaleModel(
        party: widget.partyName,
        invoiceDate: DateTime.parse(widget.invoiceDate),
        invoiceItems: invoiceItemsController.invoiceItems,
        invoiceNo: widget.invoiceNo,
        invoiceId: invId,
        createdAt: DateTime.now(),
        grandTotal: double.tryParse(invoiceItemsController.totalAfterDeduction),
        cashDiscount: double.tryParse(discountController.text) ?? 0,
        paidAmount: double.tryParse(paidController.text) ?? 0,
        dueAmount: double.tryParse(dueController.text) ?? 0,
        companyId: '8874030006');
    print(purchase.toJson());
    // var ssdd = jsonEncode(purchase);
    // print(purchase.partyName.mob1);
    // await databaseService.addPurchase(purchase: purchase);
    LedgerModel ledgerCredit = LedgerModel(
        ledgerId: randomAlphaNumeric(6),
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
    batch.set(
      db.collection('Sale').doc(purchase.invoiceId),
      purchase.toJson(),
    );
    if (widget.invoiceType == 'Sale') {
      batch.update(db.collection('Company').doc(companyInfo.mob1), {
        'saleInvoiceCount': FieldValue.increment(1),
      });
    }

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
        message: "Sale Invoice created Successfully!!",
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
    if (invoiceItemsController.cashDiscount != 0.0)
      discountController.text = invoiceItemsController.cashDiscount.toString();

    if (invoiceItemsController.paidAmount != 0.0)
      paidController.text = invoiceItemsController.paidAmount.toString();

    if (invoiceItemsController.dueAmount != 0.0)
      dueController.text = invoiceItemsController.dueAfterPaid;
  }

  changeDisc(String data) {
    if (data.isNotEmpty) invoiceItemsController.addCashDiscount(data);
    print(data);
    print(invoiceItemsController.cashDiscount);
    print(invoiceItemsController.totalAfterDeduction);
  }

  changePaid(String data) async {
    if (data.isNotEmpty) invoiceItemsController.addPaidAmount(data);
    dueController.text = await invoiceItemsController.dueAfterPaid;
    print(data);
    print(invoiceItemsController.paidAmount);
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
                // Divider(
                //   thickness: 2,
                //   color: Colors.yellow,
                // ),
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
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          customTextFormField(
                              discountController, "Disc.(Rs)", null,
                              reverted: true,
                              changed: changeDisc,
                              width: size.width / 3),
                          customTextFormField(paidController, "Paid(Rs)", null,
                              reverted: true,
                              changed: changePaid,
                              width: size.width / 3),
                          customTextFormField(dueController, "Due(Rs)", null,
                              width: size.width / 3, enabled: false),
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
                                  Text(
                                    "Invoice Total",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "${controller.totalAfterDeduction}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }),
                          // InkWell(
                          //     onTap: () {
                          //       // saveSubCategory();
                          //       savePurchase();
                          //     },
                          //     child: customButton("Add", width: size.width / 2.1)),
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
