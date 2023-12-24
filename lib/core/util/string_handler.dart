import 'package:encrypt/encrypt.dart';
import 'package:password_vault/app/app.logger.dart';
import 'package:password_vault/services/firebase/remote_config_service.dart';

import '../../app/app.locator.dart';
import '../constants/remote_config.constants.dart';

class StringHandler {
  final logger = getLogger('StringHandler');
  static StringHandler? _instance;

  static IV? iv;
  static Key? key;

  final RemoteConfigService _remoteConfig = locator<RemoteConfigService>();
  Future<StringHandler> init() async {
    // iv = IV.fromUtf8(_remoteConfig.getString(kRcIvKeyParamName));
    key = Key.fromUtf8(_remoteConfig.getString(kRcEncryptionKeyParamName));
    _instance ??= StringHandler();
    return Future.value(_instance);
  }

  String encryptAuthPass(String plainText, String id) {
    final encrypter = Encrypter(AES(key!, mode: AESMode.ofb64Gctr));
    Encrypted encrypted = encrypter.encrypt(plainText.toString(),
        iv: IV.fromUtf8(
            _remoteConfig.getString(id.padRight(16, 'v').substring(0, 16))));
    return encrypted.base64.toString();
  }

  String decryptAuthPass(String encryptedStr, String id) {
    final encrypter = Encrypter(AES(key!, mode: AESMode.ofb64Gctr));
    String decrypted = encrypter.decrypt64(encryptedStr.toString(),
        iv: IV.fromUtf8(
            _remoteConfig.getString(id.padRight(16, 'v').substring(0, 16))));
    return (decrypted);
  }
}
