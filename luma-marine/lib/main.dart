import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'admin/screens/admin_articles_screen.dart';
import 'admin/screens/admin_article_form_screen.dart';
import 'admin/screens/admin_guard.dart';
import 'admin/screens/admin_login_screen.dart';
import 'admin/screens/admin_orders_screen.dart';
import 'admin/screens/admin_order_detail_screen.dart';
import 'admin/screens/admin_settings_screen.dart';
import 'admin/screens/admin_suppliers_screen.dart';
import 'admin/screens/admin_supplier_form_screen.dart';
import 'admin/screens/admin_users_screen.dart';
import 'gate/preview_gate.dart';
import 'l10n/app_localizations.dart';
import 'models/product.dart';
import 'providers/admin_auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/catalog_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/cart_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/gate_screen.dart';
import 'screens/guides_screen.dart';
import 'screens/home_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'screens/product_detail_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const LumaMarineApp());
}

class LumaMarineApp extends StatelessWidget {
  const LumaMarineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => PreviewGateState()..restore()),
        ChangeNotifierProvider(create: (_) => CatalogProvider()..load()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()..load()),
        ChangeNotifierProvider(create: (_) => AdminAuthProvider()..restore()),
      ],
      child: Builder(builder: (context) {
        final locale = context.watch<LocaleProvider>().locale;
        return MaterialApp(
          title: 'Luma Marine',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          locale: locale,
          supportedLocales: supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: '/',
          onGenerateRoute: _onGenerateRoute,
          builder: (context, child) {
            final gate = context.watch<PreviewGateState>();
            if (gate.loading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (!gate.unlocked) {
              return const GateScreen();
            }
            return child ?? const SizedBox.shrink();
          },
        );
      }),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/shop':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CatalogScreen(
            initialCategory: settings.arguments as ProductCategory?,
          ),
        );
      case '/guides':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const GuidesScreen(),
        );
      case '/product':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              ProductDetailScreen(productId: settings.arguments as String),
        );
      case '/cart':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CartScreen(),
        );
      case '/checkout':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CheckoutScreen(),
        );
      case '/confirmation':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => OrderConfirmationScreen(
            orderNumber: settings.arguments as String,
          ),
        );

      // --- Admin ---------------------------------------------------------
      case '/admin/login':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AdminLoginScreen(),
        );
      case '/admin':
      case '/admin/settings':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const AdminGuard(child: AdminSettingsScreen()),
        );
      case '/admin/orders':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AdminGuard(child: AdminOrdersScreen()),
        );
      case '/admin/orders/detail':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AdminGuard(
            child: AdminOrderDetailScreen(
              orderId: settings.arguments as String,
            ),
          ),
        );
      case '/admin/articles':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AdminGuard(child: AdminArticlesScreen()),
        );
      case '/admin/articles/new':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AdminGuard(child: AdminArticleFormScreen()),
        );
      case '/admin/articles/edit':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AdminGuard(
            child: AdminArticleFormScreen(
              articleId: settings.arguments as String,
            ),
          ),
        );
      case '/admin/suppliers':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AdminGuard(child: AdminSuppliersScreen()),
        );
      case '/admin/suppliers/new':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AdminGuard(child: AdminSupplierFormScreen()),
        );
      case '/admin/suppliers/edit':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AdminGuard(
            child: AdminSupplierFormScreen(
              supplierId: settings.arguments as String,
            ),
          ),
        );
      case '/admin/users':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AdminGuard(child: AdminUsersScreen()),
        );

      case '/':
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
    }
  }
}
