import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/appconstants.dart';
import 'package:penon/controllers/partyController.dart';
import 'package:penon/custom_classes/custom_classes.dart';
import 'package:penon/custom_widgets/widgets.dart';
import 'package:penon/database/database.dart';
import 'package:penon/models/party_model.dart';
import 'package:random_string/random_string.dart';

class AddParty extends StatefulWidget {
  const AddParty({
    Key? key,
  }) : super(key: key);

  @override
  _AddPartyState createState() => _AddPartyState();
}

class _AddPartyState extends State<AddParty> {
  final PartyController partyController = Get.find();
  TextEditingController partyNameController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobController = TextEditingController();
  TextEditingController openingBalanceController =
      TextEditingController(text: '0');

  String? _selectedGST = 'Unregistered';
  String? _selectedState = 'Uttar Pradesh(09)';
  String labelText = 'New Party';
  List<String> gstTypeMenu = AppConstants.gstType;
  List<String> openingBalMenu = AppConstants.openingBalMenu;
  String? _selectedOpening = AppConstants.selectedOpeningType;
  bool isLoading = false;

  List<String> stateMenu = AppConstants.stateMenu;

  DatabaseService databaseService = DatabaseService();

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

  saveParty() async {
    if (_formKey.currentState!.validate()) {
      String pid = randomAlphaNumeric(6);
      if (partyNameController.text.length > 3) {
        pid = partyNameController.text.substring(0, 3) + pid;
      }
      setState(() {
        isLoading = true;
      });
      // salePriceController.text.isEmpty || salePriceController.text == '0'
      //     ? salePriceController.text = priceController.text
      //     : null;

      PartyModel party = PartyModel(
          partyName: partyNameController.text,
          companyId: '8874030006',
          address: addressController.text,
          gstType: _selectedGST,
          gstNo: gstNoController.text,
          pid: pid,
          state: _selectedState,
          email: emailController.text,
          mob1: mobController.text,
          openingBal: double.tryParse(openingBalanceController.text) ?? 0,
          openingType: _selectedOpening);

      await databaseService.addParty(partyDetails: party).then((value) {
        partyController.addPartyToLocal(party);
        return Flushbar(
          title: "Success!!",
          message:
              "Party ${partyNameController.text} has been saved successfully!!",
          duration: const Duration(seconds: 3),
        )..show(context).then((value) {
            Navigator.of(context).pop();
          });
      });

      setState(() {
        isLoading = false;
      });

      // print(profilepic);
    }
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

  void selectGST(String selected) {
    setState(() {
      _selectedGST = selected;
    });
  }

  void selectOpening(String selected) {
    setState(() {
      _selectedOpening = selected;
    });
  }

  void selectState(String selected) {
    setState(() {
      _selectedState = selected;
    });
  }

  @override
  void initState() {
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
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
        child: Scaffold(
          // backgroundColor: Colors.pink.withOpacity(0.7),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.grey[800]),
            title: Text(
              labelText,
              style: TextStyle(color: Colors.grey[900]),
            ),
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
                        partyNameController,
                        "Party Name",
                        const Icon(
                          FontAwesomeIcons.stickyNote,
                          size: 16,
                        ),
                        validationEnabled: true),
                    customTextFormField(
                      addressController,
                      "Complete Address",
                      const Icon(
                        Icons.pin_drop,
                        size: 16,
                      ),
                    ),
                    CustomDropDown(
                        heading: "GST Type",
                        items: gstTypeMenu,
                        selected: _selectedGST,
                        callBack: selectGST),
                    customTextFormField(
                      gstNoController,
                      "GSTIN Number",
                      const Icon(
                        FontAwesomeIcons.info,
                        size: 16,
                      ),
                    ),
                    CustomDropDown(
                        heading: "State",
                        items: stateMenu,
                        selected: _selectedState,
                        callBack: selectState),
                    customTextFormField(
                      mobController,
                      "Mobile Number",
                      const Icon(
                        FontAwesomeIcons.phone,
                        size: 16,
                      ),
                      inputtype: TextInputType.number,
                    ),
                    customTextFormField(
                        emailController,
                        "Email ID",
                        const Icon(
                          Icons.local_post_office_outlined,
                          size: 16,
                        ),
                        inputtype: TextInputType.emailAddress),
                    customTextFormField(
                      openingBalanceController,
                      "Opening Balance",
                      const Icon(
                        FontAwesomeIcons.rupeeSign,
                        size: 16,
                      ),
                    ),
                    CustomDropDown(
                        heading: "Opening Balance Type",
                        items: openingBalMenu,
                        selected: _selectedOpening,
                        callBack: selectOpening),
                    InkWell(
                        onTap: () {
                          saveParty();
                          // if (widget.productId == '')
                          //   saveProduct(productImage1, productController.text);
                          // else
                          //   updateProduct(productController.text);
                        },
                        child: customButton(labelText,
                            backgroundColor: Colors.pink)),
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
