import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/controllers/partyController.dart';
import 'package:penon/database/database.dart';
import 'package:penon/models/invoice_model.dart';
import 'package:penon/screens/registers/components/listview_register.dart';

class PurchaseRegister extends StatefulWidget {
  const PurchaseRegister({
    Key? key,
  }) : super(key: key);

  @override
  _PurchaseRegisterState createState() => _PurchaseRegisterState();
}

class _PurchaseRegisterState extends State<PurchaseRegister> {
  final PartyController partyController = Get.find();
  bool isLoading = true;

  DatabaseService databaseService = DatabaseService();

  final _formKey = GlobalKey<FormState>();
  List<InvoiceModel> purchaseRegister = [];

  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
  }

  loadData() async {
    databaseService.loadRegister('Purchase').then((value) {
      purchaseRegister = value;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.blue[200]!.withOpacity(0.4),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          title: const Text(
            "Purchase Register",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
        ),
        body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: ListView.builder(
                  itemCount: purchaseRegister.length,
                  itemBuilder: (BuildContext context, index) {
                    return RegisterList(
                      invoice: purchaseRegister[index],
                      index: index + 1,
                    );
                  }),
            )),
      ),
    );
  }
}
