import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../internacionalization/app_language.dart';
import '../../ui/components/my_dialog.dart';
import '../../utils/color_palette.dart';
import '../../utils/preferences.dart';
import '../../providers/table_provider.dart';

class LogoutDialog extends StatefulWidget {
  LogoutDialog();

  @override
  _CallWaiterDialogState createState() => _CallWaiterDialogState();
}

class _CallWaiterDialogState extends State<LogoutDialog> {
  Color buttonColor = ColorPalette.gray;

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context);

    return MyDialog(
      width: 480,
      height: 145,
      child: child(context, lang),
    );
  }

  Widget child(BuildContext context, AppLanguage lang) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 460,
              child: Text(
                lang.w(Word.logout_warning),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "TimesBold",
                    fontSize: 30,
                    color: ColorPalette.gray),
              ),
            ),SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 173,
                    offset: Offset(0, 9),
                    color: ColorPalette.gray.withOpacity(0.4))
              ]),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FlatButton(

                  highlightColor: ColorPalette.melon,
                  color: Colors.white,
                  child: Text(
                    lang.w(Word.yes),
                    style: TextStyle(fontFamily: "SofiaProBold", fontSize: 17, color: buttonColor),
                  ),
                  onPressed: () {

                    final preferences = Provider.of<Preferences>(context);
                    preferences.session = null;

                    Navigator.pushNamedAndRemoveUntil(
                        context, "/", ModalRoute.withName('/'));

                  },
                ),
              ),
            ),
          ],
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                "assets/home_icons/close.png",
                width: 31,
                height: 31,
              ),
            ),
          ),
          alignment: Alignment.topRight,
        ),
      ],
    );
  }
  @override
  void initState() {
    super.initState();
  }
}
