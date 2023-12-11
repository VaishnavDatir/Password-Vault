import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_vault/app/app.locator.dart';
import 'package:password_vault/app/app.logger.dart';
import 'package:password_vault/core/util/string_handler.dart';
import 'package:password_vault/model/password.model.dart';

class PasswordFirestoreService {
  final logger = getLogger('FirestoreService');
  static FirebaseFirestore? _firestore;
  static PasswordFirestoreService? _instance;
  static CollectionReference? _passwordCollection;

  final StringHandler _stringHandler = locator<StringHandler>();

  Future<PasswordFirestoreService> init() async {
    if (_instance == null) {
      _firestore = FirebaseFirestore.instance;
      _passwordCollection = _firestore!.collection("passwords");
      _instance = PasswordFirestoreService();
    }
    return Future.value(_instance);
  }

  Future<DocumentReference<Object?>> addNewPassword(
      PasswordModel passwordModel) async {
    return await _passwordCollection!.add(passwordModel.toJson());
  }

  Future<void> updatePassword(PasswordModel passwordModel) async {
    return await _passwordCollection
        ?.doc(passwordModel.id)
        .update(passwordModel.toJson());
  }
}
