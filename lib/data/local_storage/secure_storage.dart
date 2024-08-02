import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageFrave {
  Future<bool> setAuthToken(String token) async {
    SharedPreferences secureStorage = await SharedPreferences.getInstance();

    try {
      await secureStorage.setString('x-auth-token', token);
      // Read back the token to verify it's saved correctly
      final savedToken = await secureStorage.getString('x-auth-token');
      print('Saved token: $savedToken');
      return savedToken == token;
    } catch (e) {
      return false;
    }
  }

  Future<String?> readToken() async {
    SharedPreferences secureStorage = await SharedPreferences.getInstance();
    return await secureStorage.getString('x-auth-token');
  }

  Future<void> deleteSecureStorage() async {
    SharedPreferences secureStorage = await SharedPreferences.getInstance();
    await secureStorage.setString('x-auth-token', '');
  }
}

final secureStorage = SecureStorageFrave();
