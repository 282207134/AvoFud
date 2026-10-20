import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  LocalStore(this.preferences);
  final SharedPreferences preferences;
  Map<String, dynamic> read() {
    try {
      return jsonDecode(preferences.getString('avofud.v1') ?? '{}')
          as Map<String, dynamic>;
    } on FormatException {
      return {};
    } on TypeError {
      return {};
    }
  }

  Future<void> write(Map<String, dynamic> state) async {
    await preferences.setString('avofud.v1', jsonEncode(state));
  }
}
