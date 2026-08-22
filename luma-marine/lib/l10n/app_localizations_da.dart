// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Luma Marine';

  @override
  String get navHome => 'Hjem';

  @override
  String get navShop => 'Butik';

  @override
  String get navGuides => 'Guides';

  @override
  String get cartLabel => 'Kurv';

  @override
  String get searchHint => 'Søg i sortimentet...';

  @override
  String get filterCategoryLabel => 'Kategori';

  @override
  String get filterAllCategories => 'Alle kategorier';

  @override
  String get filterPriceLabel => 'Pris (SEK)';

  @override
  String get filterPriceFrom => 'Fra';

  @override
  String get filterPriceTo => 'Til';

  @override
  String get filterClear => 'Ryd filtre';

  @override
  String get categoryLedStrips => 'LED-strips';

  @override
  String get categoryNavigation => 'Navigationslys';

  @override
  String get categoryDeckInterior => 'Dæk- og interiørbelysning';

  @override
  String get categoryControllers => 'Styreenheder & dæmpere';

  @override
  String get categoryKits => 'Komplette pakker';

  @override
  String resultsCount(int count) {
    return 'Viser $count produkter';
  }

  @override
  String get noResultsTitle => 'Ingen produkter fundet';

  @override
  String get noResultsBody => 'Prøv at justere din søgning eller dine filtre.';

  @override
  String get addToCart => 'Læg i kurv';

  @override
  String addedToCart(String name) {
    return '$name blev lagt i kurven';
  }

  @override
  String get viewDetails => 'Se detaljer';

  @override
  String get specifications => 'Specifikationer';

  @override
  String get description => 'Beskrivelse';

  @override
  String get priceLabel => 'Pris';

  @override
  String get backToShop => 'Tilbage til butikken';

  @override
  String get cartTitle => 'Din kurv';

  @override
  String get cartEmptyTitle => 'Din kurv er tom';

  @override
  String get cartEmptyBody =>
      'Udforsk vores sortiment af marine LED-lys og styreenheder.';

  @override
  String get cartContinueShopping => 'Fortsæt med at handle';

  @override
  String get cartRemove => 'Fjern';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartProceedToCheckout => 'Gå til kassen';

  @override
  String get checkoutTitle => 'Kasse';

  @override
  String get checkoutContactHeading => 'Kontaktoplysninger';

  @override
  String get checkoutShippingHeading => 'Leveringsadresse';

  @override
  String get fieldFirstName => 'Fornavn';

  @override
  String get fieldLastName => 'Efternavn';

  @override
  String get fieldEmail => 'E-mail';

  @override
  String get fieldPhone => 'Telefon';

  @override
  String get fieldAddress => 'Adresse';

  @override
  String get fieldPostalCode => 'Postnummer';

  @override
  String get fieldCity => 'By';

  @override
  String get fieldCountry => 'Land';

  @override
  String get checkoutOrderSummaryHeading => 'Ordreoversigt';

  @override
  String get checkoutDemoNotice =>
      'Dette er en testbutik. Der behandles ingen betaling, og der sendes ingen reel ordre.';

  @override
  String get checkoutPlaceOrder => 'Afgiv ordre';

  @override
  String get checkoutValidationError =>
      'Udfyld venligst alle obligatoriske felter.';

  @override
  String get confirmationTitle => 'Tak for din ordre!';

  @override
  String get confirmationBody =>
      'Din ordre er registreret. Dette er en demo, så der sendes ingen fysiske varer.';

  @override
  String get confirmationOrderNumberLabel => 'Ordrenummer';

  @override
  String get confirmationBackHome => 'Tilbage til forsiden';

  @override
  String get heroTitle => 'Det rette lys til din båd, på minutter';

  @override
  String get heroSubtitle =>
      'Luma Marine hjælper dig med at finde de bedste LED-løsninger til både under 12 meter — fra enkeltkomponenter til komplette, færdige pakker.';

  @override
  String get heroCta => 'Udforsk sortimentet';

  @override
  String get whyHeading => 'Hvorfor Luma Marine';

  @override
  String get whyPoint1Title => 'Udvalgt sortiment';

  @override
  String get whyPoint1Body =>
      'Vi tester og udvælger LED-belysning og styreenheder, der tåler saltvand, vibrationer og det nordiske klima.';

  @override
  String get whyPoint2Title => 'Bygget til mindre både';

  @override
  String get whyPoint2Body =>
      'Alle produkter og pakker er tilpasset både under 12 meter — den rette størrelse, den rette effekt, den rette pris.';

  @override
  String get whyPoint3Title => 'Rådgivning, ikke kun dele';

  @override
  String get whyPoint3Body =>
      'Vores guides hjælper dig med at sammensætte en komplet lysløsning, ikke bare købe løse komponenter.';

  @override
  String get categoriesHeading => 'Handl efter kategori';

  @override
  String get guideHeading => 'Guides til bådbelysning';

  @override
  String get guideIntro =>
      'At bygge en god lysløsning handler om mere end at købe lamper. Her er, hvad vi anbefaler ud fra bådstørrelse og behov.';

  @override
  String get guideSmallTitle => 'Mindre både (op til 6 m)';

  @override
  String get guideSmallBody =>
      'Fokuser på lavstrøms LED-strips til cockpit og interiør samt et simpelt navigationslys for/agter. En lille dæmper er nok til at styre stemningsbelysning uden at belaste batteriet.';

  @override
  String get guideMidTitle => 'Mellemstore både (6–12 m)';

  @override
  String get guideMidBody =>
      'Kombiner dækbelysning, flerzone-interiørbelysning og fuld navigationsbelysning. En central styreenhed med flere kanaler gør det nemt at gruppere og dæmpe forskellige zoner separat.';

  @override
  String get guideControllerTitle => 'Vælg den rette styreenhed';

  @override
  String get guideControllerBody =>
      'En god styreenhed skal kunne tåle fugt, klare bådens spænding og understøtte det antal zoner, du planlægger. Flere zoner giver mere fleksibilitet, men kræver flere kanaler.';

  @override
  String get guideKitTitle => 'Eller vælg en komplet pakke';

  @override
  String get guideKitBody =>
      'Hvis du hellere vil slippe for at vælge komponent for komponent, har vi sammensat komplette pakker til forskellige bådstørrelser og behov.';

  @override
  String get guideCta => 'Se komplette pakker';

  @override
  String get footerTagline => 'Marin LED-belysning til både under 12 meter.';

  @override
  String footerRights(int year) {
    return '© $year Luma Marine. Alle rettigheder forbeholdes.';
  }

  @override
  String get gateTitle => 'Luma Marine';

  @override
  String get gateSubtitle =>
      'Denne forhåndsvisning er adgangskodebeskyttet under udvikling.';

  @override
  String get gatePasswordLabel => 'Adgangskode';

  @override
  String get gateButton => 'Fortsæt';

  @override
  String get gateError => 'Forkert adgangskode. Prøv igen.';

  @override
  String get languageLabel => 'Sprog';

  @override
  String get specLength => 'Længde';

  @override
  String get specLedCount => 'Antal LED';

  @override
  String get specColorTemp => 'Farvetemperatur';

  @override
  String get specVoltage => 'Spænding';

  @override
  String get specIpRating => 'IP-klasse';

  @override
  String get specPower => 'Effekt';

  @override
  String get specChannels => 'Zoner';

  @override
  String get specControlMethod => 'Styremetode';

  @override
  String get specMaterial => 'Materiale';

  @override
  String get specBeamAngle => 'Strålevinkel';

  @override
  String get specWirelessRange => 'Trådløs rækkevidde';

  @override
  String get specIncludes => 'Inkluderer';
}
