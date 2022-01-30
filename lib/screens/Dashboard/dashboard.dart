import 'package:flutter/material.dart';
import 'package:penon/screens/admin/add_party.dart';
import 'package:penon/screens/admin/add_product.dart';
import 'package:penon/screens/admin/add_purchase.dart';
import 'package:penon/screens/admin/add_sale.dart';
import 'package:penon/screens/admin/company_info.dart';
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProduct()));
              },
              child: Text("Add Product")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddCompany()));
              },
              child: Text("Company Info")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddParty()));
              },
              child: Text("Add Party")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddPurchase()));
              },
              child: Text("New Purchase")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PurchaseRegister()));
              },
              child: Text("Purchase Register")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddSale()));
              },
              child: Text("New Sale")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SaleRegister()));
              },
              child: Text("Sale Register")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Ledger()));
              },
              child: Text("Ledger"))
        ],
      ),
    );
  }
}
