import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/products_data.dart';
import '../l10n/app_localizations.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = context.watch<LocaleProvider>().locale.languageCode;
    final product = demoProducts.firstWhere((p) => p.id == productId);
    final width = MediaQuery.sizeOf(context).width;
    final compact = Breakpoints.isCompact(width);

    final gallery = AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          color: product.accentColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Icon(product.icon, size: 96, color: product.accentColor),
        ),
      ),
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded, size: 18),
          label: Text(l10n.backToShop),
        ),
        Text(
          product.name.forLocale(locale),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          '${product.priceSek} kr',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            context.read<CartProvider>().add(product);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(l10n.addedToCart(product.name.forLocale(locale))),
              ),
            );
          },
          icon: const Icon(Icons.add_shopping_cart_rounded),
          label: Text(l10n.addToCart),
        ),
        const SizedBox(height: 28),
        Text(l10n.description,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),
        Text(
          product.description.forLocale(locale),
          style: const TextStyle(color: AppColors.slate, height: 1.5),
        ),
        const SizedBox(height: 28),
        Text(l10n.specifications,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),
        ...product.specs.map((spec) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _specLabel(l10n, spec.key),
                      style: const TextStyle(color: AppColors.slate),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      spec.resolvedValue(locale),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );

    return AppScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 16 : 40,
          vertical: 24,
        ),
        child: compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [gallery, const SizedBox(height: 24), info],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: gallery),
                  const SizedBox(width: 40),
                  Expanded(child: info),
                ],
              ),
      ),
    );
  }

  String _specLabel(AppLocalizations l10n, SpecKey key) {
    switch (key) {
      case SpecKey.length:
        return l10n.specLength;
      case SpecKey.ledCount:
        return l10n.specLedCount;
      case SpecKey.colorTemp:
        return l10n.specColorTemp;
      case SpecKey.voltage:
        return l10n.specVoltage;
      case SpecKey.ipRating:
        return l10n.specIpRating;
      case SpecKey.power:
        return l10n.specPower;
      case SpecKey.channels:
        return l10n.specChannels;
      case SpecKey.controlMethod:
        return l10n.specControlMethod;
      case SpecKey.material:
        return l10n.specMaterial;
      case SpecKey.beamAngle:
        return l10n.specBeamAngle;
      case SpecKey.wirelessRange:
        return l10n.specWirelessRange;
      case SpecKey.includes:
        return l10n.specIncludes;
    }
  }
}
