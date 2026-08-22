import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'gate/preview_gate.dart';
import 'l10n/app_localizations.dart';
import 'models/product.dart';
import 'providers/cart_provider.dart';
import 'providers/locale_provider.dart';
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
      case '/':
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
    }
  }
}
