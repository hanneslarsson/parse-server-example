import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/admin_auth_provider.dart';
import '../../services/api_client.dart';
import '../../theme/app_theme.dart';
import '../widgets/admin_shell.dart';

const _categoryLabels = {
  'ledStrips': 'LED-remsor',
  'navigation': 'Navigationsljus',
  'deckInterior': 'Däck- & inredningsbelysning',
  'controllers': 'Styrenheter & dimmer',
  'kits': 'Kompletta paket',
};

class AdminArticlesScreen extends StatefulWidget {
  const AdminArticlesScreen({super.key});

  @override
  State<AdminArticlesScreen> createState() => _AdminArticlesScreenState();
}

class _AdminArticlesScreenState extends State<AdminArticlesScreen> {
  final _api = ApiClient();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _articles = [];
  List<Map<String, dynamic>> _suppliers = [];
  String _query = '';
  String? _categoryFilter;
  String? _supplierFilter;
  bool _groupBySupplier = false;

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
      final results = await Future.wait([
        _api.get('/api/admin/articles', token: _token),
        _api.get('/api/admin/suppliers?includeRemoved=true', token: _token),
      ]);
      _articles = (results[0] as List<dynamic>).cast<Map<String, dynamic>>();
      _suppliers = (results[1] as List<dynamic>).cast<Map<String, dynamic>>();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Kunde inte hämta artiklar.';
    }
    setState(() => _loading = false);
  }

  String _supplierName(String id) {
    final match = _suppliers.where((s) => s['id'] == id);
    return match.isEmpty ? id : match.first['name'] as String;
  }

  List<Map<String, dynamic>> get _filtered {
    return _articles.where((a) {
      if (_categoryFilter != null && a['category'] != _categoryFilter) return false;
      if (_supplierFilter != null && a['supplierId'] != _supplierFilter) return false;
      if (_query.trim().isNotEmpty) {
        final needle = _query.trim().toLowerCase();
        final name = (a['name'] as Map<String, dynamic>)['sv'] as String? ?? '';
        final sku = a['sku'] as String? ?? '';
        if (!name.toLowerCase().contains(needle) &&
            !sku.toLowerCase().contains(needle)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    if (_groupBySupplier) {
      for (final article in filtered) {
        grouped
            .putIfAbsent(_supplierName(article['supplierId'] as String), () => [])
            .add(article);
      }
    }

    return AdminShell(
      section: AdminSection.articles,
      title: 'Artiklar',
      actions: ElevatedButton.icon(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/admin/articles/new');
          _load();
        },
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text('Ny artikel'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: 'Sök på namn eller SKU...',
                                prefixIcon: Icon(Icons.search_rounded),
                              ),
                              onChanged: (v) => setState(() => _query = v),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilterChip(
                            label: const Text('Gruppera per leverantör'),
                            selected: _groupBySupplier,
                            onSelected: (v) => setState(() => _groupBySupplier = v),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Alla kategorier'),
                            selected: _categoryFilter == null,
                            onSelected: (_) => setState(() => _categoryFilter = null),
                          ),
                          for (final entry in _categoryLabels.entries)
                            ChoiceChip(
                              label: Text(entry.value),
                              selected: _categoryFilter == entry.key,
                              onSelected: (_) => setState(
                                  () => _categoryFilter = _categoryFilter == entry.key ? null : entry.key),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Alla leverantörer'),
                            selected: _supplierFilter == null,
                            onSelected: (_) => setState(() => _supplierFilter = null),
                          ),
                          for (final supplier in _suppliers)
                            ChoiceChip(
                              label: Text(supplier['name'] as String),
                              selected: _supplierFilter == supplier['id'],
                              onSelected: (_) => setState(() => _supplierFilter =
                                  _supplierFilter == supplier['id'] ? null : supplier['id'] as String),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${filtered.length} artiklar',
                          style: const TextStyle(color: AppColors.slate)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _groupBySupplier
                            ? ListView(
                                children: [
                                  for (final entry in grouped.entries) ...[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Text(entry.key,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700, fontSize: 15)),
                                    ),
                                    for (final article in entry.value)
                                      _ArticleTile(article: article, onTap: () => _openEdit(article)),
                                  ],
                                ],
                              )
                            : ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, i) => _ArticleTile(
                                  article: filtered[i],
                                  onTap: () => _openEdit(filtered[i]),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Future<void> _openEdit(Map<String, dynamic> article) async {
    await Navigator.of(context)
        .pushNamed('/admin/articles/edit', arguments: article['id'] as String);
    _load();
  }
}

class _ArticleTile extends StatelessWidget {
  final Map<String, dynamic> article;
  final VoidCallback onTap;

  const _ArticleTile({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final name = (article['name'] as Map<String, dynamic>)['sv'] as String? ?? '';
    final category = ProductCategory.values.byName(article['category'] as String);
    final discontinued = article['discontinued'] as bool;
    final visible = article['publiclyVisible'] as bool;
    final stockMode = article['stockMode'] as String;
    final stockQty = article['stockQuantity'];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        title: Text('$name  ·  ${article['sku']}'),
        subtitle: Text(
          '${_categoryLabels[category.name]} · ${article['priceSek']} kr · '
          '${stockMode == 'stock' ? 'Lager: ${stockQty ?? 0} st' : 'Beställs från leverantör'}',
        ),
        trailing: Wrap(
          spacing: 6,
          children: [
            if (discontinued)
              const Chip(label: Text('Utgått'), backgroundColor: AppColors.fog)
            else if (!visible)
              const Chip(label: Text('Dold'), backgroundColor: AppColors.fog)
            else
              Chip(
                label: const Text('Synlig'),
                backgroundColor: AppColors.seafoam.withValues(alpha: 0.2),
              ),
          ],
        ),
      ),
    );
  }
}
