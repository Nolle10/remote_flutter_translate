import 'package:flutter/widgets.dart';
import 'package:remote_flutter_translate/remote_flutter_translate.dart';

class LocalizedApp extends StatefulWidget
{
    final Widget child;

    final LocalizationDelegate delegate;

    LocalizedApp(this.delegate, this.child);

    LocalizedAppState createState() => LocalizedAppState();

    static LocalizedApp of(BuildContext context) => context.findAncestorWidgetOfExactType<LocalizedApp>()!;
}
