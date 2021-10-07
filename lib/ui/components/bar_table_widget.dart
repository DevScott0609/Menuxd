import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../internacionalization/app_language.dart';
import '../../models/table.dart';
import '../pages/select_table_page.dart';
import '../../utils/color_palette.dart';
import 'package:provider/provider.dart';

class BarTableWidget extends StatelessWidget {
  final RestaurantTable table;
  final OnTableSelected onTableSelected;
  final RestaurantTable selectedTable;
  BarTableWidget({this.table, this.onTableSelected, this.selectedTable});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    return GestureDetector(
      onTap: () {
        onTableSelected(this.table);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 18),
        padding: EdgeInsets.only(bottom: 10, right: 10, left: 10),
        width: 132,
        height: 128,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedCrossFade(
              firstChild: Text(
                "${table.number}",
                style: TextStyle(
                    fontSize: 50,
                    color: Color(0xfffa456f),
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
              lang.w(Word.bar),
              style: TextStyle(
                  color: ColorPalette.gray.withOpacity(0.5), fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
