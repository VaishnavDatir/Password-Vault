import 'package:crypt/crypt.dart';
import 'package:encrypt/encrypt.dart';
import 'package:password_vault/app/app.logger.dart';
import 'package:password_vault/core/constants/remote_config.constants.dart';
import 'package:password_vault/services/firebase/remote_config_service.dart';

import '../../app/app.locator.dart';

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

  String encryptAuthPass(plainText, String id) {
    plainText = Crypt.sha256(plainText);
    final encrypter = Encrypter(AES(key!));
    Encrypted encrypted = encrypter.encrypt(plainText.toString(),
        iv: IV.fromUtf8(
            _remoteConfig.getString(id.padRight(16, 'v').substring(0, 16))));
    String encryptedStr = encrypted.base64.toString();
    return encryptedStr;
  }

  Crypt decryptAuthPass(encryptedStr, String id) {
    final encrypter = Encrypter(AES(key!));
    String decrypted = encrypter.decrypt64(encryptedStr,
        iv: IV.fromUtf8(
            _remoteConfig.getString(id.padRight(16, 'v').substring(0, 16))));
    Crypt decryptedStr = Crypt(decrypted);
    return (decryptedStr);
  }
}
