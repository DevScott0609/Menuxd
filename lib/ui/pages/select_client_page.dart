import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../service/http_handler.dart';
import '../../internacionalization/word.dart';
import '../../models/restaurant_client.dart';
import '../../ui/components/text_lang.dart';
import '../../utils/color_palette.dart';
import '../../utils/preferences.dart';
import '../../utils/utils.dart';
import 'package:provider/provider.dart';

class SelectClientPage extends StatefulWidget {
  final BuildContext context;
  SelectClientPage(this.context, {Key key}) : super(key: key);

  @override
  _SelectClientPageState createState() => _SelectClientPageState();
}

class _SelectClientPageState extends State<SelectClientPage> {
  String password = "";
  List<RestaurantClient> clientsList;
  RestaurantClient selectedClient;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: getBody(context),
    ));
  }

  Widget getBody(BuildContext context) {
    if (clientsList == null) {
      return Center(
        child: CupertinoActivityIndicator(
          radius: 20,
        ),
      );
    } else if (clientsList.length == 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.error),
            TextLang(Word.error_clients_dont_found)
          ],
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextLang(
                Word.select_your_local,
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: "TimesBold",
                    color: ColorPalette.gray),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                children: List.generate(clientsList.length, (index) {
                  final client = clientsList[index];
                  return ClientWidget(
                    value: client,
                    groupValue: selectedClient,
                    onChange: (value) {
                      setState(() {
                        selectedClient = value;
                      });
                    },
                  );
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70, right: 70),
            child: SizedBox(
              width: double.infinity,
              height: 80,
              child: CupertinoButton(
                child: TextLang(
                  Word.save,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: selectedClient == null
                    ? null
                    : () {
                        selectClient(context);
                      },
                borderRadius: BorderRadius.circular(10),
                color: Color(0xfffa456f),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  void initState() {
    Provider.of<HttpHandler>(widget.context)
        .getRestaurantsClients()
        .then((list) {
      setState(() {
        clientsList = list.map((element) {
          return element as RestaurantClient;
        }).toList();
      });
    }).catchError((error) {
      print(error);
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((val) {
      hideKeyBoard(context);
    });
  }

  void selectClient(BuildContext context) {
    Provider.of<Preferences>(context, listen: false).restaurantClient =
        selectedClient;
    Provider.of<HttpHandler>(context, listen: false).restaurantClient =
        selectedClient;
    Navigator.pushReplacementNamed(context, "/");
  }
}

class ClientWidget extends StatelessWidget {
  final RestaurantClient value;
  final RestaurantClient groupValue;
  final ValueChanged<RestaurantClient> onChange;

  ClientWidget({this.value, this.groupValue, this.onChange});

  @override
  Widget build(BuildContext context) {
    final selected = this.groupValue == value;
    return Container(
      height: 400,
      width: 400,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? ColorPalette.melon : Colors.transparent,
              width: 10)),
      margin: EdgeInsets.only(right: 20),
      child: RaisedButton(
        onPressed: () {
          selectClient(context);
        },
        padding: EdgeInsets.all(0),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Image.network(
              value.picture,
              fit: BoxFit.cover,
              height: 400,
              width: 400,
            ),
            Container(
              width: double.infinity,
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.all(20),
              child: Text(
                value.name,
                style: TextStyle(color: Colors.white, fontSize: 25),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  void selectClient(BuildContext context) {
    onChange(value);
  }
}
