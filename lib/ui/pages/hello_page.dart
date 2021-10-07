import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../internacionalization/app_language.dart';
import '../../utils/color_palette.dart';
import '../../utils/preferences.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';

class HelloPage extends StatefulWidget {
  @override
  _HelloPageState createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {
  double ovalHeight = 485;

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((val) {
      hideKeyBoard(context);
    });
    return CupertinoPageScaffold(
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: Provider.of<Preferences>(context, listen: false)
                .restaurantClient
                .picture,
            placeholder: (context, url) {
              return Image.asset("assets/home_back.png");
            },
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          CustomPaint(
            painter: WavePainter(ovalHeight),
            willChange: true,
          ),
          GestureDetector(
            onVerticalDragStart: (value) {
              print(value);
            },
            onVerticalDragDown: (value) {
              print(value);
            },
            onVerticalDragEnd: (value) {
              print(value);
              setState(() {
                ovalHeight = 485;
              });
            },
            onTap: () {
              Timer.periodic(Duration(milliseconds: 10), (timer) {
                setState(() {
                  ovalHeight += 10;
                });
                if (ovalHeight > 625) {
                  timer.cancel();
                  ovalHeight = 846;
                  _openPage(context);
                }
              });
            },
            onVerticalDragUpdate: (value) {
              // print(value);

              setState(() {
                ovalHeight -= value.delta.dy;
                print(ovalHeight);
                if (ovalHeight > 625) {
                  ovalHeight = 846;
                  _openPage(context);
                  ovalHeight = 485;
                }
                if (ovalHeight < 480) {
                  ovalHeight = 480;
                } else if (ovalHeight > 846) {
                  ovalHeight = 846;
                }
              });
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 150,
                width: 150,
                //padding: EdgeInsets.all(60),
                decoration: BoxDecoration(
                    color: Color(0xfffa456f),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xbbfa456f),
                          blurRadius: 15,
                          offset: Offset(0, 5))
                    ]),
                margin: EdgeInsets.only(bottom: ovalHeight.toDouble() - 270),
                child: Icon(
                  Icons.arrow_upward,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 77),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 180,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          ".\n.\n.\n.",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            height: 0.5,
                            color: Color(
                              0xffD9DEE4,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 205,
                      child: Text(
                        lang.w(Word.swipe_or_tap_for_open_the_menu),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Align(
          //     alignment: Alignment.topCenter,
          //     child: Transform.translate(
          //       offset: Offset(0, 27),
          //       child: Image.asset(
          //         "assets/logo/logo2.png",
          //         height: 39.7,
          //       ),
          //     )),
          // Positioned(
          //   top: 224,
          //   left: 190,
          //   child: Container(
          //     height: 90,
          //     width: 190,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(100),
          //             bottomLeft: Radius.circular(100),
          //             bottomRight: Radius.elliptical(240, 220))),
          //     alignment: Alignment.center,
          //     child: Text(
          //       lang.w(Word.hello),
          //       style: TextStyle(
          //         fontSize: 30,
          //         color: ColorPalette.gray,
          //         fontFamily: "SofiaProBold",
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 134,
          //   right: 310,
          //   child: Container(
          //     height: 70,
          //     width: 190,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(100),
          //             bottomLeft: Radius.circular(100),
          //             topRight: Radius.elliptical(240, 220))),
          //     alignment: Alignment.center,
          //     child: Text(
          //       lang.w(Word.welcome),
          //       style: TextStyle(
          //         fontSize: 20,
          //         color: ColorPalette.gray,
          //         fontFamily: "SofiaProBold",
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  void _openPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/home_page");
  }
}

class WavePainter extends CustomPainter {
  final double heigth;
  Paint _paint;
  WavePainter(this.heigth) {
    _paint = Paint();
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paint
      ..color = Colors.white
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(530, 1400), heigth + 450, _paint);
    print("painter");
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
