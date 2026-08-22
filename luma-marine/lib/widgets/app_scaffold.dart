import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';

enum NavSection { home, shop, guides, other }

/// Shared page chrome: a top nav bar with logo, section links, language
/// switcher and cart icon, plus a footer — wrapped around each screen's body
/// so every page of the store feels consistent.
class AppScaffold extends StatelessWidget {
  final Widget body;
  final NavSection section;
  final bool scrollableBody;

  const AppScaffold({
    super.key,
    required this.body,
    this.section = NavSection.other,
    this.scrollableBody = true,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = Breakpoints.isCompact(width);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TopNav(section: section, compact: compact),
        Expanded(
          child: scrollableBody
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      body,
                      const _Footer(),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: body),
                    const _Footer(),
                  ],
                ),
        ),
      ],
    );

    return Scaffold(body: content);
  }
}

class _TopNav extends StatelessWidget {
  final NavSection section;
  final bool compact;

  const _TopNav({required this.section, required this.compact});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cart = context.watch<CartProvider>();

    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 16 : 40,
        vertical: 14,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () =>
                Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false),
            child: Row(
              children: [
                const Icon(Icons.water_rounded, color: AppColors.seafoamDark),
                const SizedBox(width: 8),
                Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    fontFamily: 'InterDisplay',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (!compact) ...[
            _NavLink(
              label: l10n.navHome,
              active: section == NavSection.home,
              onTap: () =>
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false),
            ),
            _NavLink(
              label: l10n.navShop,
              active: section == NavSection.shop,
              onTap: () => Navigator.of(context).pushNamed('/shop'),
            ),
            _NavLink(
              label: l10n.navGuides,
              active: section == NavSection.guides,
              onTap: () => Navigator.of(context).pushNamed('/guides'),
            ),
            const SizedBox(width: 8),
          ],
          const _LanguageSwitcher(),
          const SizedBox(width: 4),
          IconButton(
            tooltip: l10n.cartLabel,
            onPressed: () => Navigator.of(context).pushNamed('/cart'),
            icon: Badge(
              label: Text('${cart.totalItems}'),
              isLabelVisible: cart.totalItems > 0,
              backgroundColor: AppColors.seafoamDark,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          if (compact)
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu_rounded),
              onSelected: (route) => Navigator.of(context).pushNamed(route),
              itemBuilder: (context) => [
                PopupMenuItem(value: '/', child: Text(l10n.navHome)),
                PopupMenuItem(value: '/shop', child: Text(l10n.navShop)),
                PopupMenuItem(value: '/guides', child: Text(l10n.navGuides)),
              ],
            ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavLink({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: active ? AppColors.seafoamDark : AppColors.ink,
      ),
      child: Text(label),
    );
  }
}

class _LanguageSwitcher extends StatelessWidget {
  const _LanguageSwitcher();

  static const _names = {
    'sv': 'Svenska',
    'no': 'Norsk',
    'da': 'Dansk',
    'en': 'English',
  };

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    return PopupMenuButton<Locale>(
      tooltip: AppLocalizations.of(context)!.languageLabel,
      initialValue: localeProvider.locale,
      onSelected: (locale) => context.read<LocaleProvider>().setLocale(locale),
      itemBuilder: (context) => supportedLocales
          .map((l) => PopupMenuItem(
                value: l,
                child: Text(_names[l.languageCode] ?? l.languageCode),
              ))
          .toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded, size: 20),
            const SizedBox(width: 4),
            Text(_names[localeProvider.locale.languageCode] ?? ''),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final compact = Breakpoints.isCompact(width);
    return Container(
      color: AppColors.navy,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 20 : 40,
        vertical: 28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.water_rounded, color: AppColors.seafoam),
              const SizedBox(width: 8),
              Text(
                l10n.appTitle,
                style: const TextStyle(
                  fontFamily: 'InterDisplay',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.footerTagline,
            style: const TextStyle(color: Color(0xFFB7C5CE)),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.footerRights(DateTime.now().year),
            style: const TextStyle(color: Color(0xFF7C8E98), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
