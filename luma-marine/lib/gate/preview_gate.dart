import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// NOTE: this is a client-side gate to keep the in-development preview from
// being stumbled on casually while it's being built and reviewed. The
// "password" ships inside the compiled JS bundle, so it is trivially
// readable by anyone who inspects the build — it is NOT real access control
// and must never be relied on to protect anything sensitive.
const String previewGatePassword = 'lumamarine2026';

const String _prefsKey = 'luma_marine_preview_unlocked_v1';

class PreviewGateState extends ChangeNotifier {
  bool _unlocked = false;
  bool _loading = true;

  bool get unlocked => _unlocked;
  bool get loading => _loading;

  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    _unlocked = prefs.getBool(_prefsKey) ?? false;
    _loading = false;
    notifyListeners();
  }

  Future<bool> tryUnlock(String password) async {
    if (password != previewGatePassword) {
      return false;
    }
    _unlocked = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, true);
    return true;
  }
}
