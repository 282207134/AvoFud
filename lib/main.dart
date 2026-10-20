import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/app_state.dart';
import 'data/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState(LocalStore(await SharedPreferences.getInstance()));
  runApp(AvoFudApp(state: state));
}
