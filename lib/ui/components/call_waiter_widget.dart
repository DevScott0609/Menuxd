import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../internacionalization/app_language.dart';
import '../../models/popup.dart';
import '../../providers/table_provider.dart';
import '../../ui/dialogs/call_waiter_dialog.dart';
import '../../utils/color_palette.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';

class CallWaiterWidget extends StatefulWidget {
  @override
  _CallWaiterWidgetState createState() => _CallWaiterWidgetState();
}

class _CallWaiterWidgetState extends State<CallWaiterWidget> {
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context);
    final tableProvider = Provider.of<OrdersProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        if (!tableProvider.callingWaiter) {
          callWaiter(context);
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tableProvider.callingWaiter ? ColorPalette.melon : null,
            ),
            padding: EdgeInsets.all(15),
            child: Image.asset(
              "assets/home_icons/call_waiter.png",
              height: 35,
              color: tableProvider.callingWaiter ? null : Colors.grey[800],
            ),
          ),
          Transform.translate(
              offset: Offset(0, 10),
              child: Text(
                lang.w(Word.call_waiter),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: tableProvider.callingWaiter
                        ? ColorPalette.melon
                        : Colors.grey,
                    fontFamily: "SofiaPro",
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  void callWaiter(BuildContext context) async {
    print("calling waiter");
    setState(() {
      Provider.of<OrdersProvider>(context, listen: false).callWaiter();
    });
    showMyDialog(context: context, child: CallWaiterDialog());
    await Future.delayed(Duration(seconds: 20));
    setState(() {
      Provider.of<OrdersProvider>(context, listen: false).callWaiter2();
    });
  }
}
