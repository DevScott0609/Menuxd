import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import '../../internacionalization/app_language.dart';
import '../../models/category.dart';
import '../../models/dish.dart';
import '../../models/order.dart';
import '../../providers/drinks_provider.dart';
import '../../providers/table_provider.dart';
import '../../ui/components/my_dialog.dart';
import '../../ui/components/text_lang.dart';
import '../../ui/dialogs/send_order_dialog.dart';
import '../../utils/color_palette.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';

class DrinksDetailsDialog extends StatefulWidget {
  final Category category;
  DrinksDetailsDialog(this.category);

  @override
  _DrinksDetailsDialogState createState() => _DrinksDetailsDialogState();
}

class _DrinksDetailsDialogState extends State<DrinksDetailsDialog> {
  Dish selected;

  Color buttonColor = ColorPalette.gray;

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    final list = widget.category.dishesList;
    List<Dish> suggestedList = [];
    suggestedList = Provider.of<CategoryProvider>(context, listen: false)
        .getSuggestedDishes(widget.category);
    return MyDialog(
      opacity: 0.0,
      width: 700,
      height: 500,
      child: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Text(
                "${lang.w(Word.select_your_preffer_option)}:",
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
                children: List.generate(
                    suggestedList.length > 3 ? 3 : suggestedList.length,
                    (index) {
                  final dish = suggestedList[index];
                  return DrinkDetailsWidget(
                    onSelect: () {
                      _selectDrink(dish);
                    },
                    selected: selected,
                    dish: dish,
                  );
                })
                  ..addAll([
                    OthersDrinkWidget(
                      category: widget.category,
                    )
                  ])),
            Expanded(
              child: SizedBox(),
            ),
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 173,
                    offset: Offset(0, 9),
                    color: ColorPalette.gray.withOpacity(0.4))
              ]),
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 550),
                firstChild: SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      lang.w(Word.no_thanks),
                      style: TextStyle(
                        color: buttonColor,
                        fontSize: 17,
                        fontFamily: "SofiaProBold",
                      ),
                    ),
                    onHighlightChanged: (pressed) {
                      setState(() {
                        buttonColor =
                            pressed ? Colors.white : ColorPalette.gray;
                      });
                    },
                    color: Color(0xfff6f9fc),
                    highlightColor: ColorPalette.melon,
                    onPressed: () {
                      payNow(context);
                    },
                  ),
                ),
                secondChild: SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      lang.w(Word.order_now),
                      style: TextStyle(
                          fontFamily: "SofiaProBold",
                          fontSize: 17,
                          color: Colors.white),
                    ),
                    color: Color(0xfffa456f),
                    onPressed: () {
                      //TODO agregar a la oren el dish específico
                      addToOrden(selected, context);
                    },
                  ),
                ),
                crossFadeState: selected == null
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            ),
          ],
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Material(
              color: Colors.white,
              child: IconButton(
                icon: Icon(Icons.close),
                iconSize: 30,
                color: Color(0xff555f69),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
            ),
          ),
          alignment: Alignment.topRight,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Material(
              shape: CircleBorder(),
              color: Colors.white,
              child: IconButton(
                icon: Icon(Icons.keyboard_backspace),
                iconSize: 30,
                color: Color(0xff555f69),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void addToOrden(Dish dish, BuildContext context) {
    if (dish != null) {
      Provider.of<OrdersProvider>(context, listen: false).addOrder(OrderItem(
        dish: dish,
        mount: 1,
        takeaway: false,
      ));
    }

    payNow(context);
  }

  void payNow(BuildContext context) {
    Navigator.maybePop(context);
    Navigator.maybePop(context);
    Navigator.maybePop(context);
    Provider.of<OrdersProvider>(context, listen: false).orderNow();
    showMyDialog(context: context, child: SendOrderDialog());
  }

  void _selectDrink(Dish s) {
    setState(() {
      if (selected == s) {
        selected = null;
      } else {
        selected = s;
      }
    });
  }
}

class DrinkDetailsWidget extends StatelessWidget {
  final Dish dish;
  final Dish selected;
  final VoidCallback onSelect;

  DrinkDetailsWidget({this.dish, this.selected, this.onSelect});

  @override
  Widget build(BuildContext context) {
    final drinkSelected = (selected == dish);
    final image =
        Provider.of<CategoryProvider>(context, listen: false).imageOfDish(dish);
    double added = drinkSelected ? -3 : 0;
    return GestureDetector(
      onTap: onSelect,
      child: Material(
        child: AnimatedContainer(
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.only(
              top: 10 + added,
              left: 10 + added,
              right: 10 + added,
              bottom: 20 + added),
          height: 210,
          width: 125,
          duration: Duration(milliseconds: 100),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: (drinkSelected)
                  ? Border.all(
                      color: Color(0xfffa456f),
                      width: 3,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                    blurRadius: 29,
                    offset: Offset(0, 21),
                    color: Colors.black.withOpacity(0.1)),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (image == null)
                Expanded(
                  child: Image.asset(
                    "assets/logo/logo1.png",
                    height: 114,
                  ),
                ),
              if (image != null)
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) =>
                        Center(child: CupertinoActivityIndicator()),
                    height: 114,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  cutString(dish.name, 20),
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                "\t\tGs. ${(dish.price == null) ? "_ERROR_" : FlutterMoneyFormatter(amount: dish.price.toDouble(), settings: MoneyFormatterSettings(thousandSeparator: ".", decimalSeparator: ",")).output.withoutFractionDigits}",
                style: TextStyle(
                    color: Color(0xfffa456f),
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String cutString(String string, int length) {
  int init = 0;
  int end = length;
  if (string.length < length) {
    end = string.length;
  }
  return string.substring(init, end);
}

class OthersDrinkWidget extends StatelessWidget {
  final Category category;

  OthersDrinkWidget({this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Provider.of<CategoryProvider>(context, listen: false).selectedCategory =
            category;
      },
      child: Material(
        child: AnimatedContainer(
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
          height: 210,
          width: 125,
          duration: Duration(milliseconds: 100),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    blurRadius: 29,
                    offset: Offset(0, 21),
                    color: Colors.black.withOpacity(0.1)),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Image.asset(
                  "assets/other_drinks.png",
                  height: 124,
                  width: 100,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextLang(
                    Word.other_drink,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
