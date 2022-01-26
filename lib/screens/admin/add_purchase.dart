import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/appconstants.dart';
import 'package:penon/controllers/itemController.dart';
import 'package:penon/controllers/partyController.dart';
import 'package:penon/controllers/invoiceItemsController.dart';
import 'package:penon/custom_classes/custom_classes.dart';
import 'package:penon/custom_widgets/widgets.dart';
import 'package:penon/database/database.dart';
import 'package:penon/models/invoice_items_model.dart';
import 'package:penon/models/item_model.dart';
import 'package:penon/models/party_model.dart';
import 'package:random_string/random_string.dart';

import 'components/addInvoiceItemBottomSheet.dart';

class AddPurchase extends StatefulWidget {
  final String? productId;
  const AddPurchase({Key? key, this.productId = ''}) : super(key: key);

  @override
  _AddPurchaseState createState() => _AddPurchaseState();
}

class _AddPurchaseState extends State<AddPurchase> {
  final ItemController itemController = Get.find();
  final PartyController partyController = Get.find();
  final InvoiceItemsController invoiceItemsController = Get.find();
  TextEditingController invoiceNoController = TextEditingController();
  TextEditingController cashDiscountController = TextEditingController();
  TextEditingController grandTotalController = TextEditingController();
  TextEditingController paidController = TextEditingController();
  TextEditingController dueController = TextEditingController();
  TextEditingController unitPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController totalController = TextEditingController(text: "0");

  String? _selectedParty;
  String? _selectedItem;
  String? _selectedUOM = "Pcs";
  String labelText = 'Add Item To Invoice';
  String? _selectedTax = '0';

  List<String> partyMenu = [];
  List<PartyModel> partyModelMenu = [];
  List<String> itemMenu = [];
  List<ItemModel> itemModelMenu = [];

  List<String> uomMenu = [
    'Add New',
    'Pcs',
    'Kg',
    'Dozen',
    'Pound',
  ];

  List<String> taxMenu = AppConstants.gstMenu;

  bool gstInSP = false;
  bool isLoading = true;

  DatabaseService databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  PartyModel? selectedPartyModel;

  void selectParty(String selected) {
    setState(() {
      _selectedParty = selected;
    });
    selectedPartyModel =
        partyModelMenu.firstWhere((element) => element.partyName == selected);
  }

  void selectTax(String selected) {
    setState(() {
      isLoading = true;
      _selectedTax = selected;
    });
    calculateFieldWise();
  }

  void selectUOM(String selected) {
    setState(() {
      if (selected == 'Add New') {}
      _selectedUOM = selected;
    });
  }

  void selectTextField(String selected) {
    setState(() {
      print(selected);
      calculateFieldWise();
    });
  }

  ItemModel? selectedItemModel;

  void selectItem(String selected) {
    setState(() {
      isLoading = true;
      _selectedItem = selected;
    });
    selectedItemModel =
        itemModelMenu.firstWhere((element) => element.itemName == selected);
    calcualateQty(selectedItemModel!);
  }

  double cgst = 0;
  double sgst = 0;
  double igst = 0;

// calculates when fields are edited manually
  calculateFieldWise() async {
    double qty = quantityController.text.isEmpty
        ? 1
        : double.tryParse(quantityController.text)!;
    var asd = double.tryParse(unitPriceController.text)! * qty;

    double taxInRupee =
        double.tryParse(_selectedTax!)! * 0.01 * asd; // tax in rupees
    cgst = sgst = taxInRupee / 2;

    asd = asd + taxInRupee;
    totalController.text = asd.toString();
    setState(() {
      isLoading = false;
    });
  }

// calculates when item from dorpdown changed
  calcualateQty(ItemModel item) async {
    print(item.itemDesc);
    unitPriceController.text = item.purchasePrice.toString();

    if (quantityController.text.isEmpty) {
      quantityController.text = '1';
    }
    var asd = double.tryParse(unitPriceController.text)! *
        double.tryParse(quantityController.text)!;
    double taxInRupee = item.gst! * 0.01 * asd;
    cgst = sgst = taxInRupee / 2;
    asd = asd + taxInRupee;

    totalController.text = asd.toString();
    _selectedTax = item.gst.toString();
    setState(() {
      isLoading = false;
    });
  }

  saveItem() async {
    InvoiceItemsModel invoiceItem = InvoiceItemsModel(
        itemName: _selectedItem,
        uom: _selectedUOM,
        quantity: double.tryParse(quantityController.text),
        unitPrice: double.tryParse(unitPriceController.text),
        total: double.tryParse(totalController.text),
        taxPercent: double.tryParse(_selectedTax!),
        cgst: cgst,
        sgst: sgst,
        igst: igst,
        cess: 0);
    invoiceItemsController.addItemToInvoice(invoiceItem);
    await showModalBottomSheet(
      isScrollControlled: true,
      // isDismissible: true,
      context: context,
      builder: (context) {
        return AddInvoiceItemBottomSheet(
          partyName: selectedPartyModel!,
          invoiceNo: invoiceNoController.text,

          // callback: changeCart,
        );
      },
    ).then((value) {
      // if (value != null) _addItem(value);
    });
  }

  @override
  void initState() {
    loadData();

    // TODO: implement initState
    super.initState();
  }

