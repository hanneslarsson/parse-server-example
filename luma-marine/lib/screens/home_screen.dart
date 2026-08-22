import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/wave_divider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final compact = Breakpoints.isCompact(width);

    return AppScaffold(
      section: NavSection.home,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Hero(compact: compact, l10n: l10n),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 16 : 40,
              vertical: 48,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.whyHeading,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                const WaveDivider(),
                const SizedBox(height: 24),
                _WhyGrid(compact: compact, l10n: l10n),
                const SizedBox(height: 56),
                Text(l10n.categoriesHeading,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),
                _CategoryGrid(compact: compact, l10n: l10n),
                const SizedBox(height: 56),
                _GuideTeaser(l10n: l10n, compact: compact),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final bool compact;
  final AppLocalizations l10n;

  const _Hero({required this.compact, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 20 : 64,
        vertical: compact ? 48 : 88,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navyDark, AppColors.navy],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.heroTitle,
                  style: TextStyle(
                    fontFamily: 'InterDisplay',
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    fontSize: compact ? 30 : 44,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.heroSubtitle,
                  style: const TextStyle(
                    color: Color(0xFFC7D5DD),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/shop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.seafoam,
                    foregroundColor: AppColors.navyDark,
                  ),
                  child: Text(l10n.heroCta),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhyGrid extends StatelessWidget {
  final bool compact;
  final AppLocalizations l10n;

  const _WhyGrid({required this.compact, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.verified_outlined, l10n.whyPoint1Title, l10n.whyPoint1Body),
      (Icons.straighten_outlined, l10n.whyPoint2Title, l10n.whyPoint2Body),
      (Icons.menu_book_outlined, l10n.whyPoint3Title, l10n.whyPoint3Body),
    ];

    final cards = items
        .map((item) => Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: compact ? 0 : 16,
                  bottom: compact ? 16 : 0,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.fog.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.$1, color: AppColors.seafoamDark, size: 28),
                    const SizedBox(height: 12),
                    Text(item.$2,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 6),
                    Text(item.$3,
                        style: const TextStyle(
                            color: AppColors.slate, height: 1.4)),
                  ],
                ),
              ),
            ))
        .toList();

    return compact
        ? Column(children: cards)
        : IntrinsicHeight(child: Row(children: cards));
  }
}

class _CategoryGrid extends StatelessWidget {
  final bool compact;
  final AppLocalizations l10n;

  const _CategoryGrid({required this.compact, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final categories = ProductCategory.values;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: compact ? 1 : (Breakpoints.isExpanded(
                MediaQuery.sizeOf(context).width)
            ? 5
            : 3),
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: compact ? 3.4 : 1.3,
      ),
      itemBuilder: (context, index) {
        final c = categories[index];
        return _CategoryTile(category: c, l10n: l10n);
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final ProductCategory category;
  final AppLocalizations l10n;

  const _CategoryTile({required this.category, required this.l10n});

  String _label() {
    switch (category) {
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () =>
          Navigator.of(context).pushNamed('/shop', arguments: category),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.fogDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(category.icon, color: AppColors.navy, size: 26),
            const SizedBox(height: 12),
            Text(_label(),
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _GuideTeaser extends StatelessWidget {
  final AppLocalizations l10n;
  final bool compact;

  const _GuideTeaser({required this.l10n, required this.compact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _guideTeaserText(context),
                const SizedBox(height: 16),
                _guideTeaserButton(context),
              ],
            )
          : Row(
              children: [
                Expanded(child: _guideTeaserText(context)),
                const SizedBox(width: 24),
                _guideTeaserButton(context),
              ],
            ),
    );
  }

  Widget _guideTeaserText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.guideHeading,
            style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
        const SizedBox(height: 8),
        Text(l10n.guideIntro,
            style: const TextStyle(color: Color(0xFFC7D5DD), height: 1.5)),
      ],
    );
  }

  Widget _guideTeaserButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.of(context).pushNamed('/guides'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.white,
        side: const BorderSide(color: AppColors.seafoam),
      ),
      child: Text(l10n.navGuides),
    );
  }
}
