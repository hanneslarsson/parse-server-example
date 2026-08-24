import 'package:flutter/material.dart';

import '../../models/l10n_text.dart';

/// Four stacked text fields (sv/en/no/da) for editing an [L10nText] value —
/// used throughout the admin forms wherever content needs translating.
///
/// Owns its own controllers (seeded once from [value]) rather than using
/// TextFormField's `initialValue`, since `initialValue` would need a fresh
/// key on every keystroke to pick up the parent's rebuilt [value] — which
/// resets the field and loses cursor position/focus while typing.
class L10nTextField extends StatefulWidget {
  final L10nText value;
  final ValueChanged<L10nText> onChanged;
  final bool multiline;

  const L10nTextField({
    super.key,
    required this.value,
    required this.onChanged,
    this.multiline = false,
  });

  @override
  State<L10nTextField> createState() => _L10nTextFieldState();
}

class _L10nTextFieldState extends State<L10nTextField> {
  late final TextEditingController _sv;
  late final TextEditingController _en;
  late final TextEditingController _no;
  late final TextEditingController _da;

  @override
  void initState() {
    super.initState();
    _sv = TextEditingController(text: widget.value.sv);
    _en = TextEditingController(text: widget.value.en);
    _no = TextEditingController(text: widget.value.no);
    _da = TextEditingController(text: widget.value.da);
  }

  @override
  void dispose() {
    _sv.dispose();
    _en.dispose();
    _no.dispose();
    _da.dispose();
    super.dispose();
  }

  void _emit() {
    widget.onChanged(L10nText(
      sv: _sv.text,
      en: _en.text,
      no: _no.text,
      da: _da.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _field('Svenska', _sv),
        const SizedBox(height: 8),
        _field('English', _en),
        const SizedBox(height: 8),
        _field('Norsk', _no),
        const SizedBox(height: 8),
        _field('Dansk', _da),
      ],
    );
  }

  Widget _field(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      maxLines: widget.multiline ? 3 : 1,
      decoration: InputDecoration(labelText: label, isDense: true),
      onChanged: (_) => _emit(),
    );
  }
}
