import 'package:flutter/widgets.dart';
import '../i18n//strings/strings.dart';

class R {
  static Translations strings = PtBr();

  static void load(Locale locale) {
    switch (locale.toString()) {
      default:
        strings = PtBr();
        break;
    }
  }
}
