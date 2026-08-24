import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_auth_provider.dart';
import '../../services/api_client.dart';
import '../../theme/app_theme.dart';
import '../widgets/admin_shell.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _api = ApiClient();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _users = [];

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
      final raw =
          await _api.get('/api/admin/users', token: _token) as List<dynamic>;
      _users = raw.cast<Map<String, dynamic>>();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Kunde inte hämta användare.';
    }
    setState(() => _loading = false);
  }

  Future<void> _toggleActive(Map<String, dynamic> user) async {
    try {
      await _api.put('/api/admin/users/${user['id']}', token: _token, body: {
        'active': !(user['active'] as bool),
      });
      _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _openCreateDialog() async {
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final passwordController = TextEditingController();
    String? error;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Ny admin-användare'),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Namn'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'E-post'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Lösenord (minst 8 tecken)'),
                ),
                if (error != null) ...[
                  const SizedBox(height: 8),
                  Text(error!, style: const TextStyle(color: AppColors.danger)),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Avbryt'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _api.post('/api/admin/users', token: _token, body: {
                    'email': emailController.text.trim(),
                    'name': nameController.text.trim(),
                    'password': passwordController.text,
                  });
                  if (dialogContext.mounted) Navigator.of(dialogContext).pop();
                  _load();
                } on ApiException catch (e) {
                  setDialogState(() => error = e.message);
                } catch (_) {
                  setDialogState(() => error = 'Kunde inte skapa användaren.');
                }
              },
              child: const Text('Skapa'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      section: AdminSection.users,
      title: 'Användare',
      actions: ElevatedButton.icon(
        onPressed: _openCreateDialog,
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('Ny användare'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _users.length,
                  itemBuilder: (context, i) {
                    final user = _users[i];
                    final active = user['active'] as bool;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(user['name'] as String),
                        subtitle: Text(user['email'] as String),
                        trailing: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          children: [
                            Chip(
                              label: Text(active ? 'Aktiv' : 'Inaktiv'),
                              backgroundColor: active
                                  ? AppColors.seafoam.withValues(alpha: 0.2)
                                  : AppColors.fog,
                            ),
                            TextButton(
                              onPressed: () => _toggleActive(user),
                              child: Text(active ? 'Inaktivera' : 'Aktivera'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
