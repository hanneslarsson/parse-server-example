// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Luma Marine';

  @override
  String get navHome => 'Home';

  @override
  String get navShop => 'Shop';

  @override
  String get navGuides => 'Guides';

  @override
  String get cartLabel => 'Cart';

  @override
  String get searchHint => 'Search the inventory...';

  @override
  String get filterCategoryLabel => 'Category';

  @override
  String get filterAllCategories => 'All categories';

  @override
  String get filterPriceLabel => 'Price (SEK)';

  @override
  String get filterPriceFrom => 'From';

  @override
  String get filterPriceTo => 'To';

  @override
  String get filterClear => 'Clear filters';

  @override
  String get categoryLedStrips => 'LED Strip Lights';

  @override
  String get categoryNavigation => 'Navigation Lights';

  @override
  String get categoryDeckInterior => 'Deck & Interior Lighting';

  @override
  String get categoryControllers => 'Controllers & Dimmers';

  @override
  String get categoryKits => 'Complete Kits';

  @override
  String resultsCount(int count) {
    return 'Showing $count products';
  }

  @override
  String get noResultsTitle => 'No products found';

  @override
  String get noResultsBody => 'Try adjusting your search or filters.';

  @override
  String get retry => 'Try again';

  @override
  String get addToCart => 'Add to cart';

  @override
  String addedToCart(String name) {
    return '$name was added to your cart';
  }

  @override
  String get viewDetails => 'View details';

  @override
  String get specifications => 'Specifications';

  @override
  String get description => 'Description';

  @override
  String get priceLabel => 'Price';

  @override
  String get backToShop => 'Back to shop';

  @override
  String get cartTitle => 'Your cart';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptyBody =>
      'Explore our range of marine LED lighting and controllers.';

  @override
  String get cartContinueShopping => 'Continue shopping';

  @override
  String get cartRemove => 'Remove';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartProceedToCheckout => 'Proceed to checkout';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutContactHeading => 'Contact details';

  @override
  String get checkoutShippingHeading => 'Shipping address';

  @override
  String get fieldFirstName => 'First name';

  @override
  String get fieldLastName => 'Last name';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPhone => 'Phone';

  @override
  String get fieldAddress => 'Address';

  @override
  String get fieldPostalCode => 'Postal code';

  @override
  String get fieldCity => 'City';

  @override
  String get fieldCountry => 'Country';

  @override
  String get fieldComment => 'Comment (optional)';

  @override
  String get checkoutOrderSummaryHeading => 'Order summary';

  @override
  String get checkoutDemoNotice =>
      'This is a demo shop. No payment is processed and no real order is shipped.';

  @override
  String get checkoutPlaceOrder => 'Place order';

  @override
  String get checkoutValidationError => 'Please fill in all required fields.';

  @override
  String get confirmationTitle => 'Thank you for your order!';

  @override
  String get confirmationBody =>
      'Your order has been recorded. This is a demo, so no physical goods will be shipped.';

  @override
  String get confirmationOrderNumberLabel => 'Order number';

  @override
  String get confirmationBackHome => 'Back to home';

  @override
  String get heroTitle => 'The right light for your boat, in minutes';

  @override
  String get heroSubtitle =>
      'Luma Marine helps you find the best LED lighting solutions for boats under 12 metres — from single components to complete, ready-made kits.';

  @override
  String get heroCta => 'Browse the shop';

  @override
  String get whyHeading => 'Why Luma Marine';

  @override
  String get whyPoint1Title => 'Curated inventory';

  @override
  String get whyPoint1Body =>
      'We test and select LED lighting and controllers that withstand salt water, vibration and the Nordic climate.';

  @override
  String get whyPoint2Title => 'Built for smaller boats';

  @override
  String get whyPoint2Body =>
      'Every product and kit is sized for boats under 12 metres — the right size, the right power, the right price.';

  @override
  String get whyPoint3Title => 'Guidance, not just parts';

  @override
  String get whyPoint3Body =>
      'Our guides help you put together a complete lighting solution, not just buy loose components.';

  @override
  String get categoriesHeading => 'Shop by category';

  @override
  String get guideHeading => 'Boat lighting guides';

  @override
  String get guideIntro =>
      'Building a good lighting solution is about more than buying lamps. Here\'s what we recommend based on boat size and needs.';

  @override
  String get guideSmallTitle => 'Smaller boats (up to 6 m)';

  @override
  String get guideSmallBody =>
      'Focus on low-power LED strips for the cockpit and interior, plus a simple bow/stern navigation light. A small dimmer is enough to control mood lighting without draining the battery.';

  @override
  String get guideMidTitle => 'Midsize boats (6–12 m)';

  @override
  String get guideMidBody =>
      'Combine deck lighting, multi-zone interior lighting and full navigation lighting. A central multi-channel controller makes it easy to group and dim different zones separately.';

  @override
  String get guideControllerTitle => 'Choosing the right controller';

  @override
  String get guideControllerBody =>
      'A good controller needs to withstand moisture, handle the boat\'s voltage and support the number of zones you plan for. More zones give more flexibility but need more channels.';

  @override
  String get guideKitTitle => 'Or choose a complete kit';

  @override
  String get guideKitBody =>
      'If you\'d rather skip picking components one by one, we\'ve put together complete kits for different boat sizes and needs.';

  @override
  String get guideCta => 'See complete kits';

  @override
  String get footerTagline => 'Marine LED lighting for boats under 12 metres.';

  @override
  String footerRights(int year) {
    return '© $year Luma Marine. All rights reserved.';
  }

  @override
  String get gateTitle => 'Luma Marine';

  @override
  String get gateSubtitle =>
      'This preview is password-protected while under development.';

  @override
  String get gatePasswordLabel => 'Password';

  @override
  String get gateButton => 'Continue';

  @override
  String get gateError => 'Incorrect password. Please try again.';

  @override
  String get languageLabel => 'Language';

  @override
  String get specLength => 'Length';

  @override
  String get specLedCount => 'LED count';

  @override
  String get specColorTemp => 'Color temperature';

  @override
  String get specVoltage => 'Voltage';

  @override
  String get specIpRating => 'IP rating';

  @override
  String get specPower => 'Power';

  @override
  String get specChannels => 'Zones';

  @override
  String get specControlMethod => 'Control method';

  @override
  String get specMaterial => 'Material';

  @override
  String get specBeamAngle => 'Beam angle';

  @override
  String get specWirelessRange => 'Wireless range';

  @override
  String get specIncludes => 'Includes';
}
