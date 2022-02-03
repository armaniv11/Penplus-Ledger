import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/appconstants.dart';
import 'package:penon/controllers/itemController.dart';
import 'package:penon/custom_classes/custom_classes.dart';
import 'package:penon/custom_widgets/widgets.dart';
import 'package:penon/database/database.dart';
import 'package:penon/models/item_model.dart';
import 'package:random_string/random_string.dart';

class AddProduct extends StatefulWidget {
  final String? productId;
  const AddProduct({Key? key, this.productId = ''}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ItemController itemController = Get.find();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController hsnController = TextEditingController();
  TextEditingController sellPriceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController rentDepositController = TextEditingController();
  TextEditingController inStockController = TextEditingController(text: "0");

  // String? _selectedCategory = AppConstants.categoryMisc;
  String? _selectedCare = '';
  String? _selectedGST = '0';
  String? _selectedUOM = "Pcs";
  String labelText = 'Add Item';
  String? netImage = '';

  // List<String> categoryMenu = AppConstants.categoryListString;

  List<String> careMenu = [
    '',
    'Do not dry clean',
    'Dry clean only',
    'Do not bleach',
    'Hand wash',
    'Wash cold',
    'Wash warm'
  ];

  List<String> uomMenu = [
    'Add New',
    'Pcs',
    'Kg',
    'Dozen',
    'Pound',
  ];

  List<String> gstMenu = AppConstants.gstMenu;

  List subCategoryMenu = [""];
  Map<String, dynamic> subCategoryMap = {};

  File? productImage1;
  bool gstInSP = false;
  bool isLoading = false;

  DatabaseService databaseService = DatabaseService();
  ImagePicker picker = ImagePicker();

  getImage() async {
    await Future.delayed(const Duration(milliseconds: 500));
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

  saveItem() async {
    if (_formKey.currentState!.validate()) {
      String pid = randomAlphaNumeric(6);
      if (itemNameController.text.length > 3) {
        pid = itemNameController.text.substring(0, 3) + pid;
      }
      setState(() {
        isLoading = true;
      });
      // salePriceController.text.isEmpty || salePriceController.text == '0'
      //     ? salePriceController.text = priceController.text
      //     : null;
      ItemModel item = ItemModel(
          itemName: itemNameController.text,
          itemHSN: hsnController.text,
          gst: int.tryParse(_selectedGST!),
          itemId: pid,
          gstInSP: gstInSP,
          purchasePrice: double.tryParse(purchasePriceController.text),
          sellPrice: double.tryParse(sellPriceController.text),
          uom: _selectedUOM,
          inStock: double.tryParse(inStockController.text),
          itemDesc: descriptionController.text,
          onRent: isRentable,
          rentAmt: double.tryParse(rentController.text),
          securityAmt: double.tryParse(rentDepositController.text),
          companyId: GetStorageConstants.companyId,
          createdAt: DateTime.now());

      await databaseService.addItem(itemDetails: item).then((value) {
        itemController.addItemToLocal(item);
        return Flushbar(
          title: "Success!!",
          message:
              "Item ${itemNameController.text} has been saved successfully!!",
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

  //   print("list pr");
  //   print(subCategoryMenu);
  // }

  void selectCare(String selected) {
    setState(() {
      _selectedCare = selected;
    });
  }

  void selectUOM(String selected) {
    setState(() {
      if (selected == 'Add New') {}
      _selectedUOM = selected;
    });
  }

  // void selectSubCategory(String selected) {
  //   setState(() {
  //     selectedSubCategory = selected;
  //   });
  // }

  void selectGST(String selected) {
    setState(() {
      _selectedGST = selected;
    });
  }

  void toggleGSTInSP(bool feat) {
    setState(() {
      gstInSP = feat;
    });
  }

  void toggleIsRent(bool feat) {
    setState(() {
      isRentable = feat;
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
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.8),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey[800]),
          backgroundColor: Colors.transparent,
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
                      itemNameController,
                      "Item Name",
                      const Icon(
                        FontAwesomeIcons.stickyNote,
                        size: 16,
                      ),
                      validationEnabled: true),
                  customTextFormField(
                    hsnController,
                    "Item HSN",
                    const Icon(
                      FontAwesomeIcons.gripVertical,
                      size: 16,
                    ),
                  ),
                  CustomDropDown(
                      heading: "GST Slab (in %)",
                      items: gstMenu,
                      selected: _selectedGST,
                      callBack: selectGST),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customTextFormField(
                          purchasePriceController,
                          "Purchase Price",
                          const Icon(
                            FontAwesomeIcons.rupeeSign,
                            size: 16,
                          ),
                          inputtype: TextInputType.number,
                          width: width / 2,
                          validationEnabled: true),
                      customTextFormField(
                        sellPriceController,
                        "Sell Price",
                        const Icon(
                          FontAwesomeIcons.rupeeSign,
                          size: 16,
                        ),
                        inputtype: TextInputType.number,
                        width: width / 2,
                      ),
                    ],
                  ),
                  CustomCheckBox(
                    text: "GST Included in Sell Price",
                    option: gstInSP,
                    callBack: toggleGSTInSP,
                  ),
                  CustomDropDown(
                      heading: "Product Unit of Measurement",
                      items: uomMenu,
                      selected: _selectedUOM,
                      callBack: selectUOM),
                  customTextFormField(inStockController, "Item In Stock", null,
                      inputtype: TextInputType.number,
                      width: width,
                      suffixText: _selectedUOM!),
                  customTextFormField(
                    descriptionController,
                    "Product Description",
                    const Icon(
                      FontAwesomeIcons.info,
                      size: 16,
                    ),
                  ),
                  CustomCheckBox(
                    text: "Available On rent !",
                    option: isRentable,
                    callBack: toggleIsRent,
                  ),
                  isRentable!
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTextFormField(
                                rentController,
                                "Rent Amount",
                                const Icon(
                                  FontAwesomeIcons.rupeeSign,
                                  size: 16,
                                ),
                                inputtype: TextInputType.number,
                                width: width / 2),
                            customTextFormField(
                                rentDepositController,
                                "Security Deposit",
                                const Icon(
                                  FontAwesomeIcons.rupeeSign,
                                  size: 16,
                                ),
                                inputtype: TextInputType.number,
                                width: width / 2),
                          ],
                        )
                      : Container(),
                  InkWell(
                      onTap: () {
                        saveItem();
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
    );
  }
}
