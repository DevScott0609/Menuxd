import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../internacionalization/app_language.dart';
import '../../models/category.dart';
import '../../models/dish.dart';
import '../../providers/drinks_provider.dart';
import '../../providers/table_provider.dart';
import '../../ui/components/my_dialog.dart';
import 'send_order_dialog.dart';
import '../../utils/color_palette.dart';
import '../../utils/utils.dart';
import 'drinks_details_dialog.dart';

class DrinksDialog extends StatefulWidget {
  DrinksDialog();

  @override
  _DrinksDialogState createState() => _DrinksDialogState();
}

class _DrinksDialogState extends State<DrinksDialog> {
  Color buttonColor = ColorPalette.gray;

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.suggestedCategory().where((category) {
      return category.dishesList?.isNotEmpty ?? false;
    }).toList();
    return MyDialog(
      width: 600,
      height: 500,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Text(
                  "${lang.w(Word.accompany_with_drink)}:",
                  style: TextStyle(
                      fontSize: 30,
                      color: ColorPalette.gray,
                      fontFamily: "TimesBold"),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(categories.length, (index) {
                  final category = categories[index];
                  return DrinkWidget(
                    title: category.title,
                    imgPath: category.picture,
                    onSelect: () {
                      showOrderDialog(context, category);
                    },
                  );
                }),
              ),
              Expanded(
                child: SizedBox(),
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: ColorPalette.gray.withOpacity(0.4),
                        blurRadius: 173,
                        offset: Offset(0, 9))
                  ]),
                  child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      highlightColor: ColorPalette.melon,
                      onHighlightChanged: (pressed) {
                        setState(() {
                          buttonColor =
                              pressed ? Colors.white : ColorPalette.gray;
                        });
                      },
                      child: Text(
                        lang.w(Word.no_thanks),
                        style: TextStyle(
                            color: buttonColor,
                            fontSize: 17,
                            fontFamily: "SofiaProBold"),
                      ),
                      color: Colors.white,
                      onPressed: () {
                        payNow(context);
                      }),
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

  void payNow(BuildContext context) {
    Navigator.pop(context);
    Provider.of<OrdersProvider>(context).orderNow();
    showMyDialog(context: context, child: SendOrderDialog());
  }

  void showOrderDialog(BuildContext context, Category category) {
    showMyDialog(
        backColor: Colors.black.withOpacity(0.01),
        context: context,
        child: DrinksDetailsDialog(category));
  }
}

class DrinkWidget extends StatelessWidget {
  final String title;
  final String imgPath;
  final Dish dish;

  final VoidCallback onSelect;

  DrinkWidget({this.title, this.imgPath, this.dish, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 29,
                offset: Offset(0, 21),
                color: Colors.black.withOpacity(0.1),
              )
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 14),
            height: 210,
            width: 155,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: imgPath,
                  height: 126,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      color: ColorPalette.gray,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum DrinkType { SODA, BEER, COCKTAIL }
