import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../services/api_client.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _postalCode = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController(text: 'Sverige');
  final _comment = TextEditingController();
  final _api = ApiClient();
  bool _submitting = false;
  String? _submitError;

  @override
  void dispose() {
    for (final c in [
      _firstName,
      _lastName,
      _email,
      _phone,
      _address,
      _postalCode,
      _city,
      _country,
      _comment,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? value) =>
      (value == null || value.trim().isEmpty) ? '' : null;

  Future<void> _placeOrder() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.checkoutValidationError)),
      );
      return;
    }
    setState(() {
      _submitting = true;
      _submitError = null;
    });
    final cart = context.read<CartProvider>();
    try {
      final response = await _api.post('/api/public/orders', body: {
        'customer': {
          'firstName': _firstName.text.trim(),
          'lastName': _lastName.text.trim(),
          'email': _email.text.trim(),
          'phone': _phone.text.trim(),
        },
        'shippingAddress': {
          'address': _address.text.trim(),
          'postalCode': _postalCode.text.trim(),
          'city': _city.text.trim(),
          'country': _country.text.trim(),
        },
        'comment': _comment.text.trim(),
        'items': cart.lines
            .map((line) => {
                  'articleId': line.product.id,
                  'quantity': line.quantity,
                })
            .toList(),
      }) as Map<String, dynamic>;
      if (!mounted) return;
      final orderNumber = response['orderNumber'] as String;
      cart.clear();
      Navigator.of(context)
          .pushReplacementNamed('/confirmation', arguments: orderNumber);
    } on ApiException catch (e) {
      setState(() {
        _submitting = false;
        _submitError = e.message;
      });
    } catch (_) {
      setState(() {
        _submitting = false;
        _submitError = l10n.checkoutValidationError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cart = context.watch<CartProvider>();
    final locale = context.watch<LocaleProvider>().locale.languageCode;
    final width = MediaQuery.sizeOf(context).width;
    final compact = Breakpoints.isCompact(width);

    final form = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.checkoutContactHeading,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstName,
                  validator: _required,
                  decoration:
                      InputDecoration(labelText: l10n.fieldFirstName),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _lastName,
                  validator: _required,
                  decoration: InputDecoration(labelText: l10n.fieldLastName),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _email,
            validator: _required,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: l10n.fieldEmail),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phone,
            validator: _required,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: l10n.fieldPhone),
          ),
          const SizedBox(height: 24),
          Text(l10n.checkoutShippingHeading,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 12),
          TextFormField(
            controller: _address,
            validator: _required,
            decoration: InputDecoration(labelText: l10n.fieldAddress),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _postalCode,
                  validator: _required,
                  decoration:
                      InputDecoration(labelText: l10n.fieldPostalCode),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _city,
                  validator: _required,
                  decoration: InputDecoration(labelText: l10n.fieldCity),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _country,
            validator: _required,
            decoration: InputDecoration(labelText: l10n.fieldCountry),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _comment,
            maxLines: 3,
            decoration: InputDecoration(labelText: l10n.fieldComment),
          ),
        ],
      ),
    );

    final summary = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.fog.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.checkoutOrderSummaryHeading,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 12),
          for (final line in cart.lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${line.product.name.forLocale(locale)} × ${line.quantity}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text('${line.lineTotal} kr'),
                ],
              ),
            ),
          const Divider(height: 24),
          Row(
            children: [
              Text(l10n.cartSubtotal,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${cart.subtotalSek} kr',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.fogDark),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 18, color: AppColors.slate),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.checkoutDemoNotice,
                    style: const TextStyle(
                        color: AppColors.slate, fontSize: 12.5),
                  ),
                ),
              ],
            ),
          ),
          if (_submitError != null) ...[
            const SizedBox(height: 12),
            Text(_submitError!, style: const TextStyle(color: AppColors.danger)),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitting ? null : _placeOrder,
            child: _submitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.white),
                  )
                : Text(l10n.checkoutPlaceOrder),
          ),
        ],
      ),
    );

    return AppScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 16 : 40,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.checkoutTitle,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            compact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [form, const SizedBox(height: 24), summary],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: form),
                      const SizedBox(width: 32),
                      Expanded(flex: 2, child: summary),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
