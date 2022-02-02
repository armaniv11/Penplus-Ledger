import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/appconstants.dart';
import 'package:penon/controllers/partyController.dart';
import 'package:penon/database/database.dart';
import 'package:penon/models/ledger_model.dart';
import 'package:penon/screens/registers/components/listview_ledger.dart';
import 'package:penon/screens/registers/components/listview_register.dart';

class Ledger extends StatefulWidget {
  const Ledger({
    Key? key,
  }) : super(key: key);

  @override
  _LedgerState createState() => _LedgerState();
}

class _LedgerState extends State<Ledger> {
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
  List<LedgerModel> ledger = <LedgerModel>[];

  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
  }

  loadData() async {
    databaseService.loadLedger().then((value) {
      ledger = value;
      ledger.forEach((element) {
        print(element.invoiceId);
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
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.blue[200]!.withOpacity(0.3),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // iconTheme: IconThemeData(color: Colors.black),
          title: const Text(
            "Ledger",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          actions: [Icon(Icons.password)],
        ),
        body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Column(
              children: [
                Container(
                  height: size.height * 0.07,
                  color: Colors.lightBlue[100],
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Container(
                          width: size.width * 0.46,
                          child: Text(
                            "Party",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Container(
                          width: size.width * 0.24,
                          child: Text(
                            "Credit",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Container(
                          width: size.width * 0.24,
                          child: Text(
                            "Debit",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: size.height * 0.9,
                    child: ListView.builder(
                        itemCount: ledger.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, index) {
                          return LedgerList(
                            invoice: ledger[index],
                            index: index + 1,
                          );
                        }),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
