import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/l10n_text.dart';
import '../../providers/admin_auth_provider.dart';
import '../../services/api_client.dart';
import '../../theme/app_theme.dart';
import '../widgets/admin_shell.dart';
import '../widgets/l10n_text_field.dart';

const _categoryLabels = {
  'ledStrips': 'LED-remsor',
  'navigation': 'Navigationsljus',
  'deckInterior': 'Däck- & inredningsbelysning',
  'controllers': 'Styrenheter & dimmer',
  'kits': 'Kompletta paket',
};

const _specKeyLabels = {
  'length': 'Längd',
  'ledCount': 'Antal LED',
  'colorTemp': 'Färgtemperatur',
  'voltage': 'Spänning',
  'ipRating': 'IP-klass',
  'power': 'Effekt',
  'channels': 'Zoner',
  'controlMethod': 'Styrmetod',
  'material': 'Material',
  'beamAngle': 'Strålvinkel',
  'wirelessRange': 'Trådlös räckvidd',
  'includes': 'Innehåller',
};

class _SpecRow {
  String key;
  String value;
  _SpecRow(this.key, this.value);
}

/// Create/edit form for a single article. When [articleId] is null this
/// creates a new article; otherwise it loads and updates the existing one.
class AdminArticleFormScreen extends StatefulWidget {
  final String? articleId;

  const AdminArticleFormScreen({super.key, this.articleId});

  @override
  State<AdminArticleFormScreen> createState() => _AdminArticleFormScreenState();
}

class _AdminArticleFormScreenState extends State<AdminArticleFormScreen> {
  final _api = ApiClient();
  bool _loading = true;
  bool _saving = false;
  String? _error;

  final _skuController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockQtyController = TextEditingController();
  String _category = 'ledStrips';
  String? _supplierId;
  L10nText _name = L10nText.empty;
  L10nText _shortDescription = L10nText.empty;
  L10nText _description = L10nText.empty;
  List<_SpecRow> _specs = [];
  bool _publiclyVisible = true;
  String _stockMode = 'stock';
  bool _discontinued = false;

  List<Map<String, dynamic>> _suppliers = [];

