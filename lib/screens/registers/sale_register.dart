import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:penon/controllers/partyController.dart';

import 'package:penon/database/database.dart';
import 'package:penon/models/purchase_model.dart';
import 'package:penon/models/sale_model.dart';
import 'package:penon/screens/registers/components/listview_register.dart';
import 'package:random_string/random_string.dart';

class SaleRegister extends StatefulWidget {
  const SaleRegister({
    Key? key,
  }) : super(key: key);

  @override
  _SaleRegisterState createState() => _SaleRegisterState();
}

class _SaleRegisterState extends State<SaleRegister> {
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
  List<SaleModel> SaleRegister = [];

  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
  }

  loadData() async {
    databaseService.loadSaleRegister().then((value) {
      SaleRegister = value;
      SaleRegister.forEach((element) {
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
            colors: [Colors.blue[800]!, Colors.grey[800]!]),
      ),
      child: Scaffold(
        // backgroundColor: Colors.pink.withOpacity(0.7),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Sale Register"),
          elevation: 0,
        ),
        body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: ListView.builder(
                itemCount: SaleRegister.length,
                itemBuilder: (BuildContext context, index) {
                  return RegisterList(
                    invoice: SaleRegister[index],
                    index: index + 1,
                  );
                })),
      ),
    );
  }
}
