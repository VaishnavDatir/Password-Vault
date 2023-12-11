import 'package:password_vault/app/app.logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final logger = getLogger('SharedPreferencesService');
  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  Future<SharedPreferencesService> init() async {
    if (_instance == null) {
      _preferences = await SharedPreferences.getInstance();
      _instance = SharedPreferencesService();
    }

    return Future.value(_instance);
  }

  dynamic read(String key) async {
    var value = _preferences!.get(key);
    logger.i('(TRACE) SharePrefsService READ: key: $key value: $value');
    return value;
  }

  write<T>(String key, T content) async {
    if (_instance == null) {
      _preferences = await SharedPreferences.getInstance();
      _instance = SharedPreferencesService();
    }
    logger.i('(TRACE) SharePrefsService WRITE: key: $key value: $content');

    if (content is String) {
      await _preferences!.setString(key, content);
    }
    if (content is bool) {
      await _preferences!.setBool(key, content);
    }
    if (content is int) {
      await _preferences!.setInt(key, content);
    }
    if (content is double) {
      await _preferences!.setDouble(key, content);
    }
    if (content is List<String>) {
      await _preferences!.setStringList(key, content);
    }
  }

  void clear() {
    _preferences!.clear();
    logger.i('(TRACE) SharePrefsService cleared');
  }
}
