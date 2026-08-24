// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class AppLocalizationsNo extends AppLocalizations {
  AppLocalizationsNo([String locale = 'no']) : super(locale);

  @override
  String get appTitle => 'Luma Marine';

  @override
  String get navHome => 'Hjem';

  @override
  String get navShop => 'Butikk';

  @override
  String get navGuides => 'Guider';

  @override
  String get cartLabel => 'Handlekurv';

  @override
  String get searchHint => 'Søk i sortimentet...';

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
  String get filterClear => 'Nullstill filter';

  @override
  String get categoryLedStrips => 'LED-lysstriper';

  @override
  String get categoryNavigation => 'Navigasjonslys';

  @override
  String get categoryDeckInterior => 'Dekk- og innredningsbelysning';

  @override
  String get categoryControllers => 'Styreenheter & dimmere';

  @override
  String get categoryKits => 'Komplette pakker';

  @override
  String resultsCount(int count) {
    return 'Viser $count produkter';
  }

  @override
  String get noResultsTitle => 'Ingen produkter funnet';

  @override
  String get noResultsBody => 'Prøv å justere søket eller filtrene dine.';

  @override
  String get retry => 'Prøv igjen';

  @override
  String get addToCart => 'Legg i handlekurv';

  @override
  String addedToCart(String name) {
    return '$name ble lagt i handlekurven';
  }

  @override
  String get viewDetails => 'Vis detaljer';

  @override
  String get specifications => 'Spesifikasjoner';

  @override
  String get description => 'Beskrivelse';

  @override
  String get priceLabel => 'Pris';

  @override
  String get backToShop => 'Tilbake til butikken';

  @override
  String get cartTitle => 'Handlekurven din';

  @override
  String get cartEmptyTitle => 'Handlekurven din er tom';

  @override
  String get cartEmptyBody =>
      'Utforsk sortimentet vårt av marine LED-lys og styreenheter.';

  @override
  String get cartContinueShopping => 'Fortsett å handle';

  @override
  String get cartRemove => 'Fjern';

  @override
  String get cartSubtotal => 'Delsum';

  @override
  String get cartProceedToCheckout => 'Gå til kassen';

  @override
  String get checkoutTitle => 'Kasse';

  @override
  String get checkoutContactHeading => 'Kontaktinformasjon';

  @override
  String get checkoutShippingHeading => 'Leveringsadresse';

  @override
  String get fieldFirstName => 'Fornavn';

  @override
  String get fieldLastName => 'Etternavn';

  @override
  String get fieldEmail => 'E-post';

  @override
  String get fieldPhone => 'Telefon';

  @override
  String get fieldAddress => 'Adresse';

  @override
  String get fieldPostalCode => 'Postnummer';

  @override
  String get fieldCity => 'Sted';

  @override
  String get fieldCountry => 'Land';

  @override
  String get fieldComment => 'Kommentar (valgfritt)';

  @override
  String get checkoutOrderSummaryHeading => 'Ordresammendrag';

  @override
  String get checkoutDemoNotice =>
      'Dette er en testbutikk. Ingen betaling behandles, og ingen reell ordre sendes.';

  @override
  String get checkoutPlaceOrder => 'Legg inn bestilling';

  @override
  String get checkoutValidationError => 'Fyll ut alle obligatoriske felt.';

  @override
  String get confirmationTitle => 'Takk for bestillingen!';

  @override
  String get confirmationBody =>
      'Bestillingen din er registrert. Dette er en demo, så ingen fysiske varer blir sendt.';

  @override
  String get confirmationOrderNumberLabel => 'Ordrenummer';

  @override
  String get confirmationBackHome => 'Tilbake til forsiden';

  @override
  String get heroTitle => 'Riktig lys for båten din, på minutter';

  @override
  String get heroSubtitle =>
      'Luma Marine hjelper deg å finne de beste LED-løsningene for båter under 12 meter — fra enkeltkomponenter til komplette, ferdige pakker.';

  @override
  String get heroCta => 'Utforsk sortimentet';

  @override
  String get whyHeading => 'Hvorfor Luma Marine';

  @override
  String get whyPoint1Title => 'Utvalgt sortiment';

  @override
  String get whyPoint1Body =>
      'Vi tester og velger ut LED-belysning og styreenheter som tåler saltvann, vibrasjon og det nordiske klimaet.';

  @override
  String get whyPoint2Title => 'Laget for mindre båter';

  @override
  String get whyPoint2Body =>
      'Alle produkter og pakker er tilpasset båter under 12 meter — riktig størrelse, riktig effekt, riktig pris.';

  @override
  String get whyPoint3Title => 'Veiledning, ikke bare deler';

  @override
  String get whyPoint3Body =>
      'Guidene våre hjelper deg med å sette sammen en komplett lysløsning, ikke bare kjøpe løse komponenter.';

  @override
  String get categoriesHeading => 'Handle etter kategori';

  @override
  String get guideHeading => 'Guider for båtbelysning';

  @override
  String get guideIntro =>
      'Å bygge en god lysløsning handler om mer enn å kjøpe lamper. Her er hva vi anbefaler basert på båtstørrelse og behov.';

  @override
  String get guideSmallTitle => 'Mindre båter (opptil 6 m)';

  @override
  String get guideSmallBody =>
      'Fokuser på lavstrøms LED-striper i cockpit og innredning, samt et enkelt navigasjonslys foran/akter. En liten dimmer er nok til å styre stemningslys uten å belaste batteriet.';

  @override
  String get guideMidTitle => 'Mellomstore båter (6–12 m)';

  @override
  String get guideMidBody =>
      'Kombiner dekksbelysning, flersonet innredningsbelysning og full navigasjonsbelysning. En sentral styreenhet med flere kanaler gjør det enkelt å gruppere og dimme ulike soner separat.';

  @override
  String get guideControllerTitle => 'Velg riktig styreenhet';

  @override
  String get guideControllerBody =>
      'En god styreenhet må tåle fuktighet, håndtere båtens spenning og støtte antall soner du planlegger for. Flere soner gir mer fleksibilitet, men krever flere kanaler.';

  @override
  String get guideKitTitle => 'Eller velg en komplett pakke';

  @override
  String get guideKitBody =>
      'Hvis du heller vil slippe å velge komponent for komponent, har vi satt sammen komplette pakker for ulike båtstørrelser og behov.';

  @override
  String get guideCta => 'Se komplette pakker';

  @override
  String get footerTagline => 'Marin LED-belysning for båter under 12 meter.';

  @override
  String footerRights(int year) {
    return '© $year Luma Marine. Alle rettigheter forbeholdt.';
  }

  @override
  String get gateTitle => 'Luma Marine';

  @override
  String get gateSubtitle =>
      'Denne forhåndsvisningen er passordbeskyttet under utvikling.';

  @override
  String get gatePasswordLabel => 'Passord';

  @override
  String get gateButton => 'Fortsett';

  @override
  String get gateError => 'Feil passord. Prøv igjen.';

  @override
  String get languageLabel => 'Språk';

  @override
  String get specLength => 'Lengde';

  @override
  String get specLedCount => 'Antall LED';

  @override
  String get specColorTemp => 'Fargetemperatur';

  @override
  String get specVoltage => 'Spenning';

  @override
  String get specIpRating => 'IP-klasse';

  @override
  String get specPower => 'Effekt';

  @override
  String get specChannels => 'Soner';

  @override
  String get specControlMethod => 'Styremetode';

  @override
  String get specMaterial => 'Materiale';

  @override
  String get specBeamAngle => 'Strålevinkel';

  @override
  String get specWirelessRange => 'Trådløs rekkevidde';

  @override
  String get specIncludes => 'Inkluderer';
}
