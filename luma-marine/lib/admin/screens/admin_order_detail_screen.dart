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

class AdminOrderDetailScreen extends StatefulWidget {
  final String orderId;

  const AdminOrderDetailScreen({super.key, required this.orderId});

  @override
  State<AdminOrderDetailScreen> createState() => _AdminOrderDetailScreenState();
}

class _AdminOrderDetailScreenState extends State<AdminOrderDetailScreen> {
  final _api = ApiClient();
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _order;
  bool _updatingStatus = false;

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
      _order = await _api.get('/api/admin/orders/${widget.orderId}',
          token: _token) as Map<String, dynamic>;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Kunde inte hämta ordern.';
    }
    setState(() => _loading = false);
  }

  Future<void> _setStatus(String status) async {
    setState(() => _updatingStatus = true);
    try {
      _order = await _api.put('/api/admin/orders/${widget.orderId}/status',
          token: _token, body: {'status': status}) as Map<String, dynamic>;
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
    if (mounted) setState(() => _updatingStatus = false);
  }

  Map<String, List<Map<String, dynamic>>> _groupBySupplier(
      List<dynamic> items) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final raw in items) {
      final item = raw as Map<String, dynamic>;
      grouped.putIfAbsent(item['supplierName'] as String, () => []).add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      section: AdminSection.orders,
      title: _order == null ? 'Order' : 'Order ${_order!['orderNumber']}',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _buildContent(_order!),
    );
  }

  Widget _buildContent(Map<String, dynamic> order) {
    final customer = order['customer'] as Map<String, dynamic>;
    final address = order['shippingAddress'] as Map<String, dynamic>;
    final grouped = _groupBySupplier(order['items'] as List<dynamic>);
    final comment = order['comment'] as String?;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  (order['createdAt'] as String).substring(0, 16).replaceFirst('T', ' '),
                  style: const TextStyle(color: AppColors.slate),
                ),
                const Spacer(),
                const Text('Status: '),
                DropdownButton<String>(
                  value: order['status'] as String,
                  onChanged: _updatingStatus
                      ? null
                      : (v) {
                          if (v != null) _setStatus(v);
                        },
                  items: _statusLabels.entries
                      .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _Card(
              title: 'Vem beställde',
              child: Text(
                '${customer['firstName']} ${customer['lastName']}\n${customer['email']}\n${customer['phone']}',
              ),
            ),
            const SizedBox(height: 16),
            _Card(
              title: 'Leveransadress',
              child: Text(
                '${address['address']}\n${address['postalCode']} ${address['city']}\n${address['country']}',
              ),
            ),
            if (comment != null && comment.isNotEmpty) ...[
              const SizedBox(height: 16),
              _Card(title: 'Kommentar', child: Text(comment)),
            ],
            const SizedBox(height: 16),
            _Card(
              title: 'Artiklar (grupperade per leverantör)',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final entry in grouped.entries) ...[
                    Text(entry.key,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    for (final item in entry.value)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                  '${item['name']['sv']}  (${item['sku']})'),
                            ),
                            Text('× ${item['quantity']}'),
                            const SizedBox(width: 16),
                            Text('${item['unitPriceSek']} kr'),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Summa: ', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('${order['subtotalSek']} kr',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fogDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
