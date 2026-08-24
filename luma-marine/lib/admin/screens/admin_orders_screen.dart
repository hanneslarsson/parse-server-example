import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_auth_provider.dart';
import '../../services/api_client.dart';
import '../../theme/app_theme.dart';
import '../widgets/admin_shell.dart';

const _statusLabels = {
  'new': 'Ny',
  'processing': 'Under hantering',
  'shipped': 'Skickad',
  'cancelled': 'Avbruten',
};

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final _api = ApiClient();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _orders = [];
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final token = context.read<AdminAuthProvider>().token;
    try {
      final query = _statusFilter == null ? '' : '?status=$_statusFilter';
      final raw = await _api.get('/api/admin/orders$query', token: token)
          as List<dynamic>;
      _orders = raw.cast<Map<String, dynamic>>();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Kunde inte hämta ordrar.';
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      section: AdminSection.orders,
      title: 'Ordrar',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Alla'),
                  selected: _statusFilter == null,
                  onSelected: (_) {
                    setState(() => _statusFilter = null);
                    _load();
                  },
                ),
                for (final entry in _statusLabels.entries)
                  ChoiceChip(
                    label: Text(entry.value),
                    selected: _statusFilter == entry.key,
                    onSelected: (_) {
                      setState(() => _statusFilter = entry.key);
                      _load();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!))
                      : _orders.isEmpty
                          ? const Center(child: Text('Inga ordrar hittades.'))
                          : ListView.separated(
                              itemCount: _orders.length,
                              separatorBuilder: (_, _) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final order = _orders[index];
                                final customer =
                                    order['customer'] as Map<String, dynamic>;
                                final items = order['items'] as List<dynamic>;
                                final itemCount = items.fold<int>(
                                    0, (sum, i) => sum + (i['quantity'] as int));
                                return Card(
                                  child: ListTile(
                                    onTap: () => Navigator.of(context).pushNamed(
                                      '/admin/orders/detail',
                                      arguments: order['id'] as String,
                                    ),
                                    title: Text(
                                      '${order['orderNumber']} — ${customer['firstName']} ${customer['lastName']}',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      '${(order['createdAt'] as String).substring(0, 16).replaceFirst('T', ' ')} · $itemCount artiklar · ${order['subtotalSek']} kr',
                                    ),
                                    trailing: Chip(
                                      label: Text(
                                          _statusLabels[order['status']] ?? order['status']),
                                      backgroundColor: AppColors.fog,
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
