import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/api_client.dart';
import '../services/article_mapper.dart';

enum CatalogStatus { loading, loaded, error }

/// Loads the publicly-visible article catalog from the backend once and
/// exposes it as [Product]s for the storefront (search/catalog/product
/// detail all read from here instead of static demo data).
class CatalogProvider extends ChangeNotifier {
  final ApiClient _api;

  CatalogProvider({ApiClient? api}) : _api = api ?? ApiClient();

  CatalogStatus status = CatalogStatus.loading;
  List<Product> products = [];
  String? errorMessage;

  Future<void> load() async {
    status = CatalogStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      final raw = await _api.get('/api/public/articles') as List<dynamic>;
      products = raw
          .map((json) => productFromArticleJson(json as Map<String, dynamic>))
          .toList();
      status = CatalogStatus.loaded;
    } on ApiException catch (e) {
      errorMessage = e.message;
      status = CatalogStatus.error;
    } catch (_) {
      errorMessage = 'Kunde inte hämta sortimentet.';
      status = CatalogStatus.error;
    }
    notifyListeners();
  }

  Product? byId(String id) {
    for (final product in products) {
      if (product.id == id) return product;
    }
    return null;
  }
}
