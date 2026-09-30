import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:iee_project/main.dart';

void main() {
  testWidgets('App renders injected test home without Firebase', (WidgetTester tester) async {
    await tester.pumpWidget(
      const SprayerApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Solar Pesticide Sprayer')),
          body: Center(child: Text('Telemetry Dashboard')),
        ),
      ),
    );

    expect(find.text('Solar Pesticide Sprayer'), findsOneWidget);
    expect(find.text('Telemetry Dashboard'), findsOneWidget);
  });
}
