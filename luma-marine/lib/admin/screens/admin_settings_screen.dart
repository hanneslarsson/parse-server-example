import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/banner.dart';
import '../../models/l10n_text.dart';
import '../../providers/admin_auth_provider.dart';
import '../../services/api_client.dart';
import '../../theme/app_theme.dart';
import '../widgets/admin_shell.dart';
import '../widgets/l10n_text_field.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _api = ApiClient();
  bool _loading = true;
  String? _error;
  bool _saving = false;
  String? _saveMessage;

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  L10nText _openingHours = L10nText.empty;
  List<SiteBanner> _banners = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? get _token => context.read<AdminAuthProvider>().token;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final json = await _api.get('/api/admin/settings', token: _token)
          as Map<String, dynamic>;
      _emailController.text = json['contactEmail'] as String? ?? '';
      _phoneController.text = json['contactPhone'] as String? ?? '';
      _openingHours = json['openingHours'] != null
          ? L10nText.fromJson(json['openingHours'] as Map<String, dynamic>)
          : L10nText.empty;
      _banners = (json['banners'] as List<dynamic>? ?? [])
          .map((b) => SiteBanner.fromJson(b as Map<String, dynamic>))
          .toList();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Kunde inte hämta inställningar.';
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _saveMessage = null;
    });
    try {
      await _api.put('/api/admin/settings', token: _token, body: {
        'contactEmail': _emailController.text.trim(),
        'contactPhone': _phoneController.text.trim(),
        'openingHours': _openingHours.toJson(),
        'banners': _banners.map((b) => b.toJson()).toList(),
      });
      setState(() => _saveMessage = 'Sparat.');
    } on ApiException catch (e) {
      setState(() => _saveMessage = 'Fel: ${e.message}');
    } catch (_) {
      setState(() => _saveMessage = 'Kunde inte spara.');
    }
    setState(() => _saving = false);
  }

  void _addBanner() {
    setState(() {
      _banners = [
        ..._banners,
        SiteBanner(
          id: 'banner-${DateTime.now().millisecondsSinceEpoch}',
          message: L10nText.empty,
          startDate: null,
          endDate: null,
          active: true,
        ),
      ];
    });
  }

  void _removeBanner(String id) {
    setState(() => _banners = _banners.where((b) => b.id != id).toList());
  }

  void _updateBanner(SiteBanner updated) {
    setState(() {
      _banners = _banners.map((b) => b.id == updated.id ? updated : b).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      section: AdminSection.settings,
      title: 'Inställningar',
      actions: _saveMessage == null
          ? null
          : Text(_saveMessage!, style: const TextStyle(color: AppColors.slate)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionCard(
                          title: 'Kontaktuppgifter för support',
                          children: [
                            TextField(
                              controller: _emailController,
                              decoration:
                                  const InputDecoration(labelText: 'E-post'),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _phoneController,
                              decoration:
                                  const InputDecoration(labelText: 'Telefon'),
                            ),
                            const SizedBox(height: 16),
                            const Text('Öppettider',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            L10nTextField(
                              value: _openingHours,
                              multiline: true,
                              onChanged: (v) => setState(() => _openingHours = v),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _SectionCard(
                          title: 'Banners på startsidan',
                          subtitle:
                              'Texter som visas överst på startsidan under en given tidsperiod. '
                              'Lämna datum tomma för att visa banner tills vidare.',
                          children: [
                            for (final banner in _banners)
                              _BannerEditor(
                                key: ValueKey(banner.id),
                                banner: banner,
                                onChanged: _updateBanner,
                                onRemove: () => _removeBanner(banner.id),
                              ),
                            OutlinedButton.icon(
                              onPressed: _addBanner,
                              icon: const Icon(Icons.add_rounded),
                              label: const Text('Lägg till banner'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _saving ? null : _save,
                          child: _saving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: AppColors.white),
                                )
                              : const Text('Spara ändringar'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const _SectionCard({required this.title, this.subtitle, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fogDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: const TextStyle(color: AppColors.slate, fontSize: 13)),
          ],
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _BannerEditor extends StatelessWidget {
  final SiteBanner banner;
  final ValueChanged<SiteBanner> onChanged;
  final VoidCallback onRemove;

  const _BannerEditor({
    super.key,
    required this.banner,
    required this.onChanged,
    required this.onRemove,
  });

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final initial = DateTime.tryParse(
            (isStart ? banner.startDate : banner.endDate) ?? '') ??
        DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    final iso = picked.toIso8601String().split('T').first;
    onChanged(isStart
        ? banner.copyWith(startDate: iso)
        : banner.copyWith(endDate: iso));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.fog.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Switch(
                      value: banner.active,
                      onChanged: (v) => onChanged(banner.copyWith(active: v)),
                    ),
                    Text(banner.active ? 'Aktiv' : 'Inaktiv'),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: onRemove,
              ),
            ],
          ),
          L10nTextField(
            value: banner.message,
            multiline: true,
            onChanged: (v) => onChanged(banner.copyWith(message: v)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickDate(context, true),
                  child: Text(banner.startDate == null
                      ? 'Startdatum: alltid'
                      : 'Från: ${banner.startDate}'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickDate(context, false),
                  child: Text(banner.endDate == null
                      ? 'Slutdatum: alltid'
                      : 'Till: ${banner.endDate}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
