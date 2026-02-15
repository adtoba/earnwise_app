import 'package:earnwise_app/core/constants/pref_keys.dart';
import 'package:hive/hive.dart';

class LocalStorageService {
  static final db = Hive.box(PrefKeys.appData);

  static Future<dynamic> get(String key) async {
    return await db.get(key);
  }

  static Future<bool> put(String key, dynamic value) async {
    try {
      await db.put(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> remove(String key) async {
    try {
      await db.delete(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> clearDB() async {
    try {
      await db.clear();
      return false;
    } catch (e) {
      return false;
    }
  }
  
}