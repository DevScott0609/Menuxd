import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../service/http_handler.dart';
import '../../internacionalization/app_language.dart';
import '../../models/table.dart';
import '../../providers/table_provider.dart';
import '../../ui/components/bar_table_widget.dart';
import '../../utils/color_palette.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';

class SelectTablePage extends StatefulWidget {
  final BuildContext context;

  SelectTablePage(this.context);

  @override
  _SelectTablePageState createState() {
    return _SelectTablePageState();
  }
}

class _SelectTablePageState extends State<SelectTablePage> {
  List<RestaurantTable> tablesList;
  List<RestaurantTable> barList = [];
  RestaurantTable selectedTable;

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context);
    return CupertinoPageScaffold(
      backgroundColor: Color(0xfff6f9fc),
      child: Stack(
        children: <Widget>[
          Container(
              height: double.infinity,
              width: 132,
              margin: EdgeInsets.only(top: 110, bottom: 145, left: 695),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircleAvatar(
                    radius: 37.5,
                    backgroundColor: Colors.white,
                  ),
                  CircleAvatar(
                    radius: 37.5,
                    backgroundColor: Colors.white,
                  ),
                  CircleAvatar(
                    radius: 37.5,
                    backgroundColor: Colors.white,
                  ),
                  CircleAvatar(
                    radius: 37.5,
                    backgroundColor: Colors.white,
                  ),
                ],
              )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListView(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 115),
                                  child: Text(
                                    lang.w(Word.select_table),
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: "TimesBold",
                                        color: ColorPalette.gray),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 100),
                                  child: getBody(context),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          SizedBox(
                            width: 132,
                          )
                        ],
                      ),
                    ),
                    //SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 115, right: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: CupertinoButton(
                          child: Text(
                            lang.w(Word.save),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            saveTable(context);
                          },
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xfffa456f),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 122,
              )
            ],
          ),
          Container(
            height: 100,
            width: 110,
            margin: EdgeInsets.only(top: 21),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(38),
                child: Image.asset(
                  "assets/home_icons/home.png",
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 750, bottom: 115, top: 80),
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: double.infinity,
                width: 132,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      offset: Offset(15, 15),
                      blurRadius: 15,
                      color: Colors.black.withOpacity(0.1))
                ]),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListView.builder(
                    itemBuilder: (_, index) {
                      final table = barList[index];
                      return BarTableWidget(
                        table: table,
                        selectedTable: selectedTable,
                        onTableSelected: selectTable,
                      );
                    },
                    itemCount: barList.length,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getBody(BuildContext context) {
    if (tablesList == null) {
      return SizedBox(
        height: 500,
        child: Center(
          child: CupertinoActivityIndicator(
            radius: 20,
          ),
        ),
      );
    } else if (tablesList.length == 0) {
      return SizedBox(
        width: double.infinity,
        height: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error,
              size: 120,
              color: Colors.grey,
            ),
            Text("No se han encontrado mesas")
          ],
        ),
      );
    } else {
      return Wrap(
        children: List.generate(tablesList.length, (index) {
          final RestaurantTable table = tablesList[index];
          return TableWidget(
            table: table,
            onTableSelected: selectTable,
            selectedTable: selectedTable,
          );
        }),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadData(widget.context);
    WidgetsBinding.instance.addPostFrameCallback((val) {
      hideKeyBoard(context);
    });
  }

  void loadData(BuildContext context) async {
    final tables = await Provider.of<HttpHandler>(widget.context).getTables();

    List<RestaurantTable> tables1 = [];
    List<RestaurantTable> tablesBar = [];
    for (RestaurantTable table in tables) {
      if (table.type == "table") {
        tables1.add(table);
      } else {
        tablesBar.add(table);
      }
    }
    tables1.sort((a, b) {
      return a.number.compareTo(b.number);
    });
    barList.sort((a, b) {
      return a.number.compareTo(b.number);
    });
    setState(() {
      this.tablesList = tables1;
      this.barList = tablesBar;
      this.selectedTable = Provider.of<OrdersProvider>(context).table;
    });
    print(tablesBar);
  }

  void selectTable(RestaurantTable table) {
    setState(() {
      selectedTable = table;
    });
  }

  void saveTable(BuildContext context) {
    Provider.of<OrdersProvider>(context).setTable(selectedTable);
    Navigator.of(context).pushReplacementNamed("/hello_page");
  }
}

typedef OnTableSelected = void Function(RestaurantTable table);

class TableWidget extends StatelessWidget {
  final RestaurantTable table;
  final OnTableSelected onTableSelected;
  final RestaurantTable selectedTable;
  TableWidget({this.table, this.onTableSelected, this.selectedTable});

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<AppLanguage>(context);
    return GestureDetector(
      onTap: () {
        onTableSelected(this.table);
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.all(10),
          width: 132,
          height: 128,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: Offset(0, 21),
                blurRadius: 29,
                color: Colors.black.withOpacity(0.1))
          ]),
          child: Card(
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedCrossFade(
                    firstChild: Text(
                      "${table.number}",
                      style: TextStyle(
                          fontSize: 50,
                          color: ColorPalette.melon,
                          fontWeight: FontWeight.bold),
                    ),
                    secondChild: Text(
                      "${table.number}",
                      style: TextStyle(
                          fontSize: 50,
                          color: ColorPalette.gray,
                          fontWeight: FontWeight.bold),
                    ),
                    crossFadeState: this.selectedTable == table
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 300),
                  ),
                  Text(
                    language.w(Word.table),
                    style: TextStyle(
                        color: ColorPalette.gray.withOpacity(0.5),
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
