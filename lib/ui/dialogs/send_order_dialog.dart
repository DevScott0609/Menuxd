import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../internacionalization/app_language.dart';
import '../../utils/color_palette.dart';
import 'package:provider/provider.dart';

class SendOrderDialog extends StatefulWidget {
  SendOrderDialog();

  @override
  _SendOrderDialogState createState() => _SendOrderDialogState();
}

class _SendOrderDialogState extends State<SendOrderDialog> {
  Color colorButton = ColorPalette.gray;
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context, listen: false);

    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: 480,
          height: 483,
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  offset: Offset(0, 21),
                  blurRadius: 21,
                  color: Colors.black.withOpacity(0.1))
            ], borderRadius: BorderRadius.circular(20)),
            child: Material(
              color: Colors.transparent,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                elevation: 0,
                clipBehavior: Clip.hardEdge,
                child: child(context, lang),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget child(BuildContext context, AppLanguage lang) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/dialogs/order_sended.png",
              height: 252,
            ),
            SizedBox(
              width: 460,
              child: Text(
                lang.w(Word.order_sent),
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
                  lang.w(Word.order_sent_details),
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
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 173,
                    offset: Offset(0, 9),
                    color: ColorPalette.gray.withOpacity(0.4))
              ]),
              child: FlatButton(
                color: Colors.white,
                highlightColor: ColorPalette.melon,
                onHighlightChanged: (pressed) {
                  setState(() {
                    colorButton = pressed ? Colors.white : ColorPalette.gray;
                  });
                },
                child: Text(
                  lang.w(Word.thanks),
                  style: TextStyle(
                      fontFamily: "SofiaProBold",
                      fontSize: 17,
                      color: colorButton),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
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
