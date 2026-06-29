import 'package:batik_scanner_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows missing Supabase config screen without dart defines', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: BatikQuestRoot()));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('BatikQuest needs Supabase keys'), findsOneWidget);
  });
}
