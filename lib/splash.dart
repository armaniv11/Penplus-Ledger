import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:penon/appconstants.dart';
import 'package:penon/screens/Dashboard/dashboard.dart';
import 'package:penon/screens/auth/register_page_phone.dart';
import 'package:shimmer/shimmer.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<bool> _checklogin() async {
    // await HelperFunctions.getUsernamePassword().then((value) async {
    //   if (value['username'] != null) await makePostRequest(value);
    // });
    await Future.delayed(const Duration(milliseconds: 5000), () {});
    return true;
  }

  // checkInfo() async {
  //   await HelperFunctions.getUsernamePassword().then((value) async {
  //     if (value['username'] != null) {
  //       await makePostRequest(value);
  //     } else {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => SignInPage()));
  //     }
  //   });
  // }

  // makePostRequest(Map details) async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   var url2 =
  //       Uri.parse("https://pearinnovation.com/cloudAsset/Admin/userLogin");
  //   final headers = {
  //     "Content-type": "application/json",
  //     "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
  //   };
  //   // var client = http.Client();

  //   final jsond = {
  //     "username": details['username'],
  //     "DeviceId": 1234557,
  //     "password": details['password']
  //   };
  //   var uriResponse =
  //       await http.post(url2, body: json.encode(jsond), headers: headers);
  //   if (uriResponse.statusCode == 200) {
  //     print(uriResponse.body);
  //     print(uriResponse.statusCode);
  //     var responseBody = json.decode(uriResponse.body);

  //     if (responseBody['success'] == null) {
  //       print("if part");
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => SignInPage()));
  //     } else {
  //       if (responseBody['success']['deleteFlag'] == "1") {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => SignInPage()));
  //       } else {
  //         Navigator.pushReplacement(
  //             context, MaterialPageRoute(builder: (context) => Home()));
  //       }

  //       print(responseBody);
  //       print(responseBody['success']);
  //       // print(responseBody['success']['customerId']);
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    //getData();
    _checklogin().then((value) {
      checkUserLoggedInStatus();
      // checkInfo();
    });
    // _checklogin().then((status) {
    //   // checkblocked();
    //   //loadName();
    //   checkUserLoggedInStatus();
    // });
  }

  // String name;

  bool blocked = false;
  bool isLoggedIn = false;
  final box = GetStorage();
  checkUserLoggedInStatus() async {
    if (box.read('isloggedin') == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Dashboard()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => RegisterPagePhone()));
    }
  }

  //String name;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 242, 236, 1),
      body: Column(
        children: [
          Container(
            height: size.height / 2,
            width: double.maxFinite,
            color: const Color.fromRGBO(243, 242, 236, 1),
            child: Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.white,
                child: Text(
                  AppConstants.appName,
                  style: GoogleFonts.actor(
                      color: Colors.grey,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
              ),
            ),
          ),
          Container(
            height: size.height / 2,
            // color: Colors.white,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/splash.jpg',
                    ),
                    fit: BoxFit.fill)),
            //height: MediaQuery.of(context).size.height,
          ),
        ],
      ),
    );
  }
}
