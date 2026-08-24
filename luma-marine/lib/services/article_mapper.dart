import '../models/l10n_text.dart';
import '../models/product.dart';
import '../theme/article_presentation.dart';

/// Converts a raw backend article JSON object (see
/// luma-marine-server/src/models/types.ts `Article`) into the storefront's
/// [Product] view model. Presentation (icon/color) isn't backend data, so
/// it's resolved from [articlePresentation] by id/category.
Product productFromArticleJson(Map<String, dynamic> json) {
  final category = ProductCategory.values.byName(json['category'] as String);
  final (icon, color) = articlePresentation(json['id'] as String, category);

  final specs = (json['specs'] as List<dynamic>? ?? [])
      .map((raw) {
        final map = raw as Map<String, dynamic>;
        SpecKey? key;
        try {
          key = SpecKey.values.byName(map['key'] as String);
        } catch (_) {
          key = null;
        }
        if (key == null) return null;
        final localized = map['localizedValue'] != null
            ? L10nText.fromJson(map['localizedValue'] as Map<String, dynamic>)
            : null;
        return ProductSpec(
          key,
          map['value'] as String? ?? '',
          localizedValue: localized,
        );
      })
      .whereType<ProductSpec>()
      .toList();

  return Product(
    id: json['id'] as String,
    category: category,
    name: L10nText.fromJson(json['name'] as Map<String, dynamic>),
    shortDescription:
        L10nText.fromJson(json['shortDescription'] as Map<String, dynamic>),
    description: L10nText.fromJson(json['description'] as Map<String, dynamic>),
    specs: specs,
    priceSek: (json['priceSek'] as num).toInt(),
    accentColor: color,
    icon: icon,
  );
}
