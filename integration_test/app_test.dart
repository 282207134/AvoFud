import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avofud/app.dart';
import 'package:avofud/core/app_state.dart';
import 'package:avofud/data/catalog.dart';
import 'package:avofud/data/local_store.dart';
import 'package:avofud/features/account/account_pages.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Android flow and screenshot gallery', (tester) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('avofud.v1');
    final state = AppState(LocalStore(preferences));
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      AvoFudApp(
        state: state,
        navigatorKey: navigator,
        initialRoute: '/shopping',
      ),
    );
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();

    Future<void> capture(String name) async {
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(Scaffold).last);
      await Future.wait(
        tester
            .widgetList<Image>(find.byType(Image))
            .map((image) => precacheImage(image.image, context)),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await binding.takeScreenshot('_warm-$name');
      await Future<void>.delayed(const Duration(milliseconds: 250));
      await tester.pump(const Duration(milliseconds: 100));
      await binding.takeScreenshot(name);
    }

    // Exercise real UI events before recording the design gallery.
    await tester.tap(find.byKey(const ValueKey('add-combo1')));
    await tester.pumpAndSettle();
    expect(state.total, 24);
    navigator.currentState!.pushNamed('/cart');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check out · \$24.00'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pay out'));
    await tester.pumpAndSettle();
    expect(find.text('Successful Order'), findsOneWidget);
    expect(state.orders.single['total'], 24);
    expect(state.cart, isEmpty);
    final restored = AppState(LocalStore(preferences));
    expect(restored.orders.single['total'], 24);

    await state.add(product('cereal2'));
    await state.add(product('burger'), 2);
    navigator.currentState!.pushNamedAndRemoveUntil('/checkout', (_) => false);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pay out'));
    await tester.pumpAndSettle();
    expect(find.text('Order failed!'), findsOneWidget);
    expect(state.count, 3);
    expect(state.orders.length, 1);
    // Screens are captured from Flutter running on the Android emulator.
    for (final screen in screenCatalog) {
      navigator.currentState!.pushNamedAndRemoveUntil(
        screen.$3,
        (_) => false,
        arguments: screen.$3 == '/splash' ? false : null,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: screen.$2);
      await capture('${screen.$1}-${screen.$3.substring(1)}');
    }
    for (final route in [
      '/cart',
      '/settings',
      '/history',
      '/favorites',
      '/gallery',
    ]) {
      navigator.currentState!.pushNamedAndRemoveUntil(route, (_) => false);
      await tester.pumpAndSettle();
      await capture('extra-${route.substring(1)}');
    }
    await state.setDark(true);
    for (final route in [
      '/home',
      '/shopping',
      '/calendar',
      '/account',
      '/detail',
      '/wallet',
    ]) {
      navigator.currentState!.pushNamedAndRemoveUntil(route, (_) => false);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await capture('dark-${route.substring(1)}');
    }
    await state.setDark(false);
    navigator.currentState!.pushNamedAndRemoveUntil('/home', (_) => false);
    await tester.pumpAndSettle();
  });
}
