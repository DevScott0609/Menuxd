import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../models/promotion.dart';
import '../../ui/components/promotion_widget.dart';
import '../../utils/color_palette.dart';

class PromotionBanner extends StatefulWidget {
  final List<Promotion> promotions;
  final Key key;
  PromotionBanner(this.promotions, {this.key});

  @override
  _PromotionBannerState createState() => _PromotionBannerState();
}

class _PromotionBannerState extends State<PromotionBanner> {
  List list1;
  List list2;
  @override
  Widget build(BuildContext context) {
    final l = widget.promotions.length;
    list1 = [];
    list2 = [];
    if (l == 1) {
      list1.add(widget.promotions[0]);
      list2.add(widget.promotions[0]);
    } else {
      for (int i = 0; i < l; i++) {
        final promotion = widget.promotions[i];
        if ((i % 2) == 0) {
          list1.add(promotion);
        } else {
          list2.add(promotion);
        }
      }
    }

    return Container(
      height: 250,
      child: Row(children: getList()),
    );
  }

  List<Widget> getList() {
    return [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                spreadRadius: 0.0,
                blurRadius: 20.0,
                offset: Offset(5.0, 5.0),
              )
            ],
          ),
          child: Swiper(
            key: widget.key,
            itemCount: list1.length,
            itemBuilder: (context, index) {
              final promotion = list1[index];
              return Container(
                child: PromotionWidget(
                  withShadow: true,
                  index: index,
                  promotion: promotion,
                ),
              );
            },
            autoplay: true,
            autoplayDelay: 10 * 1000,
          ),
        ),
      ),
      SizedBox(
        width: 30,
      ),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Swiper(
            itemCount: list2.length,
            itemBuilder: (context, index) {
              final promotion = list2[index];
              return PromotionWidget(index: index, promotion: promotion);
            },
            autoplay: true,
            autoplayDelay: 10 * 1000,
          ),
        ),
      ),
      SizedBox(
        width: 15,
      ),
    ];
  }
}
