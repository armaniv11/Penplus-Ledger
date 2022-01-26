import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/controllers/invoiceItemsController.dart';
import 'package:penon/custom_widgets/widgets.dart';
import 'package:penon/database/database.dart';
import 'package:penon/models/invoice_items_model.dart';
import 'package:penon/models/party_model.dart';
import 'package:penon/models/purchase_model.dart';
import 'package:penon/screens/admin/components/invoice_items_grid.dart';
import 'package:random_string/random_string.dart';

class AddInvoiceItemBottomSheet extends StatefulWidget {
  final PartyModel? partyName;
  final String? invoiceNo;
  final invoiceDate;

  const AddInvoiceItemBottomSheet(
      {Key? key, this.partyName, this.invoiceNo, this.invoiceDate})
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

  savePurchase() async {
    // invoiceItemsController.invoiceItems.forEach((element) {
    //   asd.add(element.toJson());
    // });
    PurchaseModel purchase = PurchaseModel(
        partyName: widget.partyName?.partyName,
        invoiceDate: widget.invoiceDate,
        invoiceItems: invoiceItemsController.invoiceItems,
        invoiceNo: widget.invoiceNo,
        invoiceId: randomAlphaNumeric(6),
        createdAt: DateTime.now(),
        cashDiscount: double.tryParse(discountController.text),
        paidAmount: double.tryParse(paidController.text),
        dueAmount: double.tryParse(dueController.text),
        companyId: '8874030006');
    databaseService.addPurchase(purchase: purchase).then((value) {
      return Flushbar(
        title: "Success",
        message: "Purchase Invoice created Successfully",
        duration: Duration(seconds: 3),
      )..show(context);
    });
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
              color: Colors.blueGrey[100],
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
                      color: Colors.grey[600],
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
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GetX<InvoiceItemsController>(builder: (controller) {
                        return Text(
                          " (${controller.countitems})",
                          style: TextStyle(
                              color: Colors.white,
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
                            color: Colors.white,
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
                      color: Colors.grey[800],
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
