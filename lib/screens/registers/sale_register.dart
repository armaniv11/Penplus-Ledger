import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/controllers/partyController.dart';
import 'package:penon/database/database.dart';
import 'package:penon/models/invoice_model.dart';
import 'package:penon/screens/registers/components/listview_register.dart';

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
  List<InvoiceModel> SaleRegister = [];

  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
  }

  loadData() async {
    databaseService.loadRegister('Sale').then((value) {
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
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.blue[200]!.withOpacity(0.4),
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
