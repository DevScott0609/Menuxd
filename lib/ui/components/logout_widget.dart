import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../internacionalization/app_language.dart';
import '../../providers/table_provider.dart';
import '../../utils/utils.dart';
import '../../ui/dialogs/logout_dialog.dart';
import '../../utils/color_palette.dart';
import '../../models/popup.dart';

class LogoutWidget extends StatefulWidget {
  @override
  _CallWaiterWidgetState createState() => _CallWaiterWidgetState();
}

class _CallWaiterWidgetState extends State<LogoutWidget> {
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
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
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: null,
              ),
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.power_settings_new,
                size: 30.0,
                color: Colors.grey[800],
              )),
          Transform.translate(
              offset: Offset(0, 0),
              child: Text(
                lang.w(Word.logout),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontFamily: "SofiaPro",
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  void callWaiter(BuildContext context) async {
    showMyDialog(context: context, child: LogoutDialog());
  }
}
