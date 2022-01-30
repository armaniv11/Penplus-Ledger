import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:penon/models/company_model.dart';

class SharedFunctions {
  final box = GetStorage();
  Future<CompanyModel> getCompany() async {
    return CompanyModel.fromDoc(await FirebaseFirestore.instance
        .collection('Company')
        .doc(box.read('mob'))
        .get());
  }
}
