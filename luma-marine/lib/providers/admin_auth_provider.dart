import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_client.dart';

const _tokenPrefsKey = 'luma_marine_admin_token_v1';

/// Admin session state: JWT issued by the backend on login, persisted in
/// browser storage so a page refresh doesn't sign the admin out. Entirely
/// separate from the storefront's preview [PreviewGateState] — this is real
/// authentication against the backend, not a testing convenience.
class AdminAuthProvider extends ChangeNotifier {
  final ApiClient _api;

  AdminAuthProvider({ApiClient? api}) : _api = api ?? ApiClient();

  String? token;
  String? adminName;
  String? adminEmail;
  bool restoring = true;

  bool get isAuthenticated => token != null;

  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_tokenPrefsKey);
    if (stored != null) {
      token = stored;
      try {
        final me = await _api.get('/api/auth/me', token: stored)
            as Map<String, dynamic>;
        adminName = me['name'] as String?;
        adminEmail = me['email'] as String?;
      } catch (_) {
        // Token expired/invalid — drop it and require a fresh login.
        token = null;
        await prefs.remove(_tokenPrefsKey);
      }
    }
    restoring = false;
    notifyListeners();
  }

  // BETA: username only, no password — see the matching note in the
  // backend's /api/auth/login handler. Restore the password parameter here
  // when that's re-enabled.
  Future<String?> login(String username) async {
    try {
      final json = await _api.post('/api/auth/login', body: {
        'email': username,
      }) as Map<String, dynamic>;
      token = json['token'] as String;
      final user = json['user'] as Map<String, dynamic>;
      adminName = user['name'] as String?;
      adminEmail = user['email'] as String?;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenPrefsKey, token!);
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Kunde inte logga in. Kontrollera din anslutning.';
    }
  }

  Future<void> logout() async {
    token = null;
    adminName = null;
    adminEmail = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenPrefsKey);
    notifyListeners();
  }
}
