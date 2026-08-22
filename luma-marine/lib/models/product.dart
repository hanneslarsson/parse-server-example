import 'package:flutter/material.dart';
import 'l10n_text.dart';

enum ProductCategory {
  ledStrips,
  navigation,
  deckInterior,
  controllers,
  kits,
}

extension ProductCategoryX on ProductCategory {
  /// Localized label lookup key used against [AppLocalizations].
  String get labelKey {
    switch (this) {
      case ProductCategory.ledStrips:
        return 'categoryLedStrips';
      case ProductCategory.navigation:
        return 'categoryNavigation';
      case ProductCategory.deckInterior:
        return 'categoryDeckInterior';
      case ProductCategory.controllers:
        return 'categoryControllers';
      case ProductCategory.kits:
        return 'categoryKits';
    }
  }

  IconData get icon {
    switch (this) {
      case ProductCategory.ledStrips:
        return Icons.linear_scale_rounded;
      case ProductCategory.navigation:
        return Icons.explore_outlined;
      case ProductCategory.deckInterior:
        return Icons.deck_outlined;
      case ProductCategory.controllers:
        return Icons.tune_rounded;
      case ProductCategory.kits:
        return Icons.inventory_2_outlined;
    }
  }
}

enum SpecKey {
  length,
  ledCount,
  colorTemp,
  voltage,
  ipRating,
  power,
  channels,
  controlMethod,
  material,
  beamAngle,
  wirelessRange,
  includes,
}

class ProductSpec {
  final SpecKey key;
  final String value;
  final L10nText? localizedValue;

  const ProductSpec(this.key, this.value, {this.localizedValue});

  factory ProductSpec.term(SpecKey key, L10nText term) =>
      ProductSpec(key, term.sv, localizedValue: term);

  String resolvedValue(String languageCode) =>
      localizedValue?.forLocale(languageCode) ?? value;
}

class Product {
  final String id;
  final ProductCategory category;
  final L10nText name;
  final L10nText shortDescription;
  final L10nText description;
  final List<ProductSpec> specs;
  final int priceSek;
  final Color accentColor;
  final IconData icon;

  const Product({
    required this.id,
    required this.category,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.specs,
    required this.priceSek,
    required this.accentColor,
    required this.icon,
  });
}
