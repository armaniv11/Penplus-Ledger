import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penon/models/invoice_items_model.dart';
import 'package:penon/models/party_model.dart';

class InvoiceItemsController extends GetxController {
  List<InvoiceItemsModel> invoiceItems = <InvoiceItemsModel>[].obs;
  RxDouble cashDiscount = 0.0.obs;
  RxDouble paidAmount = 0.0.obs;
  // double cartTaxes = 0.obs as double;
  // double cartBeforeTax = 0.obs as double;

  int get countitems => invoiceItems.length;

  double get invoiceTotalWithoutDiscount => invoiceItems.fold(
      0, (sum, element) => sum + (element.total! * element.quantity!));

  // double get cartShipping =>
  //     cartItems.fold(0, (sum, element) => sum + (element.deliveryCharge));

  String get totalAfterDeduction {
    double asd = invoiceItems.fold(
        0, (sum, element) => sum + (element.total! * element.quantity!));
    return (asd - cashDiscount.value - paidAmount.value).toStringAsFixed(2);
  }

  // this add invoice Item to Invoice
  addItemToInvoice(InvoiceItemsModel item) {
    // String msg = "${product.name} added to Cart !";
    //   cartItems.add(items);
    invoiceItems.add(item);
    // print("Cart Length: ${allParties.length}");
    // GetStorage().write('allparties', allParties);
  }

  addCashDiscount(disc) {
    cashDiscount.value = double.tryParse(disc)!;
  }

  addPaidAmount(amt) {
    paidAmount.value = double.tryParse(amt)!;
  }
}