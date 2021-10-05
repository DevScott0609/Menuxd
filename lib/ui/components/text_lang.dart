import 'package:flutter/material.dart';
import '../../internacionalization/app_language.dart';
import '../../internacionalization/word.dart';
import 'package:provider/provider.dart';

class TextLang extends StatelessWidget {
  final Word word;
  final TextStyle style;
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final Locale locale;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final String semanticsLabel;
  final Color color;
  final TextWidthBasis textWidthBasis;

  WordEdit wordEdit;
  TextLang(this.word,
      {this.color,
      this.wordEdit,
      Key key,
      this.style,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      bool removeLastCharacter = false,
      bool addTwoPoints = false})
      : super(key: key) {
    if (removeLastCharacter) {
      this.wordEdit = (value) {
        return value.substring(0, value.length - 1);
      };
    } else if (addTwoPoints) {
      this.wordEdit = (value) {
        return value + ":";
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context);
    final child = Text(
      lang.w(word, edit: wordEdit),
      key: key,
      locale: locale,
      maxLines: maxLines,
      overflow: overflow,
      semanticsLabel: semanticsLabel,
      softWrap: softWrap,
      strutStyle: strutStyle,
      style: style,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
    );
    if (color == null) {
      return child;
    }
    return DefaultTextStyle(
      style: TextStyle(color: color),
      child: child,
    );
  }
}

typedef WordEdit = String Function(String string);
