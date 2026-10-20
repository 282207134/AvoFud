import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() => integrationDriver(
  onScreenshot: (name, bytes, [args]) async {
    if (name.startsWith('_warm-')) return true;
    final file = File('docs/screenshots/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes);
    return true;
  },
);
