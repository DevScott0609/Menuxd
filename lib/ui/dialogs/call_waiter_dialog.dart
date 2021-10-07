import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../internacionalization/app_language.dart';
import '../../providers/table_provider.dart';
import '../../ui/components/my_dialog.dart';
import '../../utils/color_palette.dart';
import 'package:provider/provider.dart';

class CallWaiterDialog extends StatefulWidget {
  CallWaiterDialog();

  @override
  _CallWaiterDialogState createState() => _CallWaiterDialogState();
}

class _CallWaiterDialogState extends State<CallWaiterDialog> {
  Color buttonColor = ColorPalette.gray;

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context, listen: false);

    return MyDialog(
      width: 480,
      height: 483,
      child: child(context, lang),
    );
  }

  Widget child(BuildContext context, AppLanguage lang) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/dialogs/waiter.png",
              height: 219,
              width: 221,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 460,
              child: Text(
                lang.w(Word.calling_waiter),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "TimesBold",
                    fontSize: 30,
                    color: ColorPalette.gray),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: SizedBox(
                width: 260,
                child: Text(
                  lang.w(Word.calling_waiter_details),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "SofiaProBold",
                      fontSize: 17,
                      color: ColorPalette.gray2),
                ),
              ),
            ),
            Divider(
              height: 1,
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
                  onHighlightChanged: (pressed) {
                    setState(() {
                      buttonColor = pressed ? Colors.white : ColorPalette.gray;
                    });
                  },
                  color: Colors.white,
                  child: Text(
                    lang.w(Word.thanks),
                    style: TextStyle(
                        fontFamily: "SofiaProBold",
                        fontSize: 17,
                        color: buttonColor),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
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
