import 'package:flutter/material.dart';
import 'package:penon/screens/admin/add_party.dart';
import 'package:penon/screens/admin/add_product.dart';
import 'package:penon/screens/admin/add_purchase.dart';
import 'package:penon/screens/admin/add_sale.dart';
import 'package:penon/screens/admin/company_info.dart';
import 'package:penon/screens/employee/add_payment.dart';
import 'package:penon/screens/registers/ledger.dart';
import 'package:penon/screens/registers/purchase_register.dart';
import 'package:penon/screens/registers/sale_register.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: ListView(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddProduct()));
              },
              child: const Text("Add Product")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddCompany()));
              },
              child: const Text("Company Info")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddParty()));
              },
              child: const Text("Add Party")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPurchase()));
              },
              child: const Text("New Purchase")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PurchaseRegister()));
              },
              child: const Text("Purchase Register")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddSale()));
              },
              child: const Text("New Sale")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SaleRegister()));
              },
              child: const Text("Sale Register")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Ledger()));
              },
              child: const Text("Ledger")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddPayment()));
              },
              child: const Text("Make Payment"))
        ],
      ),
    );
  }
}
