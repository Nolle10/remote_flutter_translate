import 'package:flutter/widgets.dart';

/// Returns the current device locale
Locale? getCurrentLocale() {
  WidgetsFlutterBinding.ensureInitialized();
  return WidgetsBinding.instance.platformDispatcher.locale;
}
