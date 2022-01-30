import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/appconstants.dart';
import 'package:penon/custom_classes/custom_classes.dart';
import 'package:penon/custom_widgets/widgets.dart';
import 'package:penon/database/database.dart';
import 'package:penon/models/company_model.dart';
import 'package:penon/screens/Dashboard/dashboard.dart';

class AddCompany extends StatefulWidget {
  final String? mob;
  const AddCompany({Key? key, this.mob}) : super(key: key);

  @override
  _AddCompanyState createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  // final ProductCategoryController productCategoryController = Get.find();
  TextEditingController companyController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mob1Controller = TextEditingController();
  TextEditingController mob2Controller = TextEditingController();
  TextEditingController gstnoController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController fyController = TextEditingController();

  String? _selectedState = 'Uttar Pradesh(09)';

  String labelText = 'Company Info';
  String selectedGSTType = 'Unregistered';

  List<String> gstTypeMenu = AppConstants.gstType;

  List<String> stateMenu = AppConstants.stateMenu;

  List subCategoryMenu = [""];
  Map<String, dynamic> subCategoryMap = {};
  List<String> sessionMenu = AppConstants.session;
  String selectedSession = '2021-22';

  File? productImage1;
  bool isFeatured = false;
  bool isLoading = false;

  final DatabaseService databaseService = DatabaseService();
  ImagePicker picker = ImagePicker();

  getImage() async {
    await Future.delayed(Duration(milliseconds: 500));
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    // setState(() {
    if (pickedFile != null) {
      File img = File(pickedFile.path);
      return img;
    }
  }

  final _formKey = GlobalKey<FormState>();

  // updateProduct(imgalias) async {
  //   String? imgUrl = netImage;
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       isLoading = true;
  //     });

  //     if (productImage1 != null) {
  //       final storageReference =
  //           FirebaseStorage.instance.ref().child("products/$imgalias");

  //       final uploadTask = storageReference.putFile(productImage1!);
  //       final downloadUrl = await uploadTask.whenComplete(() => null);
  //       imgUrl = await downloadUrl.ref.getDownloadURL();
  //     }

  //     salePriceController.text.isEmpty || salePriceController.text == '0'
  //         ? salePriceController.text = priceController.text
  //         : null;

