import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penon/database/database.dart';
import 'package:penon/screens/Dashboard/dashboard.dart';
import 'package:penon/screens/admin/company_info.dart';

class ConfirmOtpPage extends StatefulWidget {
  final String? phoneNo;
  ConfirmOtpPage({required this.phoneNo});
  @override
  _ConfirmOtpPageState createState() => _ConfirmOtpPageState();
}

class _ConfirmOtpPageState extends State<ConfirmOtpPage> {
  // TextEditingController otp1 = TextEditingController(text: '1');
  // TextEditingController otp2 = TextEditingController(text: '2');
  // TextEditingController otp3 = TextEditingController(text: '3');
  // TextEditingController otp4 = TextEditingController(text: '4');
  // TextEditingController otp5 = TextEditingController(text: '5');
  Color accentPurpleColor = const Color(0xFF6A53A1);
  Color primaryColor = Color(0xFF121212);
  Color accentPinkColor = Color(0xFFF99BBD);
  Color accentDarkGreenColor = Color(0xFF115C49);
  Color accentYellowColor = Color(0xFFFFB612);
  Color accentOrangeColor = Color(0xFFEA7A3B);
  late List<TextStyle> otpTextStyles;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String verificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;

  String smscode = "";
  bool isLoading = false;

  TextStyle createStyle(Color color) {
    ThemeData theme = Theme.of(context);
    return theme.textTheme.headline3!.copyWith(color: color);
  }

  Future<void> verifyPhone(phoneNo) async {
    setState(() {
      isLoading = true;
    });
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (phoneAuthCredential) async {
          setState(() {
            isLoading = false;
          });
        },
        verificationFailed: (verificationFailed) {
          setState(() {
            isLoading = false;
          });
          print("failed");
        },
        codeSent: (verificationId, resendingToken) async {
          setState(() {
            isLoading = false;
            this.verificationId = verificationId;
            print(verificationId);
          });
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  DatabaseService databaseService = DatabaseService();

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      isLoading = true;
    });
    print(widget.phoneNo);

    final dynamic authCredential = await _auth
        .signInWithCredential(phoneAuthCredential)
        .then((value) async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User user = _auth.currentUser!;
      print(user.uid);
      print("checking");
      GetStorage().write('isLoggedIn', true);
      GetStorage().write('userid', user.uid);
      GetStorage().write('mob', widget.phoneNo);

      // await databaseService.createProfile(widget.phoneNo).then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AddCompany(
                    mob: widget.phoneNo,
                  )));
      // });

      // HelperFunctions.saveUserLoggedInStatus(
      //     isLoggedIn: true, userid: user.uid);
    });

    setState(() {
      isLoading = false;
    });
    print("verifying");
  }

  String? phone;
  @override
  void initState() {
    print("phone no");
    print(widget.phoneNo);
    verifyPhone('+91${widget.phoneNo}');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    otpTextStyles = [
      createStyle(accentPurpleColor),
      createStyle(accentYellowColor),
      createStyle(accentDarkGreenColor),
      createStyle(accentOrangeColor),
      createStyle(accentPinkColor),
      createStyle(accentPurpleColor),
    ];
    Widget title = Center(
        child: Text(
      'Confirm your OTP',
      style: TextStyle(
          color: Colors.white,
          fontSize: 26.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    ));

    // Widget subTitle = Padding(
    //     padding: const EdgeInsets.only(right: 56.0),
    //     child: Text(
    //       'Please wait, we are confirming your OTP',
    //       style: TextStyle(
    //         color: Colors.white,
    //         fontSize: 16.0,
    //       ),
    //     ));

    Widget verifyButton = Center(
      child: InkWell(
        onTap: () {
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: smscode);
          signInWithPhoneAuthCredential(phoneAuthCredential);
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (_) => IntroPage()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 60,
          child: Center(
              child: Text("Verify",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.orange[600]!,
                    Colors.orange,
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget resendText = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Resend again after ",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Color.fromRGBO(255, 255, 255, 0.5),
            fontSize: 14.0,
          ),
        ),
        InkWell(
          onTap: () {},
          child: Text(
            '0:39',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  end: Alignment.topRight,
                  begin: Alignment.bottomLeft,
                  colors: [
                Colors.blue[800]!.withOpacity(0.5),
                Colors.blue[400]!.withOpacity(0.5)
              ])),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.pinkAccent,
                  ))
                : Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(flex: 3),
                            title,
                            Spacer(),
                            // subTitle,
                            Spacer(flex: 1),

                            OtpTextField(
                              numberOfFields: 6,
                              borderColor: accentPurpleColor,
                              focusedBorderColor: accentPurpleColor,
                              styles: otpTextStyles,
                              showFieldAsBox: false,
                              borderWidth: 4.0,
                              //runs when a code is typed in
                              onCodeChanged: (String code) {
                                print(code);
                                //handle validation or checks here if necessary
                              },
                              //runs when every textfield is filled
                              onSubmit: (String verificationCode) {
                                print(verificationCode);
                                smscode = verificationCode;
                                print("smscode is : $smscode");
                              },
                            ),
                            Spacer(flex: 1),
//                      otpCode,
                            Padding(
                              padding: const EdgeInsets.only(right: 28.0),
                              child: verifyButton,
                            ),
                            Spacer(flex: 2),
                            resendText,
                            Spacer()
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
