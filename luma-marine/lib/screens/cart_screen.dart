import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cart = context.watch<CartProvider>();
    final locale = context.watch<LocaleProvider>().locale.languageCode;
    final width = MediaQuery.sizeOf(context).width;
    final compact = Breakpoints.isCompact(width);

    return AppScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 16 : 40,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.cartTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            if (cart.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        size: 40, color: AppColors.slate),
                    const SizedBox(height: 12),
                    Text(l10n.cartEmptyTitle,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(l10n.cartEmptyBody,
                        style: const TextStyle(color: AppColors.slate)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed('/shop'),
                      child: Text(l10n.cartContinueShopping),
                    ),
                  ],
                ),
              )
            else ...[
              for (final line in cart.lines)
                Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color:
                                line.product.accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(line.product.icon,
                              color: line.product.accentColor),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                line.product.name.forLocale(locale),
                                style:
                                    const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text('${line.product.priceSek} kr',
                                  style:
                                      const TextStyle(color: AppColors.slate)),
                            ],
                          ),
                        ),
                        _QuantityStepper(
                          quantity: line.quantity,
                          onChanged: (q) => context
                              .read<CartProvider>()
                              .updateQuantity(line.product.id, q),
                        ),
                        const SizedBox(width: 8),
                        Text('${line.lineTotal} kr',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        IconButton(
                          tooltip: l10n.cartRemove,
                          icon: const Icon(Icons.delete_outline_rounded),
                          onPressed: () => context
                              .read<CartProvider>()
                              .remove(line.product.id),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(l10n.cartSubtotal,
                      style: const TextStyle(color: AppColors.slate)),
                  const SizedBox(width: 12),
                  Text(
                    '${cart.subtotalSek} kr',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/checkout'),
                  child: Text(l10n.cartProceedToCheckout),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline_rounded),
          onPressed: () => onChanged(quantity - 1),
        ),
        Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w600)),
        IconButton(
          icon: const Icon(Icons.add_circle_outline_rounded),
          onPressed: () => onChanged(quantity + 1),
        ),
      ],
    );
  }
}
