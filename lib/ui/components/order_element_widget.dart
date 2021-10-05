import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
// import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import '../../internacionalization/app_language.dart';
import '../../models/order.dart';
import '../../providers/table_provider.dart';
import '../../ui/dialogs/add_new_dish_dialog.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';

class OrderElementPage extends StatefulWidget {
  OrderElementPage(this.myOrder, this.index, {this.animate = false})
      : super(key: Key(myOrder.toString()));

  final OrderItem myOrder;
  final bool animate;
  final int index;

  @override
  _OrderElementPageState createState() {
    return _OrderElementPageState();
  }
}

class _OrderElementPageState extends State<OrderElementPage> {
  double xPosition = 0;
  bool animateState = true;
  bool animationDone = false;
  bool upping = false;
  OrdersProvider tableProvider;

  void animationWork(Timer timer) {
    if (!animateState || tableProvider.homePopup == null) {
      timer.cancel();
    } else {
      setState(() {
        if (upping) {
          xPosition += 1;
        } else {
          xPosition -= 3;
        }
        if (xPosition < -170) {
          xPosition = -170;
          upping = true;
          timer.cancel();
          Future.delayed(Duration(milliseconds: 1000)).then((val) {
            setAnimationTimer();
          });
        } else if (xPosition > 0) {
          xPosition = 0;
          upping = false;
        }
      });
    }
  }

  void setAnimationTimer() {
    Timer.periodic(Duration(milliseconds: 5), (timer) {
      animationWork(timer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context);
    tableProvider = Provider.of<OrdersProvider>(context);
    // FlutterMoneyFormatter moneyFormatter = FlutterMoneyFormatter(
    //     amount: widget.myOrder.dish.total(widget.myOrder.mount),
    //     settings: MoneyFormatterSettings(
    //         thousandSeparator: ".", decimalSeparator: ","));
    if (tableProvider.homePopup == null) {
      xPosition = 0;
      animationDone = false;
    }
    if (widget.animate &&
        xPosition == 0 &&
        tableProvider.homePopup == HomePopup.ORDERS &&
        !animationDone) {
      animationDone = true;
      animateState = true;
      setAnimationTimer();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (!widget.myOrder.locked) {
                    showMyDialog(
                        context: context,
                        child: AddNewDishDialog(
                          index: widget.index,
                          editingDishInOrder: true,
                          myOrder: widget.myOrder,
                        ));
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      "assets/home_icons/edit_copy.png",
                      height: 30,
                      width: 30,
                      color: widget.myOrder.locked
                          ? Colors.grey[400]
                          : Color(0xff555f69),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      lang.w(Word.edit),
                      style: TextStyle(
                          color: Color(0xffaaafb4),
                          fontSize: 16,
                          fontFamily: "SofiaProLigth"),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  if (!widget.myOrder.locked) {
                    Provider.of<OrdersProvider>(context).delete(widget.myOrder);
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      "assets/delete.png",
                      height: 30,
                      width: 30,
                      color: widget.myOrder.locked ? Colors.grey[400] : null,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      lang.w(Word.delete),
                      style: TextStyle(
                          color: Color(0xffaaafb4),
                          fontSize: 16,
                          fontFamily: "SofiaProLigth"),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 30,
              )
            ],
          ),
          Transform.translate(
            offset: Offset(xPosition, 0),
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                setState(() {
                  if (xPosition > -75) {
                    xPosition = 0;
                  } else {
                    xPosition = -170;
                  }
                });
              },
              onHorizontalDragUpdate: (details) {
                double position = -170;
                setState(() {
                  animateState = false;
                  xPosition += details.delta.dx;

                  if (xPosition < position) {
                    xPosition = position;
                  } else if (xPosition > 0) {
                    xPosition = 0;
                  } else if (xPosition > -120 && xPosition < -100) {
                    xPosition = 0;
                  } else if (xPosition < -75 && xPosition > -100) {
                    xPosition = position;
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12.withOpacity(0.15),
                          offset: Offset(0, 5),
                          blurRadius: 20,
                          spreadRadius: 3)
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      child: widget.myOrder.dish.pictures.isEmpty
                          ? Image.asset(
                              "assets/logo/logo_grey.png",
                              height: 155,
                              width: 180,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: widget.myOrder.dish.pictures.isNotEmpty
                                  ? widget.myOrder.dish.pictures[0]
                                  : "",
                              placeholder: (context, url) =>
                                  Center(child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              height: 155,
                              width: 180,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 40, bottom: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      widget.myOrder.dish.name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "SofiaProBold"),
                                      //overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "x${widget.myOrder.mount}",
                                    style: TextStyle(
                                        fontFamily: "SofiaProBold",
                                        color: Colors.grey,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            // Align(
                            //   child: Text(
                            //     "\t\tGs. ${(widget.myOrder.dish.price == null) ? "00" : moneyFormatter.output.withoutFractionDigits}",
                            //     style: TextStyle(
                            //         color: Color(0xfffa456f),
                            //         fontSize: 16,
                            //         fontFamily: "SofiaProBold"),
                            //   ),
                            //   alignment: Alignment.bottomLeft,
                            // )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
