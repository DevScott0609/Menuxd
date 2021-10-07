import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../internacionalization/app_language.dart';
import '../../models/dish.dart';
import '../../models/order.dart';
import '../../providers/drinks_provider.dart';
import '../../providers/table_provider.dart';
import '../../ui/components/my_cupertino_button.dart';
import '../../ui/components/my_dialog.dart';
import '../../ui/components/text_lang.dart';
import '../../ui/dialogs/send_order_dialog.dart';
import '../../utils/color_palette.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import 'added_orders_dialog.dart';
import 'drinks_dialog.dart';

class AddNewDishDialog extends StatefulWidget {
  final Dish dish;
  final OrderItem myOrder;
  final bool editingDishInOrder;
  final int index;
  AddNewDishDialog({
    this.dish,
    this.editingDishInOrder = false,
    this.index = 0,
    this.myOrder,
  });

  @override
  _AddNewDishDialogState createState() => _AddNewDishDialogState();
}

class _AddNewDishDialogState extends State<AddNewDishDialog> {
  int _mount = 1;
  bool editing = false;
  Dish editingDish;

  Color addToOrderButtonColor = ColorPalette.gray;

  Color addNowButtonColor = Colors.white;

  bool takeaway = false;
  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    final child = editing ? editingWidget(lang) : firstWidget(lang);
    return MyDialog(
      width: 444,
      height: 701,
      borderRadius: 20,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: child,
      ),
    );
  }

  Widget firstWidget(AppLanguage lang) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          child: SizedBox(
            height: 353,
            width: 444,
            child: editingDish.pictures.isEmpty
                ? Image.asset(
                    "assets/logo/logo_grey.png",
                    fit: BoxFit.cover,
                  )
                : Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return CachedNetworkImage(
                        imageUrl: editingDish.pictures[index],
                        placeholder: (context, url) =>
                            Center(child: CupertinoActivityIndicator()),
                        errorWidget: (context, url, error) =>
                            Icon(CupertinoIcons.clear_circled),
                        height: 320,
                        fit: BoxFit.cover,
                      );
                    },
                    loop: false,
                    itemCount: editingDish.pictures.length,
                    pagination: SwiperPagination(
                        margin: EdgeInsets.only(bottom: 50),
                        builder: DotSwiperPaginationBuilder(
                            activeColor: Colors.white,
                            color: Colors.grey.withOpacity(0.5))),
                  ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: (701 - 353).toDouble(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    editingDish.name,
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: "TimesBold",
                        color: Color(0xff555f69)),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      editingDish.description ?? "No description",
                      style: TextStyle(
                          fontFamily: "SofiaProBold",
                          fontSize: 15,
                          height: 1.2,
                          color: ColorPalette.gray.withOpacity(0.5)),
                      //textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                price(context, lang),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  height: 1,
                ),
                buttons(context, lang)
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 75),
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      blurRadius: 173,
                      color: Color(0xff555F69).withOpacity(0.4),
                      offset: Offset(0, 9)),
                ]),
                child: MyCupertinoButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        lang.w(Word.edit_ingredients),
                        style:
                            TextStyle(fontFamily: "SofiaProBold", fontSize: 15),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        "assets/home_icons/edit_copy.png",
                        height: 18.25,
                        width: 18.25,
                      )
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      editing = true;
                    });
                  },
                ),
              ),
            ),
          ),
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
                width: 31,
                height: 31,
              ),
            ),
          ),
          alignment: Alignment.topRight,
        ),
        Align(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  takeaway = !takeaway;
                });
              },
              child: Row(
                children: <Widget>[
                  TextLang(
                    Word.takeaw,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          BoxShadow(
                              color: Colors.black,
                              spreadRadius: 10,
                              blurRadius: 10)
                        ]),
                  ),
                  CupertinoSwitch(
                    activeColor: ColorPalette.melon,
                    value: takeaway,
                    onChanged: (value) {
                      setState(() {
                        takeaway = value;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          alignment: Alignment.topLeft,
        )
      ],
    );
  }

  Widget editingWidget(AppLanguage lang) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Material(
                shape: CircleBorder(),
                color: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.keyboard_backspace),
                  iconSize: 30,
                  color: Color(0xff555f69),
                  onPressed: () {
                    setState(() {
                      editing = false;
                    });
                  },
                ),
              ),
            ),
            Padding(
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
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        if (editingDish.ingredients.length > 0)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              lang.w(Word.add_edit),
              style: TextStyle(
                  fontSize: 28,
                  fontFamily: "TimesBold",
                  color: Color(0xff555f69)),
            ),
          ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 30, right: 20),
              child: _getListWidget(lang)),
        ),
        price(context, lang),
        SizedBox(
          height: 15,
        ),
        buttons(context, lang)
      ],
    );
  }

  Widget buttons(BuildContext context, AppLanguage lang) {
    return Container(
      height: 56,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            blurRadius: 173,
            offset: Offset(0, 9),
            color: ColorPalette.gray.withOpacity(0.4))
      ]),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 56,
              child: FlatButton(
                color: Colors.white,
                onHighlightChanged: (pressed) {
                  setState(() {
                    addToOrderButtonColor =
                        pressed ? Colors.white : ColorPalette.gray;
                  });
                },
                highlightColor: ColorPalette.melon,
                child: Text(
                  lang.w(widget.editingDishInOrder
                      ? Word.update_order
                      : Word.add_to_order),
                  style: TextStyle(
                      color: addToOrderButtonColor,
                      fontFamily: "SofiaPro",
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                onPressed: () {
                  addDishToOrder(context);
                },
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: double.infinity,
              child: FlatButton(
                onHighlightChanged: (pressed) {
                  setState(() {
                    addNowButtonColor =
                        !pressed ? Colors.white : ColorPalette.gray;
                  });
                },
                highlightColor: Colors.white,
                color: ColorPalette.melon,
                child: Text(
                  lang.w(Word.order_now),
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: "SofiaPro",
                      fontWeight: FontWeight.bold,
                      color: addNowButtonColor),
                ),
                onPressed: () {
                  addDishToOrder(context, orderNow: true);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget price(BuildContext context, AppLanguage lang) {
    FlutterMoneyFormatter moneyFormatter = FlutterMoneyFormatter(
        amount: editingDish.total(_mount),
        settings: MoneyFormatterSettings(
            thousandSeparator: ".", decimalSeparator: ","));
    return Material(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: "Gs. ",
                      style: TextStyle(
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
                        fontFamily: "TimesBold",
                        shadows: [
                          Shadow(
                              color: Color(0xff555F69).withOpacity(0.4),
                              blurRadius: 173,
                              offset: Offset(0, 9))
                        ],
                        color: ColorPalette.melon,
                      ),
                      children: [
                        TextSpan(
                            text:
                                "${moneyFormatter.output.withoutFractionDigits}",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold))
                      ]),
                ),
              ),
              if (_mount > 1)
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    color: Color(0xff555f69),
                  ),
                  onPressed: () {
                    setState(
                      () {
                        this._mount--;
                        if (this._mount < 1) {
                          this._mount = 1;
                        }
                      },
                    );
                  },
                ),
              RichText(
                text: TextSpan(
                    text: "$_mount",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontFamily: "TimesBold"),
                    children: [
                      TextSpan(
                          text: " uni.",
                          style:
                              TextStyle(color: Color(0xffaaafb4), fontSize: 20))
                    ]),
              ),
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Color(0xff555f69),
                ),
                onPressed: () {
                  setState(
                    () {
                      this._mount++;
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addDishToOrder(BuildContext context, {bool orderNow = false}) {
    Navigator.pop(context);
    if (widget.editingDishInOrder) {
      Provider.of<OrdersProvider>(context, listen: false).updateOrder(
          OrderItem(
            dish: editingDish,
            takeaway: takeaway,
            mount: _mount,
          ),
          widget.index);
    } else {
      Provider.of<OrdersProvider>(context, listen: false).addOrder(OrderItem(
        dish: editingDish,
        mount: _mount,
        takeaway: takeaway,
      ));
    }

    if (orderNow) {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      final categories = categoryProvider.suggestedCategory();
      if (categories.length == 0) {
        Provider.of<OrdersProvider>(context, listen: false).orderNow();
        showMyDialog(context: context, child: SendOrderDialog());
      } else {
        showMyDialog(context: context, child: DrinksDialog());
      }
    } else {
      showMyDialog(context: context, child: AddedOrdersDialog());
    }
  }

  @override
  void initState() {
    super.initState();
    editingDish = widget.dish?.copy();
    if (widget.editingDishInOrder) {
      editingDish = widget.myOrder?.dish?.copy();
      _mount = widget.myOrder.mount;
      editing = true;
    }
  }

  _getListWidget(AppLanguage lang) {
    if (editingDish.ingredients.length == 0) {
      return Column(
        children: <Widget>[
          Icon(
            Icons.error,
            size: 120,
            color: Colors.grey[700],
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              lang.w(
                Word.empty_ingredient,
              ),
              style: TextStyle(color: Colors.grey, fontSize: 30),
              textAlign: TextAlign.center,
            ),
          )
        ],
      );
    }
    return ListView.builder(
      itemCount: editingDish.ingredients.length,
      itemBuilder: (_, index) {
        IngredientElement ingredient = editingDish.ingredients[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                ingredient.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              CupertinoSwitch(
                value: ingredient.price == 0 ? false : ingredient.active,
                onChanged: (value) {
                  setState(() {
                    ingredient.active = value;
                  });
                },
                activeColor: ColorPalette.melon,
              ),
            ],
          ),
        );
      },
    );
  }
}
