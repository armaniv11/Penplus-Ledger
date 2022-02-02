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
  RxDouble dueAmount = 0.0.obs;
  // double cartTaxes = 0.obs as double;
  // double cartBeforeTax = 0.obs as double;

  int get countitems => invoiceItems.length;

  double get invoiceTotalWithoutDiscount => invoiceItems.fold(
      0, (sum, element) => sum + (element.total! * element.quantity!));

  // double get cartShipping =>
  //     cartItems.fold(0, (sum, element) => sum + (element.deliveryCharge));

  String get totalAfterDeduction {
    if (invoiceItems.isEmpty) {
      print("if Running");
      cashDiscount.value = 0.0;
      paidAmount.value = 0.0;
      dueAmount.value = 0.0;
      return '0';
    } else {
      print("else part Running");

      double asd = invoiceItems.fold(
          0, (sum, element) => sum + (element.total! * element.quantity!));
      if (cashDiscount.value == 0) {
        return asd.toStringAsFixed(2);
      }

      return (asd - cashDiscount.value).toStringAsFixed(2);
    }
  }

  String get dueAfterPaid {
    dueAmount.value = double.tryParse(totalAfterDeduction)! - paidAmount.value;
    return dueAmount.value.toStringAsFixed(2);
  }

  // this add invoice Item to Invoice
  addItemToInvoice(InvoiceItemsModel item) {
    // String msg = "${product.name} added to Cart !";
    //   cartItems.add(items);
    int itemIndex =
        invoiceItems.indexWhere((element) => element.itemId == item.itemId);
    // print(item.itemId);
    print(itemIndex);
    if (itemIndex == -1) {
      print("Match");
      invoiceItems.add(item);
    } else {
      print("replaced");
      invoiceItems[itemIndex] = item;
    }
    dueAmount.value = double.tryParse(totalAfterDeduction)!;
  }

  deleteIndex(int index) {
    invoiceItems.removeAt(index);
  }

  addCashDiscount(String disc) {
    cashDiscount.value = disc.isEmpty ? 0 : double.tryParse(disc)!;
  }

  addPaidAmount(amt) {
    paidAmount.value = double.tryParse(amt) ?? 0;
  }

  clearInvoiceItems() {
    invoiceItems.clear();
    cashDiscount.value = 0;
    paidAmount.value = 0;
    dueAmount.value = 0;
  }
}
