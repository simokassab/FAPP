import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show SynchronousFuture;
class DemoLocalizations {
  DemoLocalizations(this.locale);
  final Locale locale;
  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'App title',
      'googleLogin': 'Login with Google'
    },
    'es': {
      'title': 'Título de App',
      'googleLogin': 'Conectar con Google'
    },
  };
  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }
  String get googleLogin {
    return _localizedValues[locale.languageCode]['googleLogin'];
  }
}
class DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return new SynchronousFuture<DemoLocalizations>(new DemoLocalizations(locale));
  }
  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}