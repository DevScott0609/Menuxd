import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../service/http_handler.dart';
import '../../service/session.dart';
import '../../internacionalization/app_language.dart';
import '../../internacionalization/word.dart';
import '../../utils/preferences.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final BuildContext context;

  LoginPage(this.context);

  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  FocusNode emailFocus;
  FocusNode passFocus;

  final emailController =
      TextEditingController(text: 'publiciada@miservicioya2.com');
  final passController = TextEditingController(text: 'Xd123456');
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _loading = false;
  String _error = "";

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final language = Provider.of<AppLanguage>(context, listen: false);
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(color: Colors.white, fontFamily: "SofiaProBold"),
        ),
      ),
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        backgroundColor: Colors.black,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/login_back.jpg",
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.darken)),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/logo/logo_white.png",
                  height: 260,
                  width: 260,
                ),
              ),
              SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 180,
                      ),
                      Text(
                        "Menu Digital",
                        style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: "TimesBold"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: 324,
                          child: Text(
                            language.getWord(Word.insert_user_and_password),
                            style: TextStyle(
                              color: Color(0xffa1a1a1),
                              fontSize: 17,
                              fontFamily: "SofiaPro",
                            ),
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: 300,
                        child: CupertinoTextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          padding: EdgeInsets.all(20),
                          placeholder: language.w(Word.email),
                          placeholderStyle: TextStyle(color: Colors.black),
                          decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(25)),
                          focusNode: this.emailFocus,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(this.passFocus);
                          },
                          textInputAction: TextInputAction.next,
                          controller: emailController,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: 300,
                        child: CupertinoTextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          padding: EdgeInsets.all(20),
                          placeholder: language.w(Word.password),
                          placeholderStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          obscureText: true,
                          decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(25)),
                          focusNode: this.passFocus,
                          onEditingComplete: () {
                            _login(context);
                          },
                          controller: this.passController,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: 300,
                        child: CupertinoButton(
                            color: Color(0xfffa456f),
                            borderRadius: BorderRadius.circular(25),
                            padding: EdgeInsets.all(20),
                            child: Text(
                              language.w(Word.enter).toUpperCase(),
                              style: TextStyle(fontSize: 18),
                            ),
                            onPressed: _loading
                                ? null
                                : () {
                                    _login(context);
                                  }),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      if (this._error.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 20),
                          child: Text(
                            _error,
                            style: TextStyle(
                                color: Color(0xfffa456f),
                                fontSize: 20,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white),
                          ),
                        ),
                      if (_loading)
                        CupertinoActivityIndicator(
                          radius: 30,
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 40,
                child: DefaultTextStyle(
                  style: TextStyle(color: Color(0xffa1a1a1)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Image.asset(
                        "assets/phone.png",
                        height: 23,
                        width: 14.23,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "+595 971 900 509",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 40,
                child: DefaultTextStyle(
                  style: TextStyle(color: Color(0xffa1a1a1)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "soporte@menuxd.com",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "@",
                        style: TextStyle(fontSize: 25),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    emailFocus = FocusNode();
    passFocus = FocusNode();
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passFocus.dispose();
    super.dispose();
  }

  void _login(BuildContext context) async {
    final language = Provider.of<AppLanguage>(context, listen: false);
    setState(() {
      _loading = true;
      _error = "";
      hideKeyBoard(context);
    });
    HttpHandler httpHandler = Provider.of<HttpHandler>(context, listen: false);
    httpHandler
        .login(this.emailController.text, this.passController.text)
        .then((Session session) {
      if (session != null) {
        final preferences = Provider.of<Preferences>(context, listen: false);
        preferences.session = httpHandler.session;
        Navigator.pushNamedAndRemoveUntil(
            context, "/select_client", ModalRoute.withName('/select_client'));
      } else {
        setState(() {
          _loading = false;
          _error = language.w(Word.incorrect_user_or_password);
        });
      }
    }).catchError((error) {
      print(error);
      setState(() {
        _loading = false;
        _error = "Error de conección";
      });
    });
  }

  resetPasswordRequest(BuildContext context) {}
}
