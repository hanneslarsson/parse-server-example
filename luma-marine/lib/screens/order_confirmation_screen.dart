import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/wave_divider.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String orderNumber;

  const OrderConfirmationScreen({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.seafoam.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: AppColors.seafoamDark, size: 40),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.confirmationTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const WaveDivider(),
                const SizedBox(height: 12),
                Text(
                  l10n.confirmationBody,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.slate),
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.fog,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${l10n.confirmationOrderNumberLabel}: $orderNumber',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (r) => false),
                  child: Text(l10n.confirmationBackHome),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
