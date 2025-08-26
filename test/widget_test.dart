import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:interdimensional_cable_registry/app_module.dart';
import 'package:interdimensional_cable_registry/app_widget.dart';

void main() {
  testWidgets('App should initialize without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      ModularApp(
        module: AppModule(),
        child: const AppWidget(),
      ),
    );

    // Verify that the app loads without throwing exceptions
    expect(tester.takeException(), isNull);

    // The app should display something (not be completely empty)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}