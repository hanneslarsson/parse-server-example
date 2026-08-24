import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_auth_provider.dart';
import '../../services/api_client.dart';
import '../../theme/app_theme.dart';
import '../widgets/admin_shell.dart';

class AdminSuppliersScreen extends StatefulWidget {
  const AdminSuppliersScreen({super.key});

  @override
  State<AdminSuppliersScreen> createState() => _AdminSuppliersScreenState();
}

class _AdminSuppliersScreenState extends State<AdminSuppliersScreen> {
  final _api = ApiClient();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _suppliers = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  String? get _token => context.read<AdminAuthProvider>().token;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final raw = await _api.get('/api/admin/suppliers?includeRemoved=true',
          token: _token) as List<dynamic>;
      _suppliers = raw.cast<Map<String, dynamic>>();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Kunde inte hämta leverantörer.';
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      section: AdminSection.suppliers,
      title: 'Leverantörer',
      actions: ElevatedButton.icon(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/admin/suppliers/new');
          _load();
        },
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('Ny leverantör'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _suppliers.length,
                  itemBuilder: (context, i) {
                    final supplier = _suppliers[i];
                    final removed = supplier['removed'] as bool;
                    final active = supplier['active'] as bool;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        onTap: () async {
                          await Navigator.of(context).pushNamed(
                            '/admin/suppliers/edit',
                            arguments: supplier['id'] as String,
                          );
                          _load();
                        },
                        title: Text(supplier['name'] as String),
                        subtitle: Text(
                          '${supplier['contactPerson']} · ${supplier['leadTimeDays']} dagars leveranstid',
                        ),
                        trailing: Chip(
                          label: Text(removed ? 'Borttagen' : (active ? 'Aktiv' : 'Inaktiv')),
                          backgroundColor: removed
                              ? AppColors.fog
                              : active
                                  ? AppColors.seafoam.withValues(alpha: 0.2)
                                  : AppColors.fog,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
