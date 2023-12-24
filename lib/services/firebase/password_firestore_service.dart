import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_vault/app/app.locator.dart';
import 'package:password_vault/app/app.logger.dart';
import 'package:password_vault/model/password.model.dart';
import 'package:password_vault/services/firebase/user_firestore_service.dart';

class PasswordFirestoreService {
  final logger = getLogger('FirestoreService');
  static FirebaseFirestore? _firestore;
  static PasswordFirestoreService? _instance;
  static CollectionReference? _passwordCollection;

  final UserFirestoreService _userFirestoreService =
      locator<UserFirestoreService>();

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

  Future<List<PasswordModel>> fetchMyPasswords() async {
    List<PasswordModel> myStoredPasswords = List.empty(growable: true);
    QuerySnapshot querySnapshot = await _passwordCollection!
        .where("authorId", isEqualTo: _userFirestoreService.currentUser!.id)
        .get();
    List<QueryDocumentSnapshot> queryDocs = querySnapshot.docs;
    for (var element in queryDocs) {
      myStoredPasswords
          .add(PasswordModel.fromJson(element.data() as Map<String, dynamic>));
    }
    return myStoredPasswords;
  }

  Future<void> deletePassword(String docId) async {
    await _passwordCollection!.doc(docId).delete();
  }
}
