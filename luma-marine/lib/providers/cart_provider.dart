import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartLine {
  final Product product;
  int quantity;

  CartLine(this.product, this.quantity);

  int get lineTotal => product.priceSek * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartLine> _lines = {};

  List<CartLine> get lines => _lines.values.toList(growable: false);

  bool get isEmpty => _lines.isEmpty;

  int get totalItems =>
      _lines.values.fold(0, (sum, line) => sum + line.quantity);

  int get subtotalSek =>
      _lines.values.fold(0, (sum, line) => sum + line.lineTotal);

  void add(Product product, {int quantity = 1}) {
    final existing = _lines[product.id];
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _lines[product.id] = CartLine(product, quantity);
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      remove(productId);
      return;
    }
    final existing = _lines[productId];
    if (existing != null) {
      existing.quantity = quantity;
      notifyListeners();
    }
  }

  void remove(String productId) {
    if (_lines.remove(productId) != null) {
      notifyListeners();
    }
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}
