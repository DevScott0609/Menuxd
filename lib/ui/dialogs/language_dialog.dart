import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../internacionalization/app_language.dart';
import '../../utils/color_palette.dart';
import '../../utils/preferences.dart';

class LanguageDialog extends StatefulWidget {
  final BuildContext context;
  LanguageDialog(this.context);

  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  String languageSelected = "Español";

  @override
  void initState() {
    super.initState();
    languageSelected = Provider.of<AppLanguage>(widget.context, listen: false)
        .locale
        .languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Transform.translate(
        offset: Offset(5, 25),
        child: Container(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Image.asset(
                  "assets/dialogs/triangle.png",
                  height: 8,
                ),
              ),
              Card(
                margin: const EdgeInsets.only(right: 120),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      LanguageWidget(
                        value: "es",
                        title: "Español",
                        languageValue: languageSelected,
                        onPressed: () {
                          onSelect(context, "es");
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      LanguageWidget(
                        value: "en",
                        title: "English",
                        languageValue: languageSelected,
                        onPressed: () {
                          onSelect(context, "en");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSelect(BuildContext context, String value) {
    Navigator.maybePop(context);
    Provider.of<AppLanguage>(context, listen: false).locale = Locale(value);
    Provider.of<Preferences>(context, listen: false).language = value;
  }
}

class LanguageWidget extends StatelessWidget {
  LanguageWidget({this.value, this.languageValue, this.onPressed, this.title});

  final String value;
  final String title;
  final String languageValue;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final selected = languageValue == value;
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: selected ? Color(0xfffa456f) : Color(0xff555f69)),
          ),
          Expanded(
            child: SizedBox(),
          ),
          if (selected)
            Text(
              String.fromCharCode(0xe5ca),
              style: TextStyle(
                  fontFamily: 'MaterialIcons',
                  color: ColorPalette.melon,
                  fontSize: 35,
                  fontWeight: FontWeight.w900),
            ),
        ],
      ),
    );
  }
}
