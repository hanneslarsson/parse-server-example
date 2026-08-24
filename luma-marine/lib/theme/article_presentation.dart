import 'package:flutter/material.dart';

import '../models/product.dart';
import 'app_theme.dart';

const _amber = Color(0xFFE0A458);

/// Curated icon/accent per known seed article id, for visual variety beyond
/// the plain per-category default. Articles created later in the admin
/// panel won't have an entry here and fall back to [categoryPresentation].
const Map<String, (IconData, Color)> _curated = {
  'led-strip-warm-5m': (Icons.wb_incandescent_outlined, _amber),
  'led-strip-cool-5m': (Icons.wb_iridescent_outlined, _amber),
  'led-strip-rgb-5m': (Icons.palette_outlined, AppColors.seafoam),
  'led-strip-warm-3m': (Icons.wb_incandescent_outlined, _amber),
  'led-strip-daylight-10m': (Icons.wb_sunny_outlined, _amber),
  'led-strip-dimmable-kit': (Icons.tune_rounded, AppColors.seafoam),
  'nav-bow-light': (Icons.navigation_outlined, AppColors.navyLight),
  'nav-stern-light': (Icons.arrow_downward_rounded, AppColors.navyLight),
  'nav-anchor-light': (Icons.anchor_outlined, AppColors.navyLight),
  'nav-combo-set': (Icons.explore_outlined, AppColors.navyLight),
  'deck-recessed-light': (Icons.deck_outlined, _amber),
  'deck-courtesy-pack': (Icons.grid_view_rounded, _amber),
  'interior-dome-light': (Icons.lightbulb_outline, _amber),
  'underwater-transom-light': (Icons.water_outlined, AppColors.seafoamDark),
  'cabin-reading-light': (Icons.menu_book_outlined, _amber),
  'cockpit-spotlight': (Icons.flashlight_on_outlined, _amber),
  'controller-single-zone': (Icons.tune_rounded, AppColors.navyDark),
  'controller-4zone-bt': (Icons.bluetooth_outlined, AppColors.navyDark),
  'controller-rgb-app': (Icons.color_lens_outlined, AppColors.navyDark),
  'controller-master-panel': (Icons.dashboard_customize_outlined, AppColors.navyDark),
  'kit-starter-small': (Icons.sailing_outlined, AppColors.seafoamDark),
  'kit-cockpit-comfort': (Icons.weekend_outlined, AppColors.seafoamDark),
  'kit-full-deck-cabin': (Icons.directions_boat_filled_outlined, AppColors.seafoamDark),
  'kit-nav-essentials': (Icons.explore_outlined, AppColors.seafoamDark),
};

const Map<ProductCategory, Color> _categoryColor = {
  ProductCategory.ledStrips: _amber,
  ProductCategory.navigation: AppColors.navyLight,
  ProductCategory.deckInterior: _amber,
  ProductCategory.controllers: AppColors.navyDark,
  ProductCategory.kits: AppColors.seafoamDark,
};

(IconData, Color) articlePresentation(String id, ProductCategory category) {
  return _curated[id] ??
      (category.icon, _categoryColor[category] ?? AppColors.navy);
}
