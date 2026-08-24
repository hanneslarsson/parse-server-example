import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_auth_provider.dart';
import '../../services/api_client.dart';
import '../../theme/app_theme.dart';
import '../widgets/admin_shell.dart';

class AdminSupplierFormScreen extends StatefulWidget {
  final String? supplierId;

  const AdminSupplierFormScreen({super.key, this.supplierId});

  @override
  State<AdminSupplierFormScreen> createState() => _AdminSupplierFormScreenState();
}

class _AdminSupplierFormScreenState extends State<AdminSupplierFormScreen> {
  final _api = ApiClient();
  bool _loading = true;
  bool _saving = false;
  String? _error;
  bool _removed = false;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _orderMethodController = TextEditingController();
  final _leadTimeController = TextEditingController(text: '5');
  bool _active = true;

  bool get _isEdit => widget.supplierId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _load();
    } else {
      _loading = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _orderMethodController.dispose();
    _leadTimeController.dispose();
    super.dispose();
  }

  String? get _token => context.read<AdminAuthProvider>().token;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final json = await _api.get('/api/admin/suppliers/${widget.supplierId}',
          token: _token) as Map<String, dynamic>;
      _nameController.text = json['name'] as String;
      _addressController.text = json['address'] as String;
      _contactController.text = json['contactPerson'] as String;
      _orderMethodController.text = json['orderMethod'] as String;
      _leadTimeController.text = (json['leadTimeDays'] as num).toString();
      _active = json['active'] as bool;
      _removed = json['removed'] as bool;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Kunde inte hämta leverantören.';
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    final body = {
      'name': _nameController.text.trim(),
      'address': _addressController.text.trim(),
      'contactPerson': _contactController.text.trim(),
      'orderMethod': _orderMethodController.text.trim(),
      'leadTimeDays': int.tryParse(_leadTimeController.text.trim()) ?? 0,
      'active': _active,
    };
    try {
      if (_isEdit) {
        await _api.put('/api/admin/suppliers/${widget.supplierId}',
            token: _token, body: body);
      } else {
        await _api.post('/api/admin/suppliers', token: _token, body: body);
      }
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'Kunde inte spara leverantören.');
    }
    setState(() => _saving = false);
  }

  Future<void> _remove() async {
    try {
      await _api.post('/api/admin/suppliers/${widget.supplierId}/remove',
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
      section: AdminSection.suppliers,
      title: _isEdit ? 'Redigera leverantör' : 'Ny leverantör',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_error != null) ...[
                      Text(_error!, style: const TextStyle(color: AppColors.danger)),
                      const SizedBox(height: 12),
                    ],
                    if (_removed) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.fog,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Denna leverantör är borttagen. Dess artiklar visas inte i butiken.',
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Namn'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Adress'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contactController,
                      decoration: const InputDecoration(labelText: 'Kontaktperson'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _orderMethodController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                          labelText: 'Hur man beställer från leverantören'),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 220,
                      child: TextFormField(
                        controller: _leadTimeController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Antal dagar en beställning tar'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Switch(value: _active, onChanged: (v) => setState(() => _active = v)),
                        const Text('Aktiv (annars döljs leverantörens artiklar i butiken)'),
                      ],
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
                        if (_isEdit && !_removed) ...[
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: _remove,
                            style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger),
                            child: const Text('Ta bort leverantör'),
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
