import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../internacionalization/app_language.dart';
import 'package:provider/provider.dart';

class PasswordWidget extends StatelessWidget {
  final int codeLen;

  PasswordWidget(this.codeLen);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          getState(1),
          getState(2),
          getState(3),
          getState(4),
        ],
      ),
    );
  }

  Widget getState(int number) {
    bool active = number <= codeLen;
    if (!active) {
      return Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xff555f69), width: 2),
            borderRadius: BorderRadius.circular(25)),
      );
    } else {
      return Container(
          height: 16,
          width: 16,
          decoration: BoxDecoration(
              color: Color(0xff555f69),
              borderRadius: BorderRadius.circular(25)));
    }
  }
}

typedef IntCallback = Function(int number);

class ButtonWidget extends StatelessWidget {
  final int number;
  final IntCallback intCallback;

  ButtonWidget({this.number, this.intCallback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            border: Border.all(color: Colors.black, width: 1)),
        width: 80,
        height: 80,
        margin: EdgeInsets.all(5),
        child: CupertinoButton(
          borderRadius: BorderRadius.circular(60),
          onPressed: _onTap,
          child: Text(
            "$number",
            style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w100,
                fontFamily: "SofiaProUltraLight",
                color: Color(0xff555f69)),
          ),
        ),
      ),
    );
  }

  void _onTap() {
    intCallback(number);
  }
}

class EmptyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      height: 10,
      width: 100,
    );
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback deleteCallback;

  DeleteButton(this.deleteCallback);

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 110,
        width: 85,
        child: CupertinoButton(
          borderRadius: BorderRadius.circular(60),
          onPressed: deleteCallback,
          padding: EdgeInsets.only(left: 15),
          child: Text(
            lang.w(Word.delete2),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xff555f69),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
