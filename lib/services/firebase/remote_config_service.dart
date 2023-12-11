import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:password_vault/core/constants/remote_config.constants.dart';

import '../../app/app.logger.dart';

class RemoteConfigService {
  final logger = getLogger('RemoteConfigService');
  static FirebaseRemoteConfig? _remoteConfig;
  static RemoteConfigService? _instance;

  Future<RemoteConfigService> init() async {
    if (_instance == null) {
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _remoteConfig!.setDefaults(const {
        kRcEncryptionKeyParamName: kRcEncryptionKeyValue,
        kRcIvKeyParamName: kRcIvKeyValue,
      }).then((value) => _instance = RemoteConfigService());
    }
    return Future.value(_instance);
  }

  String getString(String key) => _remoteConfig!.getString(key); // NEW
  bool getBool(String key) => _remoteConfig!.getBool(key); // NEW
  int getInt(String key) => _remoteConfig!.getInt(key); // NEW
  double getDouble(String key) => _remoteConfig!.getDouble(key); // NEW
}
