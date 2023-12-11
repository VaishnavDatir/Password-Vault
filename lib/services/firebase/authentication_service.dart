import 'package:firebase_auth/firebase_auth.dart';

import '../../app/app.logger.dart';

class AuthenticationService {
  final logger = getLogger('AuthenticationService');
  static FirebaseAuth? _firebaseAuth;
  static AuthenticationService? _instance;

  // final StringHandler _stringHandler = locator<StringHandler>();
  // final UserFirestoreService _userFirestoreService =
  //     locator<UserFirestoreService>();

  Future<AuthenticationService> init() async {
    if (_instance == null) {
      _firebaseAuth = FirebaseAuth.instance;
      _instance = AuthenticationService();
    }
    return Future.value(_instance);
  }

  Future getCurrentUser() async {
    User? user = _firebaseAuth!.currentUser;
    return user;
  }

  Future<UserCredential> signUpUserWithEmailPassword(
      String emailId, String password) async {
    return await _firebaseAuth!
        .createUserWithEmailAndPassword(email: emailId, password: password);
  }

  Future<UserCredential> signInWithEmailPassword(
      String emailId, String password) async {
    return await _firebaseAuth!
        .signInWithEmailAndPassword(email: emailId, password: password);
  }

  void signOutUser() async {
    await _firebaseAuth!.signOut();
  }
}