import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/wave_divider.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final compact = Breakpoints.isCompact(width);

    return AppScaffold(
      section: NavSection.guides,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 16 : 40,
          vertical: 32,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 880),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.guideHeading,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              const WaveDivider(),
              const SizedBox(height: 16),
              Text(l10n.guideIntro,
                  style: const TextStyle(color: AppColors.slate, height: 1.5)),
              const SizedBox(height: 32),
              _GuideCard(
                icon: Icons.sailing_outlined,
                title: l10n.guideSmallTitle,
                body: l10n.guideSmallBody,
              ),
              const SizedBox(height: 16),
              _GuideCard(
                icon: Icons.directions_boat_filled_outlined,
                title: l10n.guideMidTitle,
                body: l10n.guideMidBody,
              ),
              const SizedBox(height: 16),
              _GuideCard(
                icon: Icons.tune_rounded,
                title: l10n.guideControllerTitle,
                body: l10n.guideControllerBody,
              ),
              const SizedBox(height: 16),
              _GuideCard(
                icon: Icons.inventory_2_outlined,
                title: l10n.guideKitTitle,
                body: l10n.guideKitBody,
                cta: l10n.guideCta,
                onCta: () => Navigator.of(context).pushNamed(
                  '/shop',
                  arguments: ProductCategory.kits,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String? cta;
  final VoidCallback? onCta;

  const _GuideCard({
    required this.icon,
    required this.title,
    required this.body,
    this.cta,
    this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.seafoam.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.seafoamDark),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(body,
                      style:
                          const TextStyle(color: AppColors.slate, height: 1.5)),
                  if (cta != null) ...[
                    const SizedBox(height: 12),
                    OutlinedButton(onPressed: onCta, child: Text(cta!)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
