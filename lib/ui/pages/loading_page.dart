import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../service/http_handler.dart';
import '../../providers/table_provider.dart';
import '../../utils/preferences.dart';
import 'package:provider/provider.dart';

class Loadingpage extends StatefulWidget {
  final BuildContext context;
  Loadingpage({this.context, Key key}) : super(key: key);

  _LoadingpageState createState() => _LoadingpageState();
}

class _LoadingpageState extends State<Loadingpage> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((val) {
      init(context);
    });
    return CupertinoPageScaffold(
      child: Center(
        child: CupertinoActivityIndicator(
          radius: 40,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void init(BuildContext context) async {
    //final context = scaffoldKey.currentContext;

    final preferences = Provider.of<Preferences>(context);
    final session = preferences.session;
    if (session != null) {
      if (session.accessToken != null) {
        Provider.of<HttpHandler>(context).session = session;
        Provider.of<HttpHandler>(context).restaurantClient =
            preferences.restaurantClient;

        final orderProvider = Provider.of<OrdersProvider>(context);
        if (preferences.order != null) {
          orderProvider.order = preferences.order;
          orderProvider.setTable(preferences.order.table, resetOrder: false);
        }
        Provider.of<HttpHandler>(context).getQuestions().then((list) {
          orderProvider.questions = list;
        }).catchError((error) {
          print(error);
        });
        if (Provider.of<HttpHandler>(context)?.restaurantClient?.name == null) {
          Navigator.pushReplacementNamed(context, "/select_client");
        } else {
          Navigator.pushReplacementNamed(context, "/home_page");
        }
        return;
      }
    }
    Navigator.pushReplacementNamed(context, "/login");
  }
}
