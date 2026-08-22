import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/products_data.dart';
import '../l10n/app_localizations.dart';
import '../models/product.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/product_grid.dart';

/// Optional initial category to preselect, e.g. when arriving from a
/// "shop by category" tile on the home page.
class CatalogScreen extends StatefulWidget {
  final ProductCategory? initialCategory;

  const CatalogScreen({super.key, this.initialCategory});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  ProductCategory? _category;
  RangeValues _priceRange = const RangeValues(0, 4000);

  static const _maxPrice = 4000.0;

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _filtered(String locale) {
    return demoProducts.where((p) {
      if (_category != null && p.category != _category) return false;
      if (p.priceSek < _priceRange.start || p.priceSek > _priceRange.end) {
        return false;
      }
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return p.name.forLocale(locale).toLowerCase().contains(q) ||
          p.shortDescription.forLocale(locale).toLowerCase().contains(q) ||
          p.description.forLocale(locale).toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = context.watch<LocaleProvider>().locale.languageCode;
    final results = _filtered(locale);
    final width = MediaQuery.sizeOf(context).width;
    final compact = Breakpoints.isCompact(width);

    return AppScaffold(
      section: NavSection.shop,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 16 : 40,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(() {
                          _query = '';
                          _searchController.clear();
                        }),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ChoiceChip(
                  label: Text(l10n.filterAllCategories),
                  selected: _category == null,
                  onSelected: (_) => setState(() => _category = null),
                ),
                for (final c in ProductCategory.values)
                  ChoiceChip(
                    label: Text(_categoryLabel(l10n, c)),
                    selected: _category == c,
                    onSelected: (_) =>
                        setState(() => _category = _category == c ? null : c),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(l10n.filterPriceLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                Expanded(
                  child: RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: _maxPrice,
                    divisions: 40,
                    activeColor: AppColors.seafoamDark,
                    labels: RangeLabels(
                      '${_priceRange.start.round()}',
                      '${_priceRange.end.round()}',
                    ),
                    onChanged: (v) => setState(() => _priceRange = v),
                  ),
                ),
                if (_category != null ||
                    _query.isNotEmpty ||
                    _priceRange.start != 0 ||
                    _priceRange.end != _maxPrice)
                  TextButton(
                    onPressed: () => setState(() {
                      _category = null;
                      _query = '';
                      _searchController.clear();
                      _priceRange = const RangeValues(0, _maxPrice);
                    }),
                    child: Text(l10n.filterClear),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.resultsCount(results.length),
              style: const TextStyle(color: AppColors.slate),
            ),
            const SizedBox(height: 16),
            if (results.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded,
                        size: 40, color: AppColors.slate),
                    const SizedBox(height: 12),
                    Text(l10n.noResultsTitle,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(l10n.noResultsBody,
                        style: const TextStyle(color: AppColors.slate)),
                  ],
                ),
              )
            else
              ProductGrid(products: results),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(AppLocalizations l10n, ProductCategory c) {
    switch (c) {
      case ProductCategory.ledStrips:
        return l10n.categoryLedStrips;
      case ProductCategory.navigation:
        return l10n.categoryNavigation;
      case ProductCategory.deckInterior:
        return l10n.categoryDeckInterior;
      case ProductCategory.controllers:
        return l10n.categoryControllers;
      case ProductCategory.kits:
        return l10n.categoryKits;
    }
  }
}
