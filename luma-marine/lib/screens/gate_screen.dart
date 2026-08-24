import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../gate/preview_gate.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/luma_logo.dart';
import '../widgets/wave_divider.dart';

class GateScreen extends StatefulWidget {
  const GateScreen({super.key});

  @override
  State<GateScreen> createState() => _GateScreenState();
}

class _GateScreenState extends State<GateScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;
  bool _error = false;
  bool _obscure = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = false;
    });
    final gate = context.read<PreviewGateState>();
    final ok = await gate.tryUnlock(_controller.text.trim());
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _error = !ok;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: LumaMark(size: 44, color: AppColors.navy)),
                    const SizedBox(height: 16),
                    Text(
                      l10n.gateTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: AppColors.navy),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.gateSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.slate),
                    ),
                    const SizedBox(height: 8),
                    const WaveDivider(),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _controller,
                      obscureText: _obscure,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: l10n.gatePasswordLabel,
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (value) =>
                          (value == null || value.isEmpty) ? '' : null,
                    ),
                    if (_error) ...[
                      const SizedBox(height: 8),
                      Text(
                        l10n.gateError,
                        style: const TextStyle(color: AppColors.danger),
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : Text(l10n.gateButton),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