  bool get _isEdit => widget.articleId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _skuController.dispose();
    _priceController.dispose();
    _stockQtyController.dispose();
    super.dispose();
  }

  String? get _token => context.read<AdminAuthProvider>().token;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final suppliersRaw =
          await _api.get('/api/admin/suppliers', token: _token) as List<dynamic>;
      _suppliers = suppliersRaw.cast<Map<String, dynamic>>();
      if (_isEdit) {
        final json = await _api.get('/api/admin/articles/${widget.articleId}',
            token: _token) as Map<String, dynamic>;
        _skuController.text = json['sku'] as String;
        _priceController.text = (json['priceSek'] as num).toString();
        _category = json['category'] as String;
        _supplierId = json['supplierId'] as String;
        _name = L10nText.fromJson(json['name'] as Map<String, dynamic>);
        _shortDescription =
            L10nText.fromJson(json['shortDescription'] as Map<String, dynamic>);
        _description = L10nText.fromJson(json['description'] as Map<String, dynamic>);
        _specs = (json['specs'] as List<dynamic>)
            .map((s) => _SpecRow((s as Map<String, dynamic>)['key'] as String,
                s['value'] as String))
            .toList();
        _publiclyVisible = json['publiclyVisible'] as bool;
        _stockMode = json['stockMode'] as String;
        _stockQtyController.text = (json['stockQuantity'] as num?)?.toString() ?? '';
        _discontinued = json['discontinued'] as bool;
      } else if (_suppliers.isNotEmpty) {
        _supplierId = _suppliers.first['id'] as String;
      }
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Kunde inte hämta artikeln.';
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (_supplierId == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final body = {
      'sku': _skuController.text.trim(),
      'supplierId': _supplierId,
      'category': _category,
      'name': _name.toJson(),
      'shortDescription': _shortDescription.toJson(),
      'description': _description.toJson(),
      'specs': _specs
          .where((s) => s.key.isNotEmpty)
          .map((s) => {'key': s.key, 'value': s.value})
          .toList(),
      'priceSek': int.tryParse(_priceController.text.trim()) ?? 0,
      'publiclyVisible': _publiclyVisible,
      'stockMode': _stockMode,
      'stockQuantity':
          _stockMode == 'stock' ? int.tryParse(_stockQtyController.text.trim()) ?? 0 : null,
      'discontinued': _discontinued,
    };
    try {
      if (_isEdit) {
        await _api.put('/api/admin/articles/${widget.articleId}',
            token: _token, body: body);
      } else {
        await _api.post('/api/admin/articles', token: _token, body: body);
      }
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Kunde inte spara artikeln.');
    }
    setState(() => _saving = false);
  }

  Future<void> _discontinue() async {
    try {
      await _api.post('/api/admin/articles/${widget.articleId}/discontinue',
          token: _token);
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      section: AdminSection.articles,
      title: _isEdit ? 'Redigera artikel' : 'Ny artikel',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_error != null) ...[
                      Text(_error!, style: const TextStyle(color: AppColors.danger)),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _skuController,
                            decoration: const InputDecoration(labelText: 'SKU'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Pris (SEK)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _category,
                            decoration: const InputDecoration(labelText: 'Kategori'),
                            items: _categoryLabels.entries
                                .map((e) =>
                                    DropdownMenuItem(value: e.key, child: Text(e.value)))
                                .toList(),
                            onChanged: (v) => setState(() => _category = v!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _supplierId,
                            decoration: const InputDecoration(labelText: 'Leverantör'),
                            items: _suppliers
                                .map((s) => DropdownMenuItem(
                                    value: s['id'] as String,
                                    child: Text(s['name'] as String)))
                                .toList(),
                            onChanged: (v) => setState(() => _supplierId = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Namn', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    L10nTextField(value: _name, onChanged: (v) => setState(() => _name = v)),
                    const SizedBox(height: 16),
                    const Text('Kort beskrivning', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    L10nTextField(
                        value: _shortDescription,
                        onChanged: (v) => setState(() => _shortDescription = v)),
                    const SizedBox(height: 16),
                    const Text('Beskrivning', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    L10nTextField(
                        value: _description,
                        multiline: true,
                        onChanged: (v) => setState(() => _description = v)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text('Specifikationer',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () =>
                              setState(() => _specs = [..._specs, _SpecRow('length', '')]),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Lägg till'),
                        ),
                      ],
                    ),
                    for (int i = 0; i < _specs.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _specs[i].key,
                                isDense: true,
                                items: _specKeyLabels.entries
                                    .map((e) => DropdownMenuItem(
                                        value: e.key, child: Text(e.value)))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _specs[i].key = v ?? _specs[i].key),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                initialValue: _specs[i].value,
                                decoration: const InputDecoration(labelText: 'Värde', isDense: true),
                                onChanged: (v) => _specs[i].value = v,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () => setState(() {
                                _specs = [..._specs]..removeAt(i);
                              }),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Switch(
                          value: _publiclyVisible,
                          onChanged: (v) => setState(() => _publiclyVisible = v),
                        ),
                        const Text('Visas publikt i butiken'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Lagerstatus', style: TextStyle(fontWeight: FontWeight.w600)),
                    RadioListTile<String>(
                      value: 'stock',
                      groupValue: _stockMode,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('I lager (ange antal)'),
                      onChanged: (v) => setState(() => _stockMode = v!),
                    ),
                    if (_stockMode == 'stock')
                      Padding(
                        padding: const EdgeInsets.only(left: 32, bottom: 8),
                        child: SizedBox(
                          width: 160,
                          child: TextFormField(
                            controller: _stockQtyController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Antal i lager'),
                          ),
                        ),
                      ),
                    RadioListTile<String>(
                      value: 'onDemand',
                      groupValue: _stockMode,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                          'Beställs från leverantör vid behov (leveranstid sätts på leverantören)'),
                      onChanged: (v) => setState(() => _stockMode = v!),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _saving ? null : _save,
                          child: _saving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: AppColors.white),
                                )
                              : const Text('Spara'),
                        ),
                        if (_isEdit && !_discontinued) ...[
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: _discontinue,
                            style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
                            child: const Text('Markera som utgått'),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
