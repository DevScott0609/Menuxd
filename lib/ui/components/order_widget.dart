import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../internacionalization/app_language.dart';
import '../../utils/color_palette.dart';
import 'package:provider/provider.dart';

class OrdersWidget extends StatefulWidget {
  final int orders;
  final VoidCallback onTap;

  OrdersWidget({this.orders, this.onTap});

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      onTapUp: (details) {
        setState(() {
          _pressed = false;
        });
      },
      onLongPress: () {},
      onTap: () {
        print("tapped order widget page");
        widget.onTap();
      },
      child: Column(
        children: <Widget>[
          Container(
            height: 88,
            width: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(5),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[100],
                  child: Image.asset(
                    "assets/home_icons/orders.png",
                    height: 27,
                    color: (_pressed)
                        ? ColorPalette.melon.withOpacity(0.9)
                        : Colors.black,
                  ),
                ),
                if (widget.orders > 0)
                  Transform.translate(
                    offset: Offset(35, -10),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Color(0xfffa456f),
                          shape: BoxShape.circle,
                          boxShadow: []),
                      child: Text(
                        widget.orders.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            Provider.of<AppLanguage>(context, listen: false).w(Word.orders),
            style: TextStyle(
                //fontSize: 16,
                color: (_pressed)
                    ? Color(0xfffa456f).withOpacity(0.9)
                    : Colors.grey,
                fontFamily: "SofiaProBold"),
          )
        ],
      ),
    );
  }
}
