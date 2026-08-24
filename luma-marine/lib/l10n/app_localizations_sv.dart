// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Luma Marine';

  @override
  String get navHome => 'Hem';

  @override
  String get navShop => 'Sortiment';

  @override
  String get navGuides => 'Guider';

  @override
  String get cartLabel => 'Varukorg';

  @override
  String get searchHint => 'Sök i sortimentet...';

  @override
  String get filterCategoryLabel => 'Kategori';

  @override
  String get filterAllCategories => 'Alla kategorier';

  @override
  String get filterPriceLabel => 'Pris (SEK)';

  @override
  String get filterPriceFrom => 'Från';

  @override
  String get filterPriceTo => 'Till';

  @override
  String get filterClear => 'Rensa filter';

  @override
  String get categoryLedStrips => 'LED-remsor';

  @override
  String get categoryNavigation => 'Navigationsljus';

  @override
  String get categoryDeckInterior => 'Däck- & inredningsbelysning';

  @override
  String get categoryControllers => 'Styrenheter & dimmer';

  @override
  String get categoryKits => 'Kompletta paket';

  @override
  String resultsCount(int count) {
    return 'Visar $count produkter';
  }

  @override
  String get noResultsTitle => 'Inga produkter hittades';

  @override
  String get noResultsBody =>
      'Prova att justera din sökning eller dina filter.';

  @override
  String get retry => 'Försök igen';

  @override
  String get addToCart => 'Lägg i varukorg';

  @override
  String addedToCart(String name) {
    return '$name har lagts i varukorgen';
  }

  @override
  String get viewDetails => 'Visa detaljer';

  @override
  String get specifications => 'Specifikationer';

  @override
  String get description => 'Beskrivning';

  @override
  String get priceLabel => 'Pris';

  @override
  String get backToShop => 'Tillbaka till sortimentet';

  @override
  String get cartTitle => 'Din varukorg';

  @override
  String get cartEmptyTitle => 'Din varukorg är tom';

  @override
  String get cartEmptyBody =>
      'Utforska vårt sortiment av marin LED-belysning och styrenheter.';

  @override
  String get cartContinueShopping => 'Fortsätt handla';

  @override
  String get cartRemove => 'Ta bort';

  @override
  String get cartSubtotal => 'Delsumma';

  @override
  String get cartProceedToCheckout => 'Till kassan';

  @override
  String get checkoutTitle => 'Kassa';

  @override
  String get checkoutContactHeading => 'Kontaktuppgifter';

  @override
  String get checkoutShippingHeading => 'Leveransadress';

  @override
  String get fieldFirstName => 'Förnamn';

  @override
  String get fieldLastName => 'Efternamn';

  @override
  String get fieldEmail => 'E-post';

  @override
  String get fieldPhone => 'Telefon';

  @override
  String get fieldAddress => 'Adress';

  @override
  String get fieldPostalCode => 'Postnummer';

  @override
  String get fieldCity => 'Ort';

  @override
  String get fieldCountry => 'Land';

  @override
  String get fieldComment => 'Kommentar (valfritt)';

  @override
  String get checkoutOrderSummaryHeading => 'Ordersammanfattning';

  @override
  String get checkoutDemoNotice =>
      'Detta är en testbutik. Ingen betalning behandlas och ingen riktig order skickas.';

  @override
  String get checkoutPlaceOrder => 'Lägg beställning';

  @override
  String get checkoutValidationError => 'Fyll i alla obligatoriska fält.';

  @override
  String get confirmationTitle => 'Tack för din beställning!';

  @override
  String get confirmationBody =>
      'Din beställning har registrerats. Detta är en demo, så ingen faktisk vara skickas.';

  @override
  String get confirmationOrderNumberLabel => 'Ordernummer';

  @override
  String get confirmationBackHome => 'Tillbaka till startsidan';

  @override
  String get heroTitle => 'Rätt ljus för din båt, på minuten';

  @override
  String get heroSubtitle =>
      'Luma Marine hjälper dig hitta de bästa LED-lösningarna för båtar under 12 meter — från enskilda komponenter till kompletta, färdiga paket.';

  @override
  String get heroCta => 'Utforska sortimentet';

  @override
  String get whyHeading => 'Varför Luma Marine';

  @override
  String get whyPoint1Title => 'Utvalt sortiment';

  @override
  String get whyPoint1Body =>
      'Vi testar och väljer ut LED-belysning och styrenheter som tål saltvatten, vibrationer och nordiskt klimat.';

  @override
  String get whyPoint2Title => 'Byggd för mindre båtar';

  @override
  String get whyPoint2Body =>
      'Alla produkter och paket är anpassade för båtar under 12 meter — rätt storlek, rätt effekt, rätt pris.';

  @override
  String get whyPoint3Title => 'Rådgivning, inte bara delar';

  @override
  String get whyPoint3Body =>
      'Våra guider hjälper dig sätta ihop en komplett belysningslösning, inte bara köpa lösa komponenter.';

  @override
  String get categoriesHeading => 'Handla per kategori';

  @override
  String get guideHeading => 'Guider för båtbelysning';

  @override
  String get guideIntro =>
      'Att bygga en bra belysningslösning handlar om mer än att köpa lampor. Här är vad vi rekommenderar utifrån båtstorlek och behov.';

  @override
  String get guideSmallTitle => 'Mindre båtar (upp till 6 m)';

  @override
  String get guideSmallBody =>
      'Fokusera på lågeffekts-LED-remsor för sittbrunn och inredning samt ett enkelt navigationsljus fram/akter. En liten dimmerenhet räcker gott för att styra stämningsljus utan att belasta batteriet.';

  @override
  String get guideMidTitle => 'Mellanstora båtar (6–12 m)';

  @override
  String get guideMidBody =>
      'Kombinera däcksbelysning, inredningsbelysning i flera zoner och fullständig navigationsbelysning. En central styrenhet med flera kanaler gör det enkelt att gruppera och dimra olika zoner separat.';

  @override
  String get guideControllerTitle => 'Välj rätt styrenhet';

  @override
  String get guideControllerBody =>
      'En bra styrenhet ska tåla fukt, klara båtens spänning och stödja det antal zoner du planerar. Fler zoner ger mer flexibilitet men kräver fler kanaler.';

  @override
  String get guideKitTitle => 'Eller välj ett färdigt paket';

  @override
  String get guideKitBody =>
      'Om du hellre vill slippa välja komponent för komponent har vi satt ihop kompletta paket för olika båtstorlekar och behov.';

  @override
  String get guideCta => 'Se färdiga paket';

  @override
  String get footerTagline => 'Marin LED-belysning för båtar under 12 meter.';

  @override
  String footerRights(int year) {
    return '© $year Luma Marine. Alla rättigheter förbehållna.';
  }

  @override
  String get gateTitle => 'Luma Marine';

  @override
  String get gateSubtitle =>
      'Den här förhandsversionen är lösenordsskyddad under utveckling.';

  @override
  String get gatePasswordLabel => 'Lösenord';

  @override
  String get gateButton => 'Fortsätt';

  @override
  String get gateError => 'Fel lösenord. Försök igen.';

  @override
  String get languageLabel => 'Språk';

  @override
  String get specLength => 'Längd';

  @override
  String get specLedCount => 'Antal LED';

  @override
  String get specColorTemp => 'Färgtemperatur';

  @override
  String get specVoltage => 'Spänning';

  @override
  String get specIpRating => 'IP-klass';

  @override
  String get specPower => 'Effekt';

  @override
  String get specChannels => 'Zoner';

  @override
  String get specControlMethod => 'Styrmetod';

  @override
  String get specMaterial => 'Material';

  @override
  String get specBeamAngle => 'Strålvinkel';

  @override
  String get specWirelessRange => 'Trådlös räckvidd';

  @override
  String get specIncludes => 'Innehåller';
}
