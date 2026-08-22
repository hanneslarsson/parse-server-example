import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luma_marine/main.dart';

void main() {
  testWidgets('Preview gate blocks the storefront until unlocked',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const LumaMarineApp());
    await tester.pump();
    await tester.pump();

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Luma Marine'), findsOneWidget);
  });
}
