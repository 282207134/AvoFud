import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avofud/core/app_state.dart';
import 'package:avofud/data/catalog.dart';
import 'package:avofud/data/local_store.dart';

void main() {
  late LocalStore store;
  late AppState state;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = LocalStore(await SharedPreferences.getInstance());
    state = AppState(store);
  });
  test('cart totals, decrement and removal are consistent', () async {
    await state.add(product('combo1'), 2);
    await state.add(product('burger'));
    expect(state.count, 3);
    expect(state.total, 58);
    await state.changeQuantity('combo1', -1);
    expect(state.total, 34);
    await state.changeQuantity('burger', -1);
    expect(state.cart.containsKey('burger'), false);
    expect(state.total, 24);
  });
  test(
    'failed payment preserves cart, success records a stable snapshot',
    () async {
      await state.add(product('combo2'), 2);
      expect(await state.checkout(simulateFailure: true), false);
      expect(state.count, 2);
      expect(state.orders, isEmpty);
      expect(await state.checkout(), true);
      expect(state.cart, isEmpty);
      expect(state.orders.single['total'], 40);
      expect(state.orders.single['items'], {'combo2': 2});
      await state.add(product('tea'));
      expect(state.orders.single['items'], {'combo2': 2});
      expect(await AppState(store).checkout(), true);
      expect(AppState(store).orders.length, 2);
    },
  );
  test('empty checkout cannot create an order', () async {
    expect(await state.checkout(), false);
    expect(state.orders, isEmpty);
  });
  test('sizes remain separate and survive persistence', () async {
    await state.add(product('burger'), 1, 'Small');
    await state.add(product('burger'), 2, 'Large');
    expect(state.cart, {'burger|Small': 1, 'burger|Large': 2});
    expect(state.total, 30);
    final restored = AppState(store);
    expect(restored.cart.length, 2);
    await restored.changeQuantity('burger|Small', -1);
    expect(restored.cart, {'burger|Large': 2});
    expect(restored.total, 20);
  });
  test('preferences, favorites, address and card survive reload', () async {
    await state.toggleFavorite('yogurt');
    await state.setDark(true);
    await state.setLanguage('Chinese');
    await state.signIn(true);
    await state.createCard('Avo Tester', '\$500');
    await state.updateAddress('123 Test Street, Tokyo');
    await state.add(product('banana'), 3);
    final restored = AppState(store);
    expect(restored.dark, true);
    expect(restored.language, 'Chinese');
    expect(restored.signedIn, true);
    expect(restored.favorites, {'yogurt'});
    expect(restored.cardHolder, 'Avo Tester');
    expect(restored.cardLimit, '\$500');
    expect(restored.address, '123 Test Street, Tokyo');
    expect(restored.count, 3);
  });
  test('malformed saved JSON falls back to a clean state', () async {
    await store.preferences.setString('avofud.v1', '{broken');
    expect(AppState(store).cart, isEmpty);
  });
}
