import 'package:flutter/cupertino.dart';

import 'en.dart';
import 'es.dart';
import 'word.dart';
export 'word.dart';

class AppLanguage extends ChangeNotifier {


  Locale _locale = Locale("es");

  static AppLanguage of(BuildContext context) {
    return Localizations.of<AppLanguage>(context, AppLanguage);
  }

  Locale get locale {
    return _locale;
  }

  set locale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  set firsLocale(Locale locale) {
    _locale = locale;
  }


  static Map<String, LanguageStruct> _localizedValues = {
    'en': en,
    'es': es
  };
  String getWord(Word word) {
    return _localizedValues[locale.languageCode](word);
  }
  String w(Word word, {WordEdit edit}) {
    if(edit != null){
      return edit(getWord(word));
    }
    return getWord(word);
  }
}
typedef WordEdit = String Function(String string);

typedef LanguageStruct = String Function(Word word);


