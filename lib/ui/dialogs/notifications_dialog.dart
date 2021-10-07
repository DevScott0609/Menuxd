import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../service/http_handler.dart';
import '../../internacionalization/app_language.dart';
import '../../providers/drinks_provider.dart';
import '../../providers/table_provider.dart';
import '../../ui/components/text_lang.dart';
import '../../utils/color_palette.dart';

class NotificationsDialog extends StatefulWidget {
  final BuildContext context;
  NotificationsDialog(this.context);

  @override
  _NotificationsDialogState createState() => _NotificationsDialogState();
}

class _NotificationsDialogState extends State<NotificationsDialog> {
  @override
  @override
  Widget build(BuildContext context) {
    final promotions =
        Provider.of<OrdersProvider>(context, listen: false).notifications;
    return Align(
      alignment: Alignment.topRight,
      child: Transform.translate(
        offset: Offset(5, 25),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 330),
              child: Image.asset(
                "assets/dialogs/triangle.png",
                height: 8,
              ),
            ),
            Card(
              margin: const EdgeInsets.only(right: 20),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: 468.12,
                    maxWidth: 460,
                    minWidth: 160,
                    minHeight: 100),
                child: Padding(
                  padding: EdgeInsets.all(35.0),
                  child: promotions.isNotEmpty ? getList(context) : getEmpty(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSelect(BuildContext context, String value) {
    Navigator.maybePop(context);
  }

  Widget getEmpty() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          child: Icon(
            Icons.not_interested,
            size: 100,
            color: Colors.white,
          ),
          backgroundColor: Colors.grey.withOpacity(0.4),
          radius: 50,
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextLang(
              Word.promotions,
              wordEdit: (word) {
                return word.toUpperCase();
              },
              style: TextStyle(color: Color(0xffAAAFB4), fontSize: 14),
            ),
            TextLang(Word.empty_notifications,
                style: TextStyle(
                    color: Color(0xffAAAFB4),
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }

  Widget getList(BuildContext context) {
    final promotions =
        Provider.of<OrdersProvider>(context, listen: false).promotions;
    HttpHandler httpHandler = Provider.of<HttpHandler>(context, listen: false);
    return ListView.builder(
        itemCount: promotions.length,
        itemBuilder: (context, index) {
          final promotion = promotions[index];
          return NotificationsWidget(
            title: Word.promotions,
            description: promotion.title,
            imagePath: promotion.picture,
            onPressed: () {
              Navigator.pop(context);
              Provider.of<CategoryProvider>(context, listen: false)
                  .promotionSelected = promotion;
              httpHandler.sendPromotionClick(promotion);
            },
          );
        });
  }
}

class NotificationsWidget extends StatelessWidget {
  NotificationsWidget(
      {this.imagePath, this.title, this.description, this.onPressed});
  final String imagePath;
  final Word title;
  final String description;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: ColorPalette.melon,
              backgroundImage: NetworkImage(imagePath),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextLang(
                  title,
                  style: TextStyle(color: Color(0xffAAAFB4), fontSize: 14),
                ),
                Text(description,
                    style: TextStyle(
                        color: Color(0xffAAAFB4),
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
