/// A short piece of copy translated into the four storefront languages.
/// Used for product/data content that isn't UI chrome (which instead goes
/// through the generated [AppLocalizations] from the .arb files).
class L10nText {
  final String sv;
  final String en;
  final String no;
  final String da;

  const L10nText({
    required this.sv,
    required this.en,
    required this.no,
    required this.da,
  });

  String forLocale(String languageCode) {
    switch (languageCode) {
      case 'en':
        return en;
      case 'no':
        return no;
      case 'da':
        return da;
      case 'sv':
      default:
        return sv;
    }
  }
}
