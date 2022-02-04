import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/appconstants.dart';
import 'package:penon/controllers/itemController.dart';
import 'package:penon/controllers/partyController.dart';
import 'package:penon/custom_classes/custom_classes.dart';
import 'package:penon/custom_functions/custom_functions.dart';
import 'package:penon/custom_widgets/widgets.dart';
import 'package:penon/database/database.dart';
import 'package:penon/models/item_model.dart';
import 'package:penon/models/ledger_model.dart';
import 'package:penon/models/party_model.dart';
import 'package:penon/models/pay_receive_model.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({Key? key}) : super(key: key);

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final PartyController partyController = Get.find();
  TextEditingController amountController = TextEditingController();
  TextEditingController narrationController = TextEditingController();
  TextEditingController selectedPartyController = TextEditingController();
  TextEditingController pidController = TextEditingController();

  String _paymentType = "Cash";
  String labelText = 'New payment';
  String? netImage = '';

  List<String> paymentMenu = AppConstants.paymentMenu;

  List<String> gstMenu = AppConstants.gstMenu;
  bool isLoading = false;

  DatabaseService databaseService = DatabaseService();

  final _formKey = GlobalKey<FormState>();
  late String _selectedParty;
  late PartyModel selectedPartyModel;
  var db = FirebaseFirestore.instance;

  save() async {
    var batch = db.batch();
    if (_formKey.currentState!.validate()) {
      String pid = randomAlphaNumeric(8);
      String ledgerCreditID = randomAlphaNumeric(10);

      setState(() {
        isLoading = true;
      });
      // salePriceController.text.isEmpty || salePriceController.text == '0'
      //     ? salePriceController.text = priceController.text
      //     : null;
      PayReceiveModel payReceive = PayReceiveModel(
          payRecId: pid,
          partyId: selectedPartyModel,
          creditAmount: double.tryParse(amountController.text)!,
          debitAmount: 0,
          transactionType: 'Payment',
          narration: narrationController.text,
          paymentNo: pidController.text,
          paymentDate: DateTime.parse(selectedPaymentDate),
          companyId: '8874030006',
          createdAt: DateTime.now());
      print(payReceive.paymentNo);

      LedgerModel ledgerCredit = LedgerModel(
          ledgerId: ledgerCreditID,
          partyId: selectedPartyModel,
          creditAmount: double.tryParse(amountController.text)!,
          debitAmount: 0,
          transactionType: 'Payment',
          invoiceId: pid,
          companyId: '8874030006',
          invoiceNo: pidController.text,
          createdAt: DateTime.now(),
          invoiceDate: DateTime.parse(selectedPaymentDate));
      batch.set(db.collection('Payment').doc(pid), payReceive.toJson());
      batch.set(
          db.collection('Ledger').doc(ledgerCreditID), ledgerCredit.toJson());
      batch.commit().then((value) {
        return Flushbar(
          title: "Success!!",
          message: "Payment has been saved successfully!!",
          duration: const Duration(seconds: 3),
        )..show(context).then((value) {
            Navigator.of(context).pop();
          });
      });
    }
  }

  late String selectedPaymentDate;
  void selectPaymentDate(String selected) {
    selectedPaymentDate = selected;
  }

  void selectPaymentType(String selected) {
    setState(() {
      _paymentType = selected;
    });
  }

  void toggleIsRent(bool feat) {
    setState(() {
      isRentable = feat;
    });
  }

  bool? isRentable = false;
  List<PartyModel> partyModelMenu = [];

  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
  }

  Future loadData() async {
    partyModelMenu = partyController.allParties.map((e) => e).toList();
    selectedPaymentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.8),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey[800]),
          backgroundColor: Colors.transparent,
          title: Text(
            labelText,
            style: TextStyle(color: Colors.grey[900]),
          ),
          elevation: 0,
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
                      pidController,
                      "Ref. No",
                      const Icon(
                        FontAwesomeIcons.rupeeSign,
                        size: 16,
                      ),
                      validationEnabled: true),
                  CustomDateField(
                    initialDate: selectedPaymentDate,
                    heading: "Payment Date",
                    callBack: selectPaymentDate,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 4, right: 4, top: 6, bottom: 6),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              child: Text(
                                "Party",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[800]),
                              ),
                              // ignore: prefer_const_constructors
                            ),
                            const SizedBox(
                                height: 20,
                                child: VerticalDivider(
                                  color: Colors.blue,
                                  thickness: 2,
                                )),
                            Expanded(
                              child: TypeAheadField(
                                debounceDuration:
                                    const Duration(milliseconds: 500),
                                textFieldConfiguration: TextFieldConfiguration(
                                    controller: selectedPartyController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    autofocus: false,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: InputBorder.none,
                                    )),
                                suggestionsCallback: (party) async {
                                  List<PartyModel> asd = await searchParty(
                                      partyController.allParties, party);

                                  return asd;
                                },
                                itemBuilder: (context, PartyModel party) {
                                  return ListTile(
                                    tileColor: Colors.white,
                                    // leading: Icon(Icons.shopping_cart),
                                    title: Text(party.partyName!),
                                    // subtitle: Text('\$${suggestion['price']}'),
                                  );
                                },
                                onSuggestionSelected: (PartyModel party) {
                                  selectedPartyController.text =
                                      party.partyName!;
                                  _selectedParty = party.partyName!;
                                  selectedPartyModel = party;
                                },
                              ),
                            ),
                            selectedPartyController.text.isEmpty
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: InkWell(
                                        onTap: () =>
                                            selectedPartyController.clear(),
                                        child: const Icon(Icons.clear)),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                  customTextFormField(
                      amountController,
                      "Pay Amount",
                      const Icon(
                        FontAwesomeIcons.rupeeSign,
                        size: 16,
                      ),
                      validationEnabled: true),
                  CustomDropDown(
                      heading: "Payment Type",
                      items: paymentMenu,
                      selected: _paymentType,
                      callBack: selectPaymentType),
                  customTextFormField(
                      narrationController,
                      "Narration",
                      const Icon(
                        FontAwesomeIcons.rupeeSign,
                        size: 16,
                      ),
                      maxlines: 4),
                  InkWell(
                      onTap: () async {
                        await save();
                        // saveItem();
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
    );
  }
}
