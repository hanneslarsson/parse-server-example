import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/luma_logo.dart';

enum AdminSection { settings, orders, articles, suppliers, users }

class _NavEntry {
  final AdminSection section;
  final String label;
  final IconData icon;
  final String route;

  const _NavEntry(this.section, this.label, this.icon, this.route);
}

const _navEntries = [
  _NavEntry(AdminSection.settings, 'Inställningar', Icons.tune_rounded, '/admin/settings'),
  _NavEntry(AdminSection.orders, 'Ordrar', Icons.receipt_long_outlined, '/admin/orders'),
  _NavEntry(AdminSection.articles, 'Artiklar', Icons.inventory_2_outlined, '/admin/articles'),
  _NavEntry(AdminSection.suppliers, 'Leverantörer', Icons.local_shipping_outlined, '/admin/suppliers'),
  _NavEntry(AdminSection.users, 'Användare', Icons.people_outline_rounded, '/admin/users'),
];

/// Shared chrome for every admin page: a left nav (collapses to a top menu
/// on narrow widths), a header with the signed-in admin's name and a
/// logout button, and a scrollable content area for [body].
class AdminShell extends StatelessWidget {
  final AdminSection section;
  final String title;
  final Widget body;
  final Widget? actions;

  const AdminShell({
    super.key,
    required this.section,
    required this.title,
    required this.body,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 800;
    final auth = context.watch<AdminAuthProvider>();

    final nav = compact
        ? null
        : Container(
            width: 220,
            color: AppColors.navyDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const LumaLogoLockup(color: AppColors.white, markSize: 22),
                ),
                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Admin', style: TextStyle(color: Color(0xFF7C8E98), fontSize: 12)),
                ),
                const SizedBox(height: 24),
                for (final entry in _navEntries)
                  _NavTile(entry: entry, active: entry.section == section),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await context.read<AdminAuthProvider>().logout();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed('/admin/login');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.white,
                      side: const BorderSide(color: Color(0xFF3A5568)),
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Logga ut'),
                  ),
                ),
              ],
            ),
          );

    return Scaffold(
      backgroundColor: AppColors.sand,
      drawer: compact
          ? Drawer(
              child: SafeArea(
                child: ListView(
                  children: [
                    for (final entry in _navEntries)
                      ListTile(
                        leading: Icon(entry.icon),
                        title: Text(entry.label),
                        selected: entry.section == section,
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed(entry.route);
                        },
                      ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout_rounded),
                      title: const Text('Logga ut'),
                      onTap: () async {
                        await context.read<AdminAuthProvider>().logout();
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed('/admin/login');
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Row(
        children: [
          if (nav != null) nav,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      if (compact)
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu_rounded),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      if (actions != null) actions!,
                      const SizedBox(width: 12),
                      if (!compact)
                        Text(
                          auth.adminName ?? auth.adminEmail ?? '',
                          style: const TextStyle(color: AppColors.slate),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final _NavEntry entry;
  final bool active;

  const _NavTile({required this.entry, required this.active});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? const Color(0xFF13405C) : Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pushReplacementNamed(entry.route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Icon(entry.icon, color: AppColors.white, size: 20),
              const SizedBox(width: 12),
              Text(
                entry.label,
                style: const TextStyle(color: AppColors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
