import 'package:flutter/material.dart';
import 'package:penon/screens/admin/add_party.dart';
import 'package:penon/screens/admin/add_product.dart';
import 'package:penon/screens/admin/add_purchase.dart';
import 'package:penon/screens/admin/company_info.dart';

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
              child: Text("New Purchase"))
        ],
      ),
    );
  }
}
