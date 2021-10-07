import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../internacionalization/app_language.dart';
import '../../ui/dialogs/rate_your_experience_dialog.dart';
import '../../utils/color_palette.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';

class PayTheBillDialog extends StatefulWidget {
  final BuildContext context;
  PayTheBillDialog(this.context);

  @override
  _PayTheBillDialogState createState() => _PayTheBillDialogState();
}

class _PayTheBillDialogState extends State<PayTheBillDialog> {
  Color buttonColor = Colors.black;

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
                lang.w(Word.pay_the_bill),
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
                  lang.w(Word.pay_the_bill_details),
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
                highlightColor: ColorPalette.melon,
                color: Colors.white,
                onHighlightChanged: (pressed) {
                  setState(() {
                    buttonColor = pressed ? Colors.white : Colors.black;
                  });
                },
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
    Future.delayed(Duration(seconds: 5)).then((value) {
      showMyDialog(
              context: widget.context,
              child: RateYourExperienceDialog(widget.context),
              backColor: this.mounted
                  ? Colors.black.withOpacity(0.01)
                  : Color(0xccFFFFFF))
          .catchError((error) {
        print(error);
      }).catchError((error) {
        print(error);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
