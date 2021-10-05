import 'package:provider/provider.dart';
import 'service/http_handler.dart';
import 'internacionalization/app_language.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'providers/drinks_provider.dart';
import 'providers/table_provider.dart';
import 'ui/pages/code_page.dart';
import 'ui/pages/hello_page.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/loading_page.dart';
import 'ui/pages/login_page.dart';
import 'ui/pages/select_client_page.dart';
import 'ui/pages/select_table_page.dart';
import 'utils/preferences.dart';

final _httpHandler = HttpHandler();
final _ordersProvider = OrdersProvider();
final _categoryProvider = CategoryProvider();
final _appLanguage = AppLanguage();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final preferences = Provider.of<Preferences>(context);
    _ordersProvider.preferences = preferences;
    _appLanguage.locale = Locale(preferences.language);

    return MultiProvider(
      providers: [
        Provider<HttpHandler>.value(value: _httpHandler),
        ChangeNotifierProvider<OrdersProvider>.value(value: _ordersProvider),
        ChangeNotifierProvider<AppLanguage>.value(value: _appLanguage),
        ChangeNotifierProvider<CategoryProvider>.value(value: _categoryProvider)
      ],
      child: CupertinoApp(
        title: 'MenuXd',
        theme: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(
              fontFamily: "SofiaProRegular",
              color: Color(0xff555f69),
            ),
          ),
        ),
        initialRoute: "/",
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (BuildContext context) {
            switch (settings.name) {
              case "/":
                return Loadingpage(context: context);
              case "/login":
                return LoginPage(context);
              case "/home_page":
                return HomePage(context);
              case "/hello_page":
                return HelloPage();
              case "/pin":
                return CodePage();
              case "/select_client":
                return SelectClientPage(context);
              case "/tables":
                return SelectTablePage(context);
              default:
                return LoginPage(context);
            }
          });
        },
      ),
    );
  }
}
