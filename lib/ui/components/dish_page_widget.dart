import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../service/http_handler.dart';
import '../../internacionalization/app_language.dart';
import '../../internacionalization/word.dart';
import '../../models/category.dart';
import '../../models/dish.dart';
import '../../providers/table_provider.dart';
import 'package:provider/provider.dart';

import 'dish_widget.dart';

class DishPageWidget extends StatelessWidget {
  final Category category;
  final dishList = ValueNotifier<List>(null);

  DishPageWidget(this.category);

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    loadDish(context);
    return ValueListenableBuilder<List>(
        valueListenable: dishList,
        builder: (context, value, child) {
          if (value == null) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CupertinoActivityIndicator(
                  radius: 20,
                ),
              ],
            );
          } else if (value.length == 0) {
            return Column(
              children: <Widget>[
                Icon(
                  Icons.info,
                  size: 400,
                  color: Colors.grey.withOpacity(0.4),
                ),
                Text(
                  lang.w(Word.empty_category),
                  style: TextStyle(fontSize: 40, fontFamily: "SofiaProLigth"),
                )
              ],
            );
          } else {
            return ListView(
              children: <Widget>[
                Wrap(
                  children: List.generate(value.length, (index) {
                    return DishWidget(value[index]);
                  }),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Gracias por utilizar\n",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        children: [
                          TextSpan(
                              text: "MenuXD",
                              style: TextStyle(
                                  color: Color(0xfffa456f),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          TextSpan(
                              text: " com", style: TextStyle(fontSize: 12)),
                        ]),
                  ),
                )
              ],
            );
          }
        });
  }

  void loadDish(BuildContext context) async {
    if (category.dishesList != null) {
      //Si ya se tiene cargado, simplemente se cancela la carga
      if (category.id == 560) {
        List promotions =
            Provider.of<OrdersProvider>(context, listen: false).promotions;
        var newPromo = [];
        promotions.forEach((fruit) => {newPromo.add((fruit.dish))});
        this.dishList.value = newPromo;
      } else {
        this.dishList.value = category.dishesList;
      }
      return;
    }
    HttpHandler httpHandler = Provider.of<HttpHandler>(context, listen: false);

    this.dishList.value = await loadDishFromCategory(httpHandler, category);
    category.dishesList = dishList.value;
  }

  Future<List<Dish>> loadDishFromCategory(
      HttpHandler httpHandler, Category category) async {
    if (category == null) {
      return [];
    }
    return await httpHandler.getDishes(category);
  }
}
