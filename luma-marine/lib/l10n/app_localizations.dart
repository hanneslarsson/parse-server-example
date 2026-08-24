import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_da.dart';
import 'app_localizations_en.dart';
import 'app_localizations_no.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('da'),
    Locale('en'),
    Locale('no'),
    Locale('sv'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In sv, this message translates to:
  /// **'Luma Marine'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In sv, this message translates to:
  /// **'Hem'**
  String get navHome;

  /// No description provided for @navShop.
  ///
  /// In sv, this message translates to:
  /// **'Sortiment'**
  String get navShop;

  /// No description provided for @navGuides.
  ///
  /// In sv, this message translates to:
  /// **'Guider'**
  String get navGuides;

  /// No description provided for @cartLabel.
  ///
  /// In sv, this message translates to:
  /// **'Varukorg'**
  String get cartLabel;

  /// No description provided for @searchHint.
  ///
  /// In sv, this message translates to:
  /// **'Sök i sortimentet...'**
  String get searchHint;

  /// No description provided for @filterCategoryLabel.
  ///
  /// In sv, this message translates to:
  /// **'Kategori'**
  String get filterCategoryLabel;

  /// No description provided for @filterAllCategories.
  ///
  /// In sv, this message translates to:
  /// **'Alla kategorier'**
  String get filterAllCategories;

  /// No description provided for @filterPriceLabel.
  ///
  /// In sv, this message translates to:
  /// **'Pris (SEK)'**
  String get filterPriceLabel;

  /// No description provided for @filterPriceFrom.
  ///
  /// In sv, this message translates to:
  /// **'Från'**
  String get filterPriceFrom;

  /// No description provided for @filterPriceTo.
  ///
  /// In sv, this message translates to:
  /// **'Till'**
  String get filterPriceTo;

  /// No description provided for @filterClear.
  ///
  /// In sv, this message translates to:
  /// **'Rensa filter'**
  String get filterClear;

  /// No description provided for @categoryLedStrips.
  ///
  /// In sv, this message translates to:
  /// **'LED-remsor'**
  String get categoryLedStrips;

  /// No description provided for @categoryNavigation.
  ///
  /// In sv, this message translates to:
  /// **'Navigationsljus'**
  String get categoryNavigation;

  /// No description provided for @categoryDeckInterior.
  ///
  /// In sv, this message translates to:
  /// **'Däck- & inredningsbelysning'**
  String get categoryDeckInterior;

  /// No description provided for @categoryControllers.
  ///
  /// In sv, this message translates to:
  /// **'Styrenheter & dimmer'**
  String get categoryControllers;

  /// No description provided for @categoryKits.
  ///
  /// In sv, this message translates to:
  /// **'Kompletta paket'**
  String get categoryKits;

  /// No description provided for @resultsCount.
  ///
  /// In sv, this message translates to:
  /// **'Visar {count} produkter'**
  String resultsCount(int count);

  /// No description provided for @noResultsTitle.
  ///
  /// In sv, this message translates to:
  /// **'Inga produkter hittades'**
  String get noResultsTitle;

  /// No description provided for @noResultsBody.
  ///
  /// In sv, this message translates to:
  /// **'Prova att justera din sökning eller dina filter.'**
  String get noResultsBody;

  /// No description provided for @retry.
  ///
  /// In sv, this message translates to:
  /// **'Försök igen'**
  String get retry;

  /// No description provided for @addToCart.
  ///
  /// In sv, this message translates to:
  /// **'Lägg i varukorg'**
  String get addToCart;

  /// No description provided for @addedToCart.
  ///
  /// In sv, this message translates to:
  /// **'{name} har lagts i varukorgen'**
  String addedToCart(String name);

  /// No description provided for @viewDetails.
  ///
  /// In sv, this message translates to:
  /// **'Visa detaljer'**
  String get viewDetails;

  /// No description provided for @specifications.
  ///
  /// In sv, this message translates to:
  /// **'Specifikationer'**
  String get specifications;

  /// No description provided for @description.
  ///
  /// In sv, this message translates to:
  /// **'Beskrivning'**
  String get description;

  /// No description provided for @priceLabel.
  ///
  /// In sv, this message translates to:
  /// **'Pris'**
  String get priceLabel;

  /// No description provided for @backToShop.
  ///
  /// In sv, this message translates to:
  /// **'Tillbaka till sortimentet'**
  String get backToShop;

  /// No description provided for @cartTitle.
  ///
  /// In sv, this message translates to:
  /// **'Din varukorg'**
  String get cartTitle;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In sv, this message translates to:
  /// **'Din varukorg är tom'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyBody.
  ///
  /// In sv, this message translates to:
  /// **'Utforska vårt sortiment av marin LED-belysning och styrenheter.'**
  String get cartEmptyBody;

  /// No description provided for @cartContinueShopping.
  ///
  /// In sv, this message translates to:
  /// **'Fortsätt handla'**
  String get cartContinueShopping;

  /// No description provided for @cartRemove.
  ///
  /// In sv, this message translates to:
  /// **'Ta bort'**
  String get cartRemove;

  /// No description provided for @cartSubtotal.
  ///
  /// In sv, this message translates to:
  /// **'Delsumma'**
  String get cartSubtotal;

  /// No description provided for @cartProceedToCheckout.
  ///
  /// In sv, this message translates to:
  /// **'Till kassan'**
  String get cartProceedToCheckout;

  /// No description provided for @checkoutTitle.
  ///
  /// In sv, this message translates to:
  /// **'Kassa'**
  String get checkoutTitle;

  /// No description provided for @checkoutContactHeading.
  ///
  /// In sv, this message translates to:
  /// **'Kontaktuppgifter'**
  String get checkoutContactHeading;

  /// No description provided for @checkoutShippingHeading.
  ///
  /// In sv, this message translates to:
  /// **'Leveransadress'**
  String get checkoutShippingHeading;

  /// No description provided for @fieldFirstName.
  ///
  /// In sv, this message translates to:
  /// **'Förnamn'**
  String get fieldFirstName;

  /// No description provided for @fieldLastName.
  ///
  /// In sv, this message translates to:
  /// **'Efternamn'**
  String get fieldLastName;

  /// No description provided for @fieldEmail.
  ///
  /// In sv, this message translates to:
  /// **'E-post'**
  String get fieldEmail;

  /// No description provided for @fieldPhone.
  ///
  /// In sv, this message translates to:
  /// **'Telefon'**
  String get fieldPhone;

  /// No description provided for @fieldAddress.
  ///
  /// In sv, this message translates to:
  /// **'Adress'**
  String get fieldAddress;

  /// No description provided for @fieldPostalCode.
  ///
  /// In sv, this message translates to:
  /// **'Postnummer'**
  String get fieldPostalCode;

  /// No description provided for @fieldCity.
  ///
  /// In sv, this message translates to:
  /// **'Ort'**
  String get fieldCity;

  /// No description provided for @fieldCountry.
  ///
  /// In sv, this message translates to:
  /// **'Land'**
  String get fieldCountry;

  /// No description provided for @fieldComment.
  ///
  /// In sv, this message translates to:
  /// **'Kommentar (valfritt)'**
  String get fieldComment;

  /// No description provided for @checkoutOrderSummaryHeading.
  ///
  /// In sv, this message translates to:
  /// **'Ordersammanfattning'**
  String get checkoutOrderSummaryHeading;

  /// No description provided for @checkoutDemoNotice.
  ///
  /// In sv, this message translates to:
  /// **'Detta är en testbutik. Ingen betalning behandlas och ingen riktig order skickas.'**
  String get checkoutDemoNotice;

  /// No description provided for @checkoutPlaceOrder.
  ///
  /// In sv, this message translates to:
  /// **'Lägg beställning'**
  String get checkoutPlaceOrder;

  /// No description provided for @checkoutValidationError.
  ///
  /// In sv, this message translates to:
  /// **'Fyll i alla obligatoriska fält.'**
  String get checkoutValidationError;

  /// No description provided for @confirmationTitle.
  ///
  /// In sv, this message translates to:
  /// **'Tack för din beställning!'**
  String get confirmationTitle;

  /// No description provided for @confirmationBody.
  ///
  /// In sv, this message translates to:
  /// **'Din beställning har registrerats. Detta är en demo, så ingen faktisk vara skickas.'**
  String get confirmationBody;

  /// No description provided for @confirmationOrderNumberLabel.
  ///
  /// In sv, this message translates to:
  /// **'Ordernummer'**
  String get confirmationOrderNumberLabel;

  /// No description provided for @confirmationBackHome.
  ///
  /// In sv, this message translates to:
  /// **'Tillbaka till startsidan'**
  String get confirmationBackHome;

  /// No description provided for @heroTitle.
  ///
  /// In sv, this message translates to:
  /// **'Rätt ljus för din båt, på minuten'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In sv, this message translates to:
  /// **'Luma Marine hjälper dig hitta de bästa LED-lösningarna för båtar under 12 meter — från enskilda komponenter till kompletta, färdiga paket.'**
  String get heroSubtitle;

  /// No description provided for @heroCta.
  ///
  /// In sv, this message translates to:
  /// **'Utforska sortimentet'**
  String get heroCta;

  /// No description provided for @whyHeading.
  ///
  /// In sv, this message translates to:
  /// **'Varför Luma Marine'**
  String get whyHeading;

  /// No description provided for @whyPoint1Title.
  ///
  /// In sv, this message translates to:
  /// **'Utvalt sortiment'**
  String get whyPoint1Title;

  /// No description provided for @whyPoint1Body.
  ///
  /// In sv, this message translates to:
  /// **'Vi testar och väljer ut LED-belysning och styrenheter som tål saltvatten, vibrationer och nordiskt klimat.'**
  String get whyPoint1Body;

  /// No description provided for @whyPoint2Title.
  ///
  /// In sv, this message translates to:
  /// **'Byggd för mindre båtar'**
  String get whyPoint2Title;

  /// No description provided for @whyPoint2Body.
  ///
  /// In sv, this message translates to:
  /// **'Alla produkter och paket är anpassade för båtar under 12 meter — rätt storlek, rätt effekt, rätt pris.'**
  String get whyPoint2Body;

  /// No description provided for @whyPoint3Title.
  ///
  /// In sv, this message translates to:
  /// **'Rådgivning, inte bara delar'**
  String get whyPoint3Title;

  /// No description provided for @whyPoint3Body.
  ///
  /// In sv, this message translates to:
  /// **'Våra guider hjälper dig sätta ihop en komplett belysningslösning, inte bara köpa lösa komponenter.'**
  String get whyPoint3Body;

  /// No description provided for @categoriesHeading.
  ///
  /// In sv, this message translates to:
  /// **'Handla per kategori'**
  String get categoriesHeading;

  /// No description provided for @guideHeading.
  ///
  /// In sv, this message translates to:
  /// **'Guider för båtbelysning'**
  String get guideHeading;

  /// No description provided for @guideIntro.
  ///
  /// In sv, this message translates to:
  /// **'Att bygga en bra belysningslösning handlar om mer än att köpa lampor. Här är vad vi rekommenderar utifrån båtstorlek och behov.'**
  String get guideIntro;

  /// No description provided for @guideSmallTitle.
  ///
  /// In sv, this message translates to:
  /// **'Mindre båtar (upp till 6 m)'**
  String get guideSmallTitle;

  /// No description provided for @guideSmallBody.
  ///
  /// In sv, this message translates to:
  /// **'Fokusera på lågeffekts-LED-remsor för sittbrunn och inredning samt ett enkelt navigationsljus fram/akter. En liten dimmerenhet räcker gott för att styra stämningsljus utan att belasta batteriet.'**
  String get guideSmallBody;

  /// No description provided for @guideMidTitle.
  ///
  /// In sv, this message translates to:
  /// **'Mellanstora båtar (6–12 m)'**
  String get guideMidTitle;

  /// No description provided for @guideMidBody.
  ///
  /// In sv, this message translates to:
  /// **'Kombinera däcksbelysning, inredningsbelysning i flera zoner och fullständig navigationsbelysning. En central styrenhet med flera kanaler gör det enkelt att gruppera och dimra olika zoner separat.'**
  String get guideMidBody;

  /// No description provided for @guideControllerTitle.
  ///
  /// In sv, this message translates to:
  /// **'Välj rätt styrenhet'**
  String get guideControllerTitle;

  /// No description provided for @guideControllerBody.
  ///
  /// In sv, this message translates to:
  /// **'En bra styrenhet ska tåla fukt, klara båtens spänning och stödja det antal zoner du planerar. Fler zoner ger mer flexibilitet men kräver fler kanaler.'**
  String get guideControllerBody;

  /// No description provided for @guideKitTitle.
  ///
  /// In sv, this message translates to:
  /// **'Eller välj ett färdigt paket'**
  String get guideKitTitle;

  /// No description provided for @guideKitBody.
  ///
  /// In sv, this message translates to:
  /// **'Om du hellre vill slippa välja komponent för komponent har vi satt ihop kompletta paket för olika båtstorlekar och behov.'**
  String get guideKitBody;

  /// No description provided for @guideCta.
  ///
  /// In sv, this message translates to:
  /// **'Se färdiga paket'**
  String get guideCta;

  /// No description provided for @footerTagline.
  ///
  /// In sv, this message translates to:
  /// **'Marin LED-belysning för båtar under 12 meter.'**
  String get footerTagline;

  /// No description provided for @footerRights.
  ///
  /// In sv, this message translates to:
  /// **'© {year} Luma Marine. Alla rättigheter förbehållna.'**
  String footerRights(int year);

  /// No description provided for @gateTitle.
  ///
  /// In sv, this message translates to:
  /// **'Luma Marine'**
  String get gateTitle;

  /// No description provided for @gateSubtitle.
  ///
  /// In sv, this message translates to:
  /// **'Den här förhandsversionen är lösenordsskyddad under utveckling.'**
  String get gateSubtitle;

  /// No description provided for @gatePasswordLabel.
  ///
  /// In sv, this message translates to:
  /// **'Lösenord'**
  String get gatePasswordLabel;

  /// No description provided for @gateButton.
  ///
  /// In sv, this message translates to:
  /// **'Fortsätt'**
  String get gateButton;

  /// No description provided for @gateError.
  ///
  /// In sv, this message translates to:
  /// **'Fel lösenord. Försök igen.'**
  String get gateError;

  /// No description provided for @languageLabel.
  ///
  /// In sv, this message translates to:
  /// **'Språk'**
  String get languageLabel;

  /// No description provided for @specLength.
  ///
  /// In sv, this message translates to:
  /// **'Längd'**
  String get specLength;

  /// No description provided for @specLedCount.
  ///
  /// In sv, this message translates to:
  /// **'Antal LED'**
  String get specLedCount;

  /// No description provided for @specColorTemp.
  ///
  /// In sv, this message translates to:
  /// **'Färgtemperatur'**
  String get specColorTemp;

  /// No description provided for @specVoltage.
  ///
  /// In sv, this message translates to:
  /// **'Spänning'**
  String get specVoltage;

  /// No description provided for @specIpRating.
  ///
  /// In sv, this message translates to:
  /// **'IP-klass'**
  String get specIpRating;

  /// No description provided for @specPower.
  ///
  /// In sv, this message translates to:
  /// **'Effekt'**
  String get specPower;

  /// No description provided for @specChannels.
  ///
  /// In sv, this message translates to:
  /// **'Zoner'**
  String get specChannels;

  /// No description provided for @specControlMethod.
  ///
  /// In sv, this message translates to:
  /// **'Styrmetod'**
  String get specControlMethod;

  /// No description provided for @specMaterial.
  ///
  /// In sv, this message translates to:
  /// **'Material'**
  String get specMaterial;

  /// No description provided for @specBeamAngle.
  ///
  /// In sv, this message translates to:
  /// **'Strålvinkel'**
  String get specBeamAngle;

  /// No description provided for @specWirelessRange.
  ///
  /// In sv, this message translates to:
  /// **'Trådlös räckvidd'**
  String get specWirelessRange;

  /// No description provided for @specIncludes.
  ///
  /// In sv, this message translates to:
  /// **'Innehåller'**
  String get specIncludes;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['da', 'en', 'no', 'sv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'da':
      return AppLocalizationsDa();
    case 'en':
      return AppLocalizationsEn();
    case 'no':
      return AppLocalizationsNo();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
