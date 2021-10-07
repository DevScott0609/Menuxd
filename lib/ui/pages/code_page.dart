import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../service/http_handler.dart';
import '../../internacionalization/word.dart';
import '../../providers/table_provider.dart';
import '../../ui/components/password.dart';
import '../../ui/components/text_lang.dart';
import 'package:provider/provider.dart';

class CodePage extends StatefulWidget {
  CodePage({Key key}) : super(key: key);

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  String password = "";

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10.0,
        sigmaY: 10.0,
      ),
      child: Container(
        color: Colors.white.withOpacity(0.9),
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                width: 360,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextLang(
                      Word.enter_password,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    PasswordWidget(password.length),
                    SizedBox(
                      height: 50,
                    ),
                    Wrap(
                      children: <Widget>[
                        ButtonWidget(
                          number: 1,
                          intCallback: _numberClicked,
                        ),
                        ButtonWidget(
                          number: 2,
                          intCallback: _numberClicked,
                        ),
                        ButtonWidget(
                          number: 3,
                          intCallback: _numberClicked,
                        ),
                        ButtonWidget(
                          number: 4,
                          intCallback: _numberClicked,
                        ),
                        ButtonWidget(
                          number: 5,
                          intCallback: _numberClicked,
                        ),
                        ButtonWidget(
                          number: 6,
                          intCallback: _numberClicked,
                        ),
                        ButtonWidget(
                          number: 7,
                          intCallback: _numberClicked,
                        ),
                        ButtonWidget(
                          number: 8,
                          intCallback: _numberClicked,
                        ),
                        ButtonWidget(
                          number: 9,
                          intCallback: _numberClicked,
                        ),
                        EmptyButton(),
                        ButtonWidget(
                          number: 0,
                          intCallback: _numberClicked,
                        ),
                        DeleteButton(_deleteNumber)
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 40,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  "assets/close-gray.png",
                  height: 40,
                  width: 40,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _numberClicked(int number) async {
    if (password.length < 4) {
      setState(() {
        this.password += number.toString();
      });
      if (this.password.length == 4) {
        final waiter = await Provider.of<HttpHandler>(context, listen: false)
            .checkWaiterCode(password);
        if (waiter != null) {
          print("Hello page");
          Provider.of<OrdersProvider>(context, listen: false).waiter = waiter;
          Navigator.pop(context);
          Navigator.pushNamed(context, "/tables");
        } else {
          setState(() {
            password = "";
          });
        }
      }
      print(password);
    }
  }

  void _deleteNumber() {
    if (password.length > 0) {
      setState(() {
        this.password = password.substring(0, password.length - 1);
      });
    }
    print(password);
  }
}
