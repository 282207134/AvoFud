import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../data/local_store.dart';

class AppState extends ChangeNotifier {
  AppState(this.store) {
    final data = store.read();
    dark = data['dark'] == true;
    signedIn = data['signedIn'] == true;
    language = data['language'] as String? ?? 'English';
    address =
        data['address'] as String? ??
        '886 Pinewood Avenue,\nMarquette, Michigan';
    cardHolder = data['cardHolder'] as String? ?? 'Avo Ankar';
    cardLimit = data['cardLimit'] as String? ?? '\$1,000';
    favorites.addAll((data['favorites'] as List? ?? []).whereType<String>());
    final savedCart = data['cart'];
    if (savedCart is Map) {
      for (final entry in savedCart.entries) {
        final id = entry.key as String;
        final count = entry.value;
        if (count is int &&
            count > 0 &&
            catalog.any((p) => p.id == id.split('|').first)) {
          cart[id] = count;
        }
      }
    }
    orders.addAll(
      (data['orders'] as List? ?? []).whereType<Map>().map(
        (e) => Map<String, dynamic>.from(e),
      ),
    );
  }
  final LocalStore store;
  bool dark = false, signedIn = false;
  String language = 'English', address = '', cardHolder = '', cardLimit = '';
  final Map<String, int> cart = {};
  final Set<String> favorites = {};
  final List<Map<String, dynamic>> orders = [];
  int get count => cart.values.fold(0, (a, b) => a + b);
  double get total =>
      cart.entries.fold(0, (sum, e) => sum + product(e.key).price * e.value);

  Future<void> _save() async {
    notifyListeners();
    await store.write({
      'dark': dark,
      'signedIn': signedIn,
      'language': language,
      'address': address,
      'cardHolder': cardHolder,
      'cardLimit': cardLimit,
      'favorites': favorites.toList(),
      'cart': cart,
      'orders': orders,
    });
  }

  Future<void> add(Product p, [int quantity = 1, String? option]) async {
    if (quantity <= 0) return;
    final key = option == null ? p.id : '${p.id}|$option';
    cart[key] = (cart[key] ?? 0) + quantity;
    await _save();
  }

  Future<void> changeQuantity(String id, int delta) async {
    final next = (cart[id] ?? 0) + delta;
    if (next <= 0) {
      cart.remove(id);
    } else {
      cart[id] = next;
    }
    await _save();
  }

  Future<void> toggleFavorite(String id) async {
    if (!favorites.add(id)) favorites.remove(id);
    await _save();
  }

  Future<void> setDark(bool value) async {
    dark = value;
    await _save();
  }

  Future<void> setLanguage(String value) async {
    language = value;
    await _save();
  }

  Future<void> signIn(bool value) async {
    signedIn = value;
    await _save();
  }

  Future<void> updateAddress(String value) async {
    address = value.trim();
    await _save();
  }

  Future<void> createCard(String holder, String limit) async {
    cardHolder = holder.trim();
    cardLimit = limit;
    await _save();
  }

  Future<bool> checkout({bool simulateFailure = false}) async {
    if (cart.isEmpty || simulateFailure) return false;
    orders.insert(0, {
      'id': 2101 + orders.length,
      'total': total,
      'items': Map<String, int>.from(cart),
      'date': DateTime.now().toIso8601String(),
    });
    cart.clear();
    await _save();
    return true;
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);
  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
