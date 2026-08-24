import 'package:flutter/foundation.dart';

import '../models/banner.dart';
import '../models/l10n_text.dart';
import '../services/api_client.dart';

/// Loads the public site settings (contact info, opening hours, and the
/// banners currently within their active date window) once at startup.
class SettingsProvider extends ChangeNotifier {
  final ApiClient _api;

  SettingsProvider({ApiClient? api}) : _api = api ?? ApiClient();

  bool loading = true;
  String contactEmail = '';
  String contactPhone = '';
  L10nText openingHours = L10nText.empty;
  List<SiteBanner> activeBanners = [];

  Future<void> load() async {
    loading = true;
    notifyListeners();
    try {
      final json =
          await _api.get('/api/public/settings') as Map<String, dynamic>;
      contactEmail = json['contactEmail'] as String? ?? '';
      contactPhone = json['contactPhone'] as String? ?? '';
      openingHours = json['openingHours'] != null
          ? L10nText.fromJson(json['openingHours'] as Map<String, dynamic>)
          : L10nText.empty;
      activeBanners = (json['activeBanners'] as List<dynamic>? ?? [])
          .map((b) => SiteBanner.fromJson(b as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Non-critical: the storefront works fine without contact info/banners.
    }
    loading = false;
    notifyListeners();
  }
}
