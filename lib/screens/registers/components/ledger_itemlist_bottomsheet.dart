import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/controllers/invoiceItemsController.dart';
import 'package:penon/custom_widgets/widgets.dart';
import 'package:penon/database/database.dart';
import 'package:penon/models/invoice_items_model.dart';
import 'package:penon/models/ledger_model.dart';
import 'package:penon/models/party_model.dart';
import 'package:penon/models/invoice_model.dart';
import 'package:penon/screens/admin/components/invoice_items_grid.dart';
import 'package:random_string/random_string.dart';

class LedgerItemListBottomSheet extends StatelessWidget {
  final invoice;
  const LedgerItemListBottomSheet({Key? key, required this.invoice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List invoiceItems = invoice.invoiceItems.map((e) => e).toList();
    Size size = MediaQuery.of(context).size;
    return Padding(
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
            Column(
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
                  Text(
                    " (${invoiceItems.length})",
                    style: TextStyle(
                        color: Colors.grey,
                        // fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
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
                    child: ListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: invoiceItems.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return InvoiceItemGrid(
                            index: index + 1,
                            invoiceItem: invoiceItems[index],
                          );
                        })),
              ),
            ),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue[800]!, Colors.grey[800]!]),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Discount',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                            iconWithText(FontAwesomeIcons.rupeeSign, 10,
                                "${invoice.cashDiscount}",
                                color: Colors.white, fontsize: 22),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Paid Amount',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                            iconWithText(FontAwesomeIcons.rupeeSign, 10,
                                "${invoice.paidAmount}",
                                color: Colors.white, fontsize: 22),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Due Amount',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                            iconWithText(FontAwesomeIcons.rupeeSign, 10,
                                "${invoice.dueAmount}",
                                color: Colors.white, fontsize: 22),
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 6,
                    color: Colors.white,
                  ),
                  // Row(
                  //   children: [
                  //     customTextFormField(
                  //         discountController, "Disc.(Rs)", null,
                  //         reverted: true,
                  //         changed: changeDisc,
                  //         width: size.width / 3),
                  //     customTextFormField(paidController, "Paid(Rs)", null,
                  //         reverted: true,
                  //         changed: changePaid,
                  //         width: size.width / 3),
                  //     customTextFormField(dueController, "Due(Rs)", null,
                  //         width: size.width / 3, enabled: false),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 6, right: 6, bottom: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Invoice Total",
                              style: TextStyle(color: Colors.white),
                            ),
                            iconWithText(FontAwesomeIcons.rupeeSign, 10,
                                "${invoice.grandTotal}",
                                color: Colors.yellow, fontsize: 26),
                            // Text(
                            //   "${invoice.grandTotal}",
                            //   style: TextStyle(
                            //       color: Colors.white,
                            //       fontSize: 30,
                            //       fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
                      ),

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
                              // savePurchase();
                            },
                            child: customButton("Delete Invoice",
                                width: size.width / 2.1,
                                backgroundColor: Colors.red,
                                padding: 4,
                                containerHeight: 50,
                                iconData: Icons.delete_outline_outlined,
                                icon: Icons.delete)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}