  loadData() async {
    partyMenu =
        await partyController.allParties.map((e) => e.partyName).toList();
    partyModelMenu = await partyController.allParties.map((e) => e).toList();
    itemMenu = itemController.allItems.map((e) => e.itemName!).toList();
    itemModelMenu = itemController.allItems.map((e) => e).toList();

    setState(() {
      isLoading = false;
    });
    itemMenu.forEach((element) {
      print(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.5)),
        child: Scaffold(
          // backgroundColor: Colors.pink.withOpacity(0.7),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text("Purchase"),
            elevation: 0,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
            child: FloatingActionButton.extended(
                // backgroundColor: Colors.transparent,
                onPressed: () {},
                label: Material(
                  elevation: 8,
                  child: Container(
                    height: 80,
                    width: width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[800]!,
                            offset: const Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Colors.blue,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GetX<InvoiceItemsController>(builder: (controller) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.grey),
                                child: Text(
                                  "${controller.countitems}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                controller.countitems > 1
                                    ? " Items  "
                                    : " Item  ",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              controller.countitems == 0
                                  ? InkWell(
                                      onTap: () async {
                                        Flushbar(
                                          title: "Success!!",
                                          message: "Invoice has 0 items!!",
                                          duration: const Duration(seconds: 3),
                                        )..show(context);
                                        // customToast("Add items to cart first!!");
                                      },
                                      child: customButton("View Items",
                                          width: width / 2.3,
                                          color: Colors.white54,
                                          backgroundColor: Colors.grey))
                                  : InkWell(
                                      onTap: () async {
                                        await showModalBottomSheet(
                                          isScrollControlled: true,
                                          // isDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            return AddInvoiceItemBottomSheet(
                                              partyName: selectedPartyModel!,
                                              invoiceNo:
                                                  invoiceNoController.text,

                                              // callback: changeCart,
                                            );
                                          },
                                        ).then((value) {
                                          // if (value != null) _addItem(value);
                                        });
                                      },
                                      child: customButton("view items",
                                          icon: Icons.arrow_forward,
                                          fontsize: 14,
                                          width: width / 2))
                            ],
                          );
                        })
                      ],
                    ),
                  ),
                )),
          ),
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    customTextFormField(
                        invoiceNoController,
                        "Invoice No",
                        Icon(
                          FontAwesomeIcons.stickyNote,
                          size: 16,
                        ),
                        validationEnabled: true),
                    CustomDateField(heading: "Invoice Date"),
                    CustomDropDown(
                        heading: "Party",
                        items: partyMenu,
                        selected: _selectedParty,
                        callBack: selectParty),
                    // customTextFormField(
                    //   hsnController,
                    //   "Item HSN",
                    //   Icon(
                    //     FontAwesomeIcons.gripVertical,
                    //     size: 16,
                    //   ),
                    // ),
                    CustomDropDown(
                        heading: "Item",
                        items: itemMenu,
                        selected: _selectedItem,
                        callBack: selectItem),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTextFormField(
                            unitPriceController, "Unit Price", null,
                            inputtype: TextInputType.number,
                            width: width / 2,
                            reverted: true,
                            changed: selectTextField,
                            validationEnabled: true),
                        Expanded(
                          child: CustomDropDown(
                              heading: "Tax%",
                              items: taxMenu,
                              selected: _selectedTax,
                              showHeading: true,
                              callBack: selectTax),
                        ),

                        // Expanded(
                        //   child: customTextFormField(
                        //     totalController,
                        //     "Total",
                        //     null,
                        //     inputtype: TextInputType.number,
                        //     width: width / 2.7,
                        //   ),
                        // ),
                      ],
                    ),
                    Row(
                      children: [
                        customTextFormField(
                          quantityController,
                          "quantity",
                          null,
                          inputtype: TextInputType.number,
                          reverted: true,
                          changed: selectTextField,
                          width: width / 2,
                        ),
                        Expanded(
                          child: CustomDropDown(
                              heading: "Unit",
                              items: uomMenu,
                              selected: _selectedUOM,
                              showHeading: true,
                              callBack: selectUOM),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customTextFormField(
                            totalController,
                            "Total",
                            Icon(
                              FontAwesomeIcons.rupeeSign,
                              size: 16,
                            ),
                            enabled: false,
                            inputtype: TextInputType.number,
                            width: width),
                        // Expanded(
                        //   child: customTextFormField(
                        //     totalController,
                        //     "Total",
                        //     null,
                        //     inputtype: TextInputType.number,
                        //     width: width / 2.7,
                        //   ),
                        // ),
                      ],
                    ),

                    // customTextFormField(
                    //     inStockController, "Item In Stock", null,
                    //     inputtype: TextInputType.number,
                    //     width: width,
                    //     suffixText: _selectedUOM!),
                    // customTextFormField(
                    //   descriptionController,
                    //   "Product Description",
                    //   Icon(
                    //     FontAwesomeIcons.info,
                    //     size: 16,
                    //   ),
                    // ),
                    // CustomCheckBox(
                    //   text: "Available On rent !",
                    //   option: isRentable,
                    //   callBack: toggleIsRent,
                    // ),
                    // isRentable!
                    //     ? Row(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           customTextFormField(
                    //               rentController,
                    //               "Rent Amount",
                    //               Icon(
                    //                 FontAwesomeIcons.rupeeSign,
                    //                 size: 16,
                    //               ),
                    //               inputtype: TextInputType.number,
                    //               width: width / 2),
                    //           customTextFormField(
                    //               rentDepositController,
                    //               "Security Deposit",
                    //               Icon(
                    //                 FontAwesomeIcons.rupeeSign,
                    //                 size: 16,
                    //               ),
                    //               inputtype: TextInputType.number,
                    //               width: width / 2),
                    //         ],
                    //       )
                    //     : Container(),
                    InkWell(
                        onTap: () {
                          saveItem();
                          // if (widget.productId == '')
                          //   saveProduct(productImage1, productController.text);
                          // else
                          //   updateProduct(productController.text);
                        },
                        child: customButton(labelText,
                            backgroundColor: Colors.pink)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