  //     await databaseService
  //         .updateProduct(
  //             productPic: imgUrl,
  //             productName: productController.text,
  //             price: double.tryParse(priceController.text) ?? 0.0,
  //             salePrice: double.tryParse(salePriceController.text) ?? 0.0,
  //             description: descriptionController.text,
  //             care: _selectedCare,
  //             category: _selectedCategory,
  //             isFeatured: isFeatured,
  //             onrent: isRentable,
  //             rentamt: double.tryParse(rentController.text) ?? 0.0,
  //             rentdeposit: double.tryParse(rentDepositController.text) ?? 0.0,
  //             cod: isCOD,
  //             deliveryCharge:
  //                 double.tryParse(deliveryChargeController.text) ?? 0.0,
  //             replaceable: isReplacable,
  //             pid: widget.productId,
  //             audience: selectedSubCategory,
  //             taxPercent: _selectedGST,
  //             uom: _selectedUOM,
  //             maxSaleQty: int.tryParse(maxOrderController.text) ?? 1,
  //             stock: int.tryParse(maxOrderController.text) ?? 1)
  //         .then((value) {
  //       return AwesomeDialog(
  //           context: context,
  //           animType: AnimType.LEFTSLIDE,
  //           headerAnimationLoop: false,
  //           dialogType: DialogType.SUCCES,
  //           showCloseIcon: true,
  //           title: 'Success!',
  //           desc: 'Product has been updated successfully !',
  //           btnOkOnPress: () {
  //             debugPrint('OnClcik');
  //             Navigator.of(context).pop();
  //           },
  //           btnOkIcon: Icons.check_circle,
  //           onDissmissCallback: (type) {
  //             debugPrint('Dialog Dissmiss from callback $type');
  //           })
  //         ..show();
  //     });
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  saveCompany() async {
    if (_formKey.currentState!.validate()) {
      // String pid = randomAlphaNumeric(6);
      setState(() {
        isLoading = true;
      });

      // if (imgname != null) {
      //   final storageReference =
      //       FirebaseStorage.instance.ref().child("products/$imgalias");

      //   final uploadTask = storageReference.putFile(imgname);
      //   final downloadUrl = await uploadTask.whenComplete(() => null);
      //   imgUrl = await downloadUrl.ref.getDownloadURL();
      // }
      // salePriceController.text.isEmpty || salePriceController.text == '0'
      //     ? salePriceController.text = priceController.text
      //     : null;
      final CompanyModel company = CompanyModel(
          firmName: companyController.text,
          firmAddress: addressController.text,
          state: _selectedState,
          emailID: emailController.text,
          mob1: mob1Controller.text,
          mob2: mob2Controller.text,
          gstType: selectedGSTType,
          gstNo: gstnoController.text,
          website: websiteController.text,
          createdAt: DateTime.now(),
          saleInvoiceCount: 0,
          isDeleted: false,
          permissions: [],
          session: selectedSession);

      await databaseService
          .addCompany(companyDetails: company)
          .then((value) async {
        if (value != null) {
          GetStorage().write('selfcompanyinfo', company.toJson());

          await GetStorage()
              .write(GetStorageConstants.companyId, companyController.text);
          return Flushbar(
            title: "Success!!",
            message: "Company Information has been saved successfully!!",
            duration: const Duration(seconds: 3),
          )..show(context).then((value) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Dashboard()));
            });
        }
      });
    }
    setState(() {
      isLoading = false;
    });

    // print(profilepic);
  }

  // String? selectedSubCategory = '';
  // void selectCategory(String selected) {
  //   setState(() {
  //     _selectedCategory = selected;
  //     loadSubCategory(selected);
  //     // subCategoryMenu =
  //     //     await productCategoryController.subCategoryList[selected];
  //   });
  //   // print(subCategoryMenu);
  // }

  // loadSubCategory(selected) async {
  //   print("before");
  //   print(subCategoryMenu);
  //   subCategoryMenu.clear();
  //   subCategoryMenu = [''];
  //   selectedSubCategory = '';

  //   print(subCategoryMap[selected]);
  //   if (subCategoryMap[selected] != null) {
  //     subCategoryMenu = subCategoryMap[selected];
  //   }

  //   print("list pr");
  //   print(subCategoryMenu);
  // }

  // void selectSubCategory(String selected) {
  //   setState(() {
  //     selectedSubCategory = selected;
  //   });
  // }

  void selectState(String selected) {
    setState(() {
      _selectedState = selected;
    });
  }

  void selectGST(String selected) {
    setState(() {
      selectedGSTType = selected;
    });
  }

  void selectSession(String selected) {
    setState(() {
      selectedSession = selected;
    });
  }

  bool? isRentable = false;
  bool? isCOD = true;
  bool? isReplacable = true;
  bool isDeliveryFree = true;
  double deliveryCharge = 0;
  // late ProductModel pro;

  @override
  void initState() {
    mob1Controller.text = widget.mob ?? "8874030006";
    // subCategoryMap = productCategoryController.subCategoryList;
    // print(subCategoryMap);
    // subCategoryMap.forEach((k, v) {
    //   v.forEach((ele) {
    //     subCategoryMenu.add(ele);
    //   });
    // });
    // loadProduct();

    // TODO: implement initState
    super.initState();
  }

  // loadProduct() async {
  //   if (widget.productId != '') {
  //     labelText = 'Update Product';
  //     await databaseService.getInfo('Products', widget.productId).then((value) {
  //       pro = ProductModel.fromJson(value.data() as Map<String, dynamic>);
  //       print(pro.name);
  //       productController.text = pro.name!;
  //       priceController.text = pro.price.toString();
  //       salePriceController.text = pro.saleprice.toString();
  //       print("printing uom");
  //       print(pro.uom);
  //       setState(() {
  //         _selectedGST = pro.taxPercent;
  //         _selectedUOM = pro.uom ?? "Pcs";
  //         maxOrderController.text =
  //             pro.maxSaleQty == null ? "2" : pro.maxSaleQty.toString();
  //         inStockController.text =
  //             pro.stock == null ? "2" : pro.stock.toString();
  //         descriptionController.text = pro.desc!;
  //         _selectedCare = pro.careInstructions ?? "";
  //         _selectedCategory = pro.category ?? "";
  //         selectedSubCategory = pro.selectedAudience ?? "";
  //         isFeatured = pro.isFeatured!;
  //         isRentable = pro.onRent;
  //         rentController.text =
  //             pro.rentAmount == null ? "" : pro.rentAmount.toString();
  //         rentDepositController.text =
  //             pro.rentDeposit == null ? "" : pro.rentDeposit.toString();
  //         isCOD = pro.cod;
  //         deliveryChargeController.text = pro.deliveryCharge.toString();
  //         deliveryChargeController.text == '0' ||
  //                 deliveryChargeController.text == '0.0'
  //             ? isDeliveryFree = true
  //             : isDeliveryFree = false;
  //         isReplacable = pro.isReplacable;
  //         netImage = pro.productpic;
  //         print(pro.selectedAudience);

  //         isLoading = false;
  //       });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.5)),
        child: Scaffold(
          // backgroundColor: Colors.pink.withOpacity(0.7),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(labelText),
            elevation: 0,
          ),
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    customTextFormField(
                        companyController,
                        "Firm Name",
                        Icon(
                          Icons.shop,
                          size: 16,
                        ),
                        validationEnabled: true),
                    customTextFormField(
                        addressController,
                        "Firm Address",
                        Icon(
                          Icons.local_post_office,
                          size: 16,
                        ),
                        validationEnabled: true),
                    CustomDropDown(
                        heading: "State",
                        items: stateMenu,
                        selected: _selectedState,
                        callBack: selectState),
                    customTextFormField(
                        emailController,
                        "Email ID",
                        Icon(
                          FontAwesomeIcons.addressCard,
                          size: 16,
                        ),
                        inputtype: TextInputType.emailAddress),
                    customTextFormField(
                        mob1Controller,
                        "Mobile Number 1",
                        Icon(
                          FontAwesomeIcons.phone,
                          size: 16,
                        ),
                        enabled: false,
                        inputtype: TextInputType.phone),
                    customTextFormField(
                        mob2Controller,
                        "Mobile Number 2",
                        Icon(
                          FontAwesomeIcons.phone,
                          size: 16,
                        ),
                        inputtype: TextInputType.phone),
                    CustomDropDown(
                        heading: "GST Type",
                        items: gstTypeMenu,
                        selected: selectedGSTType,
                        callBack: selectGST),
                    customTextFormField(
                      gstnoController,
                      "GST Number",
                      Icon(
                        Icons.format_list_numbered,
                        size: 16,
                      ),
                    ),
                    customTextFormField(
                      websiteController,
                      "Website",
                      Icon(
                        FontAwesomeIcons.weebly,
                        size: 16,
                      ),
                    ),
                    CustomDropDown(
                        heading: "Session",
                        items: sessionMenu,
                        selected: selectedSession,
                        callBack: selectSession),
                    InkWell(
                        onTap: () {
                          saveCompany();
                          // if (widget.productId == '')
                          //   saveProduct(productImage1, productController.text);
                          // else
                          //   updateProduct(productController.text);
                        },
                        child: customButton("Save")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
