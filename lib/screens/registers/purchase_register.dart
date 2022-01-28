import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/appconstants.dart';
import 'package:penon/controllers/partyController.dart';
import 'package:penon/custom_classes/custom_classes.dart';
import 'package:penon/custom_widgets/widgets.dart';
import 'package:penon/database/database.dart';
import 'package:penon/models/item_model.dart';
import 'package:penon/models/party_model.dart';
import 'package:penon/models/purchase_model.dart';
import 'package:penon/screens/registers/components/listview_register.dart';
import 'package:random_string/random_string.dart';

class PurchaseRegister extends StatefulWidget {
  const PurchaseRegister({
    Key? key,
  }) : super(key: key);

  @override
  _PurchaseRegisterState createState() => _PurchaseRegisterState();
}

class _PurchaseRegisterState extends State<PurchaseRegister> {
  final PartyController partyController = Get.find();
  // TextEditingController partyNameController = TextEditingController();
  // TextEditingController gstNoController = TextEditingController();
  // TextEditingController addressController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController mobController = TextEditingController();
  // TextEditingController openingBalanceController =
  //     TextEditingController(text: '0');

  bool isLoading = true;

  DatabaseService databaseService = DatabaseService();

  final _formKey = GlobalKey<FormState>();
  List<PurchaseModel> purchaseRegister = [];

  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
  }

  loadData() async {
    databaseService.loadPurchaseRegister().then((value) {
      purchaseRegister = value;
      purchaseRegister.forEach((element) {
        print(element.invoiceNo);
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey,
              Colors.blue[800]!,
              Colors.blue[800]!,
              Colors.grey[500]!
            ]),
      ),
      child: Scaffold(
        // backgroundColor: Colors.pink.withOpacity(0.7),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Purchase Register"),
          elevation: 0,
        ),
        body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: ListView.builder(
                itemCount: purchaseRegister.length,
                itemBuilder: (BuildContext context, index) {
                  return RegisterList(
                    invoice: purchaseRegister[index],
                    index: index + 1,
                  );
                })),
      ),
    );
  }
}