import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'dart:ui';
import '../../models/dish.dart';
import '../../ui/animations/fade_in_to_up.dart';
import '../../ui/dialogs/add_new_dish_dialog.dart';
import '../../utils/color_palette.dart';
import '../../utils/utils.dart';

class DishWidget extends StatelessWidget {
  final Dish dish;

  DishWidget(this.dish);

  @override
  Widget build(BuildContext context) {
    FlutterMoneyFormatter moneyFormatter = FlutterMoneyFormatter(
        amount: (dish.price == null) ? 999999999 : dish.price.toDouble(),
        settings: MoneyFormatterSettings(
            thousandSeparator: ".", decimalSeparator: ","));
    final height = 298.87;
    final width = 273.0;
    final imageHeight = height * 0.65;
    return FadeInToUp(
      duration: Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: () {
          this.showAddDishToOrderDialog(context);
        },
        child: SizedBox(
          height: height,
          width: width,
          child: Card(
            elevation: 0.3,
            clipBehavior: Clip.hardEdge,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: imageHeight,
                    child: dish.pictures.isEmpty
                        ? Image.asset(
                            "assets/logo/logo_grey.png",
                            fit: BoxFit.cover,
                          )
                        : dish.pictures.length == 1
                            ? CachedNetworkImage(
                                imageUrl: dish.pictures[0],
                                placeholder: (context, url) =>
                                    Center(child: CupertinoActivityIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(CupertinoIcons.clear_circled),
                                height: imageHeight,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Swiper(
                                autoplay: true,
                                autoplayDelay: 10000,
                                autoplayDisableOnInteraction: true,
                                itemBuilder: (BuildContext context, int index) {
                                  if (dish.pictures == null ||
                                      dish.pictures.isEmpty) {
                                    return Image.asset(
                                        "assets/logo/logo_grey.png");
                                  }
                                  return CachedNetworkImage(
                                    imageUrl: dish.pictures[index],
                                    placeholder: (context, url) => Center(
                                        child: CupertinoActivityIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(CupertinoIcons.clear_circled),
                                    height: imageHeight,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                  //return new Image.network("http://via.placeholder.com/350x150",fit: BoxFit.fill,);
                                },
                                itemCount: dish.pictures.length,
                              ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Stack(
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "SofiaPro",
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette.gray),
                                children: [
                                  TextSpan(
                                    text: dish.name,
                                  ),
                                  TextSpan(
                                      text:
                                          "\t\tGs. ${(dish.price == null) ? "00" : moneyFormatter.output.withoutFractionDigits}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: "SofiaProBold"))
                                ]),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                                "\t\tGs. ${(dish.price == null) ? "00" : moneyFormatter.output.withoutFractionDigits}",
                                style: TextStyle(
                                    color: ColorPalette.melon,
                                    fontSize: 17,
                                    fontFamily: "SofiaPro",
                                    fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showAddDishToOrderDialog(BuildContext context) async {
    showMyDialog(context: context, child: AddNewDishDialog(dish: dish));
  }
}
