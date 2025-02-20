import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final storage = FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    final token=await storage.read(key: key);
    if(token!=null) {
      return token;
    } else {
      print("Token is null");
    }
  }
}
