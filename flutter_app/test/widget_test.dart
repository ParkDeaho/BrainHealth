import 'package:braintrain_flutter/app/brain_train_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('온보딩 완료 시 하단 내비가 표시된다', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({
      'has_onboarded': true,
      'app_locale': 'ko',
    });

    await tester.pumpWidget(
      const ProviderScope(child: BrainTrainApp()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.home), findsWidgets);
  });
}
