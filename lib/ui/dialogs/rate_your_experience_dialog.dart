import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../internacionalization/app_language.dart';
import '../../models/question.dart';
import '../../models/rate.dart';
import '../../providers/table_provider.dart';
import '../components/my_dialog.dart';
import '../../utils/color_palette.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';

class RateYourExperienceDialog extends StatefulWidget {
  final BuildContext context;
  final int question;
  RateYourExperienceDialog(this.context, {this.question = 0});

  @override
  _RateYourExperienceDialogState createState() =>
      _RateYourExperienceDialogState();
}

class _RateYourExperienceDialogState extends State<RateYourExperienceDialog> {
  int rateValue = 5;

  Color buttonColor = Colors.black;

  Question question;
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    return MyDialog(
      width: 500,
      height: 550,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Image.asset(
                "assets/dialogs/rating.png",
                height: 196,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Text(
                  lang.w(Word.rate_your_experience),
                  style: TextStyle(
                      fontSize: 30,
                      color: ColorPalette.gray,
                      fontFamily: "TimesBold"),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Text(
                  question?.text ?? "Error NO se econtro la pregunta",
                  style: TextStyle(
                      color: ColorPalette.gray2,
                      fontSize: 17,
                      height: 2.0,
                      fontFamily: "SofiaProBold"),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Material(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RateStart(
                        onPressed: () {
                          changeRate(1);
                        },
                        value: 1,
                        groupValue: rateValue,
                      ),
                      RateStart(
                        onPressed: () {
                          changeRate(2);
                        },
                        value: 2,
                        groupValue: rateValue,
                      ),
                      RateStart(
                        onPressed: () {
                          changeRate(3);
                        },
                        value: 3,
                        groupValue: rateValue,
                      ),
                      RateStart(
                        onPressed: () {
                          changeRate(4);
                        },
                        value: 4,
                        groupValue: rateValue,
                      ),
                      RateStart(
                        onPressed: () {
                          changeRate(5);
                        },
                        value: 5,
                        groupValue: rateValue,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
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
                    lang.w(Word.send),
                    style: TextStyle(
                        fontFamily: "SofiaProBold",
                        fontSize: 17,
                        color: buttonColor),
                  ),
                  onPressed: () {
                    Provider.of<OrdersProvider>(context, listen: false)
                        .rateExperience(Rate(
                      score: rateValue,
                      questionId: question.id,
                    ));
                    Navigator.pop(context);
                    final ratings = Provider.of<OrdersProvider>(widget.context,
                            listen: false)
                        .questions;
                    if ((ratings.length - 1) > widget.question) {
                      Future.delayed(Duration(seconds: 5)).then((value) {
                        showMyDialog(
                            context: widget.context,
                            child: RateYourExperienceDialog(
                              widget.context,
                              question: widget.question + 1,
                            ),
                            backColor: this.mounted
                                ? Colors.black.withOpacity(0.01)
                                : Color(0xccFFFFFF));
                      });
                    }
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
                  width: 35,
                  height: 35,
                ),
              ),
            ),
            alignment: Alignment.topRight,
          )
        ],
      ),
    );
  }

  void changeRate(int value) {
    setState(() {
      rateValue = value;
      print(rateValue);
    });
  }

  @override
  void initState() {
    super.initState();

    final ratings =
        Provider.of<OrdersProvider>(widget.context, listen: false).questions;
    if (ratings != null) {
      question = ratings[widget.question];
    }
  }
}

class RateStart extends StatelessWidget {
  RateStart({this.onPressed, this.value, this.groupValue});

  final VoidCallback onPressed;
  final int value;
  final int groupValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          firstChild: Icon(
            Icons.star,
            size: 50,
            color: Color(0xffffc235),
          ),
          secondChild: Icon(
            Icons.star,
            size: 50,
            color: Color(0xffffefcf),
          ),
          crossFadeState: value <= groupValue
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        ));
  }
}
