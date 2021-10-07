import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../internacionalization/app_language.dart';
import '../../utils/color_palette.dart';
import 'package:provider/provider.dart';

class PayBillWidget extends StatefulWidget {
  PayBillWidget(this.onTap);

  final VoidCallback onTap;

  @override
  _PayBillWidgetState createState() => _PayBillWidgetState();
}

class _PayBillWidgetState extends State<PayBillWidget> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    return GestureDetector(
      onTapDown: widget.onTap != null
          ? (details) {
              setState(() {
                _pressed = true;
              });
            }
          : null,
      onTapCancel: widget.onTap != null
          ? () {
              setState(() {
                _pressed = false;
              });
            }
          : null,
      onTapUp: widget.onTap != null
          ? (details) {
              setState(() {
                _pressed = false;
              });
            }
          : null,
      onTap: widget.onTap,
      child: Column(
        children: <Widget>[
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
            ),
            padding: EdgeInsets.all(15),
            child: Image.asset(
              "assets/home_icons/pay.png",
              height: 25,
              color: (_pressed)
                  ? ColorPalette.melon.withOpacity(0.9)
                  : Colors.grey[800],
            ),
          ),
          Transform.translate(
            offset: Offset(0, 15),
            child: Text(
              lang.w(Word.pay_the_bill),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "SofiaPro",
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: (_pressed)
                    ? Color(0xfffa456f).withOpacity(0.9)
                    : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
