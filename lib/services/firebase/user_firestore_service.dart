import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password_vault/app/app.logger.dart';
import 'package:password_vault/model/user.model.dart';

class UserFirestoreService {
  final logger = getLogger('FirestoreService');
  static FirebaseFirestore? _firestore;
  static UserFirestoreService? _instance;
  static CollectionReference? _userCollection;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  Future<UserFirestoreService> init() async {
    if (_instance == null) {
      _firestore = FirebaseFirestore.instance;
      _userCollection = _firestore!.collection("users");
      _instance = UserFirestoreService();
    }
    return Future.value(_instance);
  }

  Future setCurrentUser(String userUid) async {
    QuerySnapshot querySnapshot =
        await _userCollection!.where("id", isEqualTo: userUid).get();
    QueryDocumentSnapshot? qds = querySnapshot.docs.firstOrNull;
    if (null != qds && qds.exists) {
      Map<String, dynamic> qdsData = qds.data() as Map<String, dynamic>;
      _currentUser = UserModel.fromJson(qdsData);
    } else {
      throw Exception("User data not found!");
    }
  }

  Future<DocumentReference<Object?>> addUser(UserModel userModel) async {
    return await _userCollection!.add(userModel.toJson());
  }

  Future<bool> deleteUserDetails() async {
    QuerySnapshot querySnapshot =
        await _userCollection!.where("id", isEqualTo: currentUser!.id).get();
    QueryDocumentSnapshot? qds = querySnapshot.docs.firstOrNull;
    _userCollection!.doc(qds?.reference.id).delete();
    return true;
  }
}
