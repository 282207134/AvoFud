import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avofud/app.dart';
import 'package:avofud/core/app_state.dart';
import 'package:avofud/data/catalog.dart';
import 'package:avofud/data/local_store.dart';
import 'package:avofud/features/account/account_pages.dart';

Future<void> settleImages(WidgetTester tester) async {
  final context = tester.element(find.byType(Scaffold).last);
  final providers = tester
      .widgetList<Image>(find.byType(Image))
      .map((image) => image.image)
      .toList();
  await tester.runAsync(
    () => Future.wait(
      providers.map((provider) => precacheImage(provider, context)),
    ),
  );
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('Nunito');
    for (final weight in [400, 700, 800]) {
      font.addFont(rootBundle.load('assets/fonts/Nunito-$weight.ttf'));
    }
    await font.load();
  });
  for (final size in [const Size(375, 812), const Size(320, 640)]) {
    for (final screen in screenCatalog) {
      testWidgets('${screen.$1} ${screen.$2} lays out at ${size.width}', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        SharedPreferences.setMockInitialValues({});
        final state = AppState(
          LocalStore(await SharedPreferences.getInstance()),
        );
        await state.add(product('combo1'));
        await tester.pumpWidget(
          AvoFudApp(state: state, initialRoute: screen.$3),
          phase: EnginePhase.layout,
        );
        await tester.pump(
          const Duration(milliseconds: 400),
          EnginePhase.layout,
        );
        expect(
          tester.takeException(),
          isNull,
          reason: '${screen.$1} ${screen.$2}',
        );
        await tester.pumpWidget(
          const SizedBox.shrink(),
          phase: EnginePhase.layout,
        );
      });
    }
  }
  testWidgets('dark screens render without layout errors', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final state = AppState(LocalStore(await SharedPreferences.getInstance()));
    await state.setDark(true);
    for (final screen in screenCatalog) {
      await tester.pumpWidget(
        const SizedBox.shrink(),
        phase: EnginePhase.layout,
      );
      await tester.pumpWidget(
        AvoFudApp(state: state, initialRoute: screen.$3),
        phase: EnginePhase.layout,
      );
      await tester.pump(const Duration(milliseconds: 400), EnginePhase.layout);
      expect(tester.takeException(), isNull, reason: 'Dark ${screen.$2}');
    }
    await tester.pumpWidget(const SizedBox.shrink(), phase: EnginePhase.layout);
  });
  testWidgets('sign in validates before allowing navigation', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(LocalStore(await SharedPreferences.getInstance()));
    await tester.pumpWidget(AvoFudApp(state: state, initialRoute: '/signin'));
    await settleImages(tester);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email or phone'), findsOneWidget);
    expect(state.signedIn, false);
    await tester.enterText(
      find.byKey(const ValueKey('email')),
      'avo@example.com',
    );
    await tester.enterText(find.byKey(const ValueKey('password')), 'demo123');
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(state.signedIn, true);
    expect(find.text('Hi, Avo'), findsOneWidget);
  });
}
