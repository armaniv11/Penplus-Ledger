import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/controllers/partyController.dart';
import 'package:penon/database/database.dart';
import 'package:penon/models/ledger_model.dart';
import 'package:penon/models/sale_model.dart';
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
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[800]!, Colors.grey[800]!]),
      ),
      child: Scaffold(
        // backgroundColor: Colors.pink.withOpacity(0.7),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Ledger"),
          elevation: 0,
        ),
        body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: ListView.builder(
                itemCount: ledger.length,
                itemBuilder: (BuildContext context, index) {
                  return LedgerList(
                    invoice: ledger[index],
                    index: index + 1,
                  );
                })),
      ),
    );
  }
}
