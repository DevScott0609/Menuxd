import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../service/http_handler.dart';
import '../../models/promotion.dart';
import '../../providers/drinks_provider.dart';
import '../../utils/color_palette.dart';
import 'package:provider/provider.dart';

class PromotionWidget extends StatelessWidget {
  final Promotion promotion;
  final int index;
  final bool withShadow;
  PromotionWidget({this.promotion, this.index, this.withShadow = false});

  static const colorsSet = [
    [Color(0xffffb0c5), Color(0xffff7893)],
    [Color(0xffb0bbff), Color(0xffed78ff)],
    [Color(0xfff3db72), Color(0xffff9d70)],
    [Color(0xff63e58b), Color(0xff46b67e)],
  ];

  @override
  Widget build(BuildContext context) {
    HttpHandler httpHandler = Provider.of<HttpHandler>(context);

    return DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: GestureDetector(
        onTap: () async {
          Provider.of<CategoryProvider>(context).promotionSelected = promotion;
          httpHandler.sendPromotionClick(promotion);
        },
        child: Container(
          width: 420,
          padding: EdgeInsets.fromLTRB(20, 20, 20, withShadow ? 100 : 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: NetworkImage(promotion.picture), fit: BoxFit.cover),
            gradient: LinearGradient(
                colors: getGradientsColors(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
        ),
      ),
    );
  }

  List<Color> getGradientsColors() {
    Random random = Random();
    return colorsSet[random.nextInt(3)];
  }
}
