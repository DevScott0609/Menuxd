import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../service/http_handler.dart';
import '../../internacionalization/app_language.dart';
import '../../models/ad.dart';
import '../../models/category.dart';
import '../../models/dish.dart';
import '../../providers/drinks_provider.dart';
import '../../providers/table_provider.dart';
import '../../ui/components/ad_banner.dart';
import '../../ui/components/call_waiter_widget.dart';
import '../../ui/components/category_widget.dart';
import '../../ui/components/dish_page_widget.dart';
import '../../ui/components/order_element_widget.dart';
import '../../ui/components/order_widget.dart';
import '../../ui/components/pay_bill_widget.dart';
import '../../ui/components/promotion_banner.dart';
import '../../ui/components/text_lang.dart';
import '../../ui/dialogs/language_dialog.dart';
import '../../ui/dialogs/notifications_dialog.dart';
import '../../ui/dialogs/pay_the_bill_dialog.dart';
import '../../ui/dialogs/send_order_dialog.dart';
import '../../utils/color_palette.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';
import 'code_page.dart';

class HomePage extends StatefulWidget {
  final BuildContext context;

  HomePage(this.context);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<Ad> _adsList;

  final _categoryScrollController = ScrollController();
  final mainScrollController = ScrollController();
  int notifications = 0;
  bool newNitify = false;
  bool showingLanguageDialog = false;
  final swiperController = SwiperController();
  final _mainPageState = ValueNotifier<bool>(false);
  final _scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(
      builder: (context, tableProvider, child) {
        int ordersCount = tableProvider.order.items.length;
        return WillPopScope(
          onWillPop: () async {
            Navigator.maybePop(context);
            return false;
          },
          child: Scaffold(
            key: _scaffold,
            backgroundColor: Color(0xfff5f8fb),
            body: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: double.infinity,
                      width: 70,
                    ),
                    Expanded(
                      child: NestedScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: mainScrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return [
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _SliverAppBarDelegate(
                                  minHeight: 80,
                                  maxHeight: 80,
                                  child: _getTopMenu(context)),
                            ),
                            SliverPersistentHeader(
                              // pinned: true,
                              delegate: _SliverAppBarDelegate(
                                minHeight: 150,
                                maxHeight: 150,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: getCategoriesWidget(context),
                                ),
                              ),
                            ),
                          ];
                        },
                        body: Padding(
                          padding: const EdgeInsets.only(left: 55),
                          child: getBody(context),
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: tableProvider.homePopup != HomePopup.ORDERS
                      ? Container(height: 1, width: 1)
                      : ordersPage(context),
                ),
                Container(
                  height: double.infinity,
                  width: 82,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (tableProvider.homePopup == HomePopup.ORDERS) {
                            setState(() {
                              tableProvider.homePopup = null;
                            });
                          } else {
                            Provider.of<CategoryProvider>(context,
                                    listen: false)
                                .selectedCategory = null;
                            mainScrollController.animateTo(0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);

                            loadCategories(context);
                            loadPromotions();
                          }
                        },
                        child: tableProvider.homePopup == HomePopup.ORDERS
                            ? Image.asset(
                                "assets/close-gray.png",
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                                scale: 0.9,
                              )
                            : Image.asset(
                                "assets/home_icons/home.png",
                                height: 25,
                                width: 25,
                                fit: BoxFit.cover,
                              ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      OrdersWidget(
                        orders: ordersCount,
                        onTap: () => _onOrdersPressed(context),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Consumer<OrdersProvider>(
                        builder: (context, value, child) {
                          return PayBillWidget(
                            tableProvider.availablePayNow
                                ? () {
                                    tableProvider.homePopup = null;
                                    _onPayBillPressed(context);
                                  }
                                : null,
                          );
                        },
                      ),
                      SizedBox(
                        height: 302,
                      ),
                      CallWaiterWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget ordersPage(BuildContext context) {
    final tableProvider = Provider.of<OrdersProvider>(context, listen: false);
    final orderData = tableProvider.order;
    final lang = Provider.of<AppLanguage>(context, listen: false);
    return Row(
      children: <Widget>[
        Container(
          width: 441,
          color: Color(0xfff6f9fc),
          margin: EdgeInsets.only(left: 85),
          padding: EdgeInsets.only(left: 20),
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Text(
                lang.w(
                  Word.orders,
                ),
                style: TextStyle(fontSize: 35, fontFamily: "TimesBold"),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final order = orderData.items[index];
                      return OrderElementPage(
                        order,
                        index,
                        animate: index == 0,
                      );
                    },
                    itemCount: orderData.items.length,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: CupertinoButton(
                          child: Text(
                            "${lang.w(Word.pay_now)} \nGs. ${FlutterMoneyFormatter(amount: orderData.total, settings: MoneyFormatterSettings(thousandSeparator: ".", decimalSeparator: ",")).output.withoutFractionDigits}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontFamily: "SofiaProBold"),
                          ),
                          color: Color(0xfffa456f),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          onPressed: tableProvider.availablePayNow
                              ? () {
                                  tableProvider.homePopup = null;
                                  _onPayBillPressed(context);
                                }
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        child: CupertinoButton(
                          child: Text(
                            lang.w(Word.order_now),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontFamily: "SofiaProBold"),
                          ),
                          color: Color(0xfffa456f),
                          padding: EdgeInsets.symmetric(
                            horizontal: 35,
                          ),
                          onPressed: !orderData.isSendOrderAvailable
                              ? null
                              : () {
                                  tableProvider.homePopup = null;
                                  Provider.of<OrdersProvider>(context,
                                          listen: false)
                                      .orderNow();
                                  showMyDialog(
                                      context: context,
                                      child: SendOrderDialog());
                                },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                Provider.of<OrdersProvider>(widget.context, listen: false)
                    .homePopup = null;
              });
            },
            child: Container(
                decoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.20))),
          ),
        )
      ],
    );
  }

  Widget getBody(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: this._mainPageState,
        builder: (context, value, _) {
          // print("mainPage $value");
          if (!value) {
            return getPromotionsWidget(context);
          }
          return getDishesList(context);
        });
  }

  Widget getCategoriesWidget(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, value, child) {
      if (value.categories == null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoActivityIndicator(
              radius: 20,
            ),
          ],
        );
      } else if (value.categories.length == 0) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text("No se encontraron categorías")],
        );
      } else {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _categoryScrollController,
          child: Row(
            children: List.generate(value.categories.length, (index) {
              return CategoryCard(
                category: value.categories[index],
                categorySelected: value.selectedCategory == null
                    ? null
                    : value.selectedCategory,
                index: index,
              );
            }),
          ),
        );
      }
    });
  }

  Widget getDishesList(BuildContext context) {
    isInHome = false;
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    // print("dishes list");
    return Container(
      height: 515,
      child: Swiper(
        itemCount: categoryProvider.categories.length,
        controller: swiperController,
        onIndexChanged: (index) {
          Provider.of<CategoryProvider>(context, listen: false)
              .selectedCategoryIndex = index;
        },
        itemBuilder: (context, index) {
          return DishPageWidget(categoryProvider.categories[index]);
        },
        index: categoryProvider.selectedCategoryIndex,
      ),
    );
    /*if (_dishesList == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoActivityIndicator(
            radius: 20,
          ),
        ],
      );
    } else if (_dishesList.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.info,
            size: 120,
            color: Colors.grey,
          ),
          Text(
            lang.w(Word.empty_category),
            style: TextStyle(fontSize: 40, fontFamily: "SofiaProLigth"),
          )
        ],
      );
    } else {
      return Wrap(
        children: List.generate(_dishesList.length, (index) {
          return DishWidget(_dishesList[index]);
        }),
      );
    }*/
  }

  Widget getPromotionsWidget(BuildContext context) {
//    final lang = Provider.of<AppLanguage>(context, listen: false);
    List promotions =
        Provider.of<OrdersProvider>(context, listen: false).promotions;
    List ads = _adsList ?? [];
    if (Provider.of<OrdersProvider>(widget.context, listen: false).promotions ==
        null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoActivityIndicator(
            radius: 20,
          ),
        ],
      );
    }
    if (promotions.length == 0) {
      promotions = DEFAULT_PROMOTIONS;
    }
    if (ads.length == 0) {
      ads = DEFAULT_ADS;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextLang(
          Word.promotions,
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesBold"),
        ),
        SizedBox(
          height: 10,
        ),
        PromotionBanner(
          promotions,
          key: Key("promotions"),
        ),
        SizedBox(
          height: 60,
        ),
        TextLang(
          Word.ad,
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: "TimesBold"),
        ),
        if (ads != null)
          SizedBox(
            height: 10,
          ),
        if (ads != null) AdBanner(ads, key: Key("adds")),
      ],
    );
  }

  CategoryProvider categoryProvider;
  @override
  void initState() {
    super.initState();
    Provider.of<OrdersProvider>(widget.context, listen: false).init =
        DateTime.now();
    loadCategories(widget.context);
    loadPromotions();
    categoryProvider =
        Provider.of<CategoryProvider>(widget.context, listen: false);
    categoryProvider.addListener(onCategoryChange);
    final tableProvider =
        Provider.of<OrdersProvider>(widget.context, listen: false);
    //final preferences = Provider.of<Preferences>(widget.context, listen: false);
    if (tableProvider.table == null) {
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        _tableChangePressed(widget.context);
      });
    }

    //  Future.delayed(Duration(milliseconds: 500)).then((value) {
    //     test('helo');
    //   });
  }

  void onCategoryChange() async {
    final value = categoryProvider.selectedCategoryIndex;
    if (value != null && value > -1) {
      swiperController.move(value, animation: false);
    }
    _mainPageState.value = categoryProvider.selectedCategory != null;
    double post = (value ?? 50).toDouble() * 120;
    if (_categoryScrollController.hasClients) {
      _categoryScrollController.animateTo(post,
          duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void showSendOrder(BuildContext context) {
    showMyDialog(context: context, child: SendOrderDialog());
  }

  void showWaiterCalledLogged(BuildContext context) {}

  void _showPayTheBill(BuildContext context) {
    showMyDialog(context: context, child: PayTheBillDialog(context))
        .then((value) {});
  }

  void _showLanguage(BuildContext context) async {
    setState(() {
      showingLanguageDialog = true;
    });
    await showMyDialog(
        context: context,
        child: LanguageDialog(context),
        backColor: Color(0xff555F69).withOpacity(0.15));
    setState(() {
      showingLanguageDialog = false;
    });
  }

  void _showNotifications(BuildContext context) async {
    await showMyDialog(
        context: context,
        child: NotificationsDialog(context),
        backColor: Color(0xff555F69).withOpacity(0.15));
  }

  void showRateTheExperience(BuildContext context) {
    //showMyDialog(context: context, child: RateYourExperienceDialog());
  }

  void loadCategories(BuildContext context) async {
    HttpHandler httpHandler =
        Provider.of<HttpHandler>(widget.context, listen: false);
    final drinksProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    if (drinksProvider.categories == null) {
      final categories = await httpHandler.getCategories();
      drinksProvider.categories = categories;
      for (Category category in categories) {
        category.dishesList = await loadDishFromCategory(httpHandler, category);
      }
      drinksProvider.categories = categories;
    }
  }

  Future<List<Dish>> loadDishFromCategory(
      HttpHandler httpHandler, Category category) async {
    if (category == null) {
      return [];
    }
    return await httpHandler.getDishes(category);
  }

  bool isInHome = false;

  void loadPromotions() async {
    final context = widget.context;
    if (isInHome) {
      return;
    }
    HttpHandler httpHandler = Provider.of<HttpHandler>(context, listen: false);

    setState(() {
      Provider.of<OrdersProvider>(context, listen: false).promotions = null;
      _adsList = null;
    });
    Provider.of<OrdersProvider>(context, listen: false).promotions =
        await httpHandler.getPromotions();
    _adsList = await httpHandler.getAds();
    if (!mounted) return;
    setState(() {});
    isInHome = true;
  }

  void _onOrdersPressed(BuildContext context) {
    if (Provider.of<OrdersProvider>(widget.context, listen: false).homePopup ==
        HomePopup.ORDERS) {
      setState(() {
        Provider.of<OrdersProvider>(widget.context, listen: false).homePopup =
            null;
      });
    } else {
      setState(() {
        Provider.of<OrdersProvider>(widget.context, listen: false).homePopup =
            HomePopup.ORDERS;
      });
    }
  }

  void _onPayBillPressed(BuildContext context) {
    final tableProvider = Provider.of<OrdersProvider>(context, listen: false);
    final orderData = tableProvider.order;
    if (orderData.total > 0) {
      tableProvider.homePopup = null;
      Provider.of<OrdersProvider>(context, listen: false).payTheBill();
      _showPayTheBill(widget.context);
    }
  }

  void _onSelectedCategory(int index) {
    categoryProvider.selectedCategoryIndex = index;
  }

  Widget _getTopMenu(BuildContext context) {
    final notifications =
        Provider.of<OrdersProvider>(context, listen: false).promotions.length;

    Future.delayed(Duration(seconds: 25)).then((value) {
      newNitify = true;
    });

    final drinksProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final lang = Provider.of<AppLanguage>(context, listen: false);
    final tableProvider = Provider.of<OrdersProvider>(context, listen: false);
    final tableName = tableProvider.table == null
        ? "N"
        : tableProvider.table.number.toString();

    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 31),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Color(0xfff6f9fc),
        boxShadow: [
          BoxShadow(
              color: Color(0xfff6f9fc),
              offset: Offset(50, 0),
              blurRadius: 50,
              spreadRadius: 10)
        ],
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 15,
          ),
          Consumer<CategoryProvider>(
            builder: (context, value, child) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Text(
                    (value.selectedCategory == null)
                        ? lang.w(Word.categories)
                        : value.selectedCategory.title,
                    style: TextStyle(
                        fontSize: 30,
                        color: Color(0xff555f69),
                        fontWeight: FontWeight.bold,
                        fontFamily: "TimesBold"),
                  ),
                ),
              );
            },
          ),
          FlatButton(
            onPressed: () {
              _showLanguage(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  lang.w(Word.language).toUpperCase(),
                  style: TextStyle(
                      color: Color(0xff555f69),
                      fontSize: 15,
                      fontFamily: "SofiaPro",
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                  height: 100,
                ),
                Image.asset(
                  "assets/home_icons/earth.png",
                  height: 20.95,
                  width: 20.95,
                  color: showingLanguageDialog ? Color(0xfffa456f) : null,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () => _tableChangePressed(context),
            child: Container(
              height: 20,
              width: 22,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          "assets/home_icons/table_with_number.png"))),
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 5, top: 1),
              child: Text(
                tableName,
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          FutureBuilder(
              future: Future.delayed(Duration(seconds: 25)),
              builder: (c, s) =>
                  s.connectionState == ConnectionState.done || newNitify
                      ? GestureDetector(
                          onTap: () {
                            _showNotifications(context);
                          },
                          child: Container(
                            height: 22,
                            padding: const EdgeInsets.only(right: 60),
                            child: Stack(
                              children: <Widget>[
                                Image.asset(
                                  "assets/home_icons/ring.png",
                                  height: 22,
                                  width: 17.95,
                                  color: notifications > 0
                                      ? null
                                      : ColorPalette.gray,
                                ),
                                if (notifications > 0)
                                  Transform.translate(
                                    offset: Offset(13, -10),
                                    child: Container(
                                      height: 16,
                                      width: 16,
                                      padding: EdgeInsets.only(top: 4),
                                      decoration: BoxDecoration(
                                          color: Color(0xfffa456f),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.white,
                                                offset: Offset(-0.5, 0.5),
                                                blurRadius: 0,
                                                spreadRadius: 2)
                                          ]),
                                      child: Text(
                                        notifications.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ))
                      : Container(
                          height: 22,
                          padding: const EdgeInsets.only(right: 60),
                          child: Stack(
                            children: <Widget>[
                              Image.asset(
                                "assets/home_icons/ring.png",
                                height: 22,
                                width: 17.95,
                                color: ColorPalette.gray,
                              ),
                            ],
                          ),
                        ))
        ],
      ),
    );
  }

  _tableChangePressed(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CodePage();
        });
  }

  getAlertDialog(BuildContext context, Widget child) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: child,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
