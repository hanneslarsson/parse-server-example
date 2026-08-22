import '../models/l10n_text.dart';

/// Reusable, translated terms for spec values shared across many products
/// (color temperatures, control methods, materials) so each product only
/// references a constant instead of repeating a translation.
class SpecTerms {
  SpecTerms._();

  static const warmWhite = L10nText(
    sv: 'Varmvit 2700K',
    en: 'Warm white 2700K',
    no: 'Varmhvit 2700K',
    da: 'Varmhvid 2700K',
  );

  static const coolWhite = L10nText(
    sv: 'Kallvit 6000K',
    en: 'Cool white 6000K',
    no: 'Kaldhvit 6000K',
    da: 'Koldhvid 6000K',
  );

  static const daylight = L10nText(
    sv: 'Dagsljusvit 5000K',
    en: 'Daylight white 5000K',
    no: 'Dagslysvarm 5000K',
    da: 'Dagslysvhid 5000K',
  );

  static const blueWhite = L10nText(
    sv: 'Blå/vit',
    en: 'Blue/white',
    no: 'Blå/hvit',
    da: 'Blå/hvid',
  );

  static const rgbColor = L10nText(
    sv: 'RGB, valfri färg',
    en: 'RGB, any color',
    no: 'RGB, valgfri farge',
    da: 'RGB, valgfri farve',
  );

  static const remoteControl = L10nText(
    sv: 'Fjärrkontroll',
    en: 'Remote control',
    no: 'Fjernkontroll',
    da: 'Fjernbetjening',
  );

  static const appControl = L10nText(
    sv: 'App (Bluetooth)',
    en: 'App (Bluetooth)',
    no: 'App (Bluetooth)',
    da: 'App (Bluetooth)',
  );

  static const wallSwitch = L10nText(
    sv: 'Vägg-/panelbrytare',
    en: 'Wall/panel switch',
    no: 'Vegg-/panelbryter',
    da: 'Væg-/panelkontakt',
  );

  static const touchDimmer = L10nText(
    sv: 'Touch-dimmer',
    en: 'Touch dimmer',
    no: 'Touch-dimmer',
    da: 'Touch-dæmper',
  );

  static const inlineDial = L10nText(
    sv: 'Vridratt inline',
    en: 'Inline dial',
    no: 'Vribryter inline',
    da: 'Drejeknap inline',
  );

  static const stainlessSteel = L10nText(
    sv: 'Rostfritt stål (316)',
    en: 'Stainless steel (316)',
    no: 'Rustfritt stål (316)',
    da: 'Rustfrit stål (316)',
  );

  static const aluminum = L10nText(
    sv: 'Anodiserad aluminium',
    en: 'Anodized aluminum',
    no: 'Anodisert aluminium',
    da: 'Anodiseret aluminium',
  );

  static const abs = L10nText(
    sv: 'UV-beständig ABS-plast',
    en: 'UV-resistant ABS plastic',
    no: 'UV-bestandig ABS-plast',
    da: 'UV-bestandig ABS-plast',
  );

  static const flexibleGooseneck = L10nText(
    sv: 'Böjbar hals, aluminium',
    en: 'Flexible gooseneck, aluminum',
    no: 'Bøybar hals, aluminium',
    da: 'Bøjelig hals, aluminium',
  );
}
