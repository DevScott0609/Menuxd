import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../service/http_handler.dart';
import '../../models/category.dart';
import '../../models/dish.dart';
import '../../providers/drinks_provider.dart';

typedef OnCategorySelected = void Function(int index);

class CategoryCard extends StatefulWidget {
  Category category;
  final Category categorySelected;
  final int index;

  CategoryCard({this.category, this.categorySelected, this.index});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    // print(widget.category.title);
    // print(widget.category.active);
    return GestureDetector(
      onTap: () {
        _onTap(context);
      },
      child: AnimatedOpacity(
        opacity: this.getOpacity(),
        duration: Duration(milliseconds: 250),
        child: Container(
          width: 140,
          height: 102,
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
          padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: Offset(5, 5),
                spreadRadius: 0,
                blurRadius: 20,
              )
            ],
          ),
          child: Stack(
            children: <Widget>[
              Text(
                widget.category.title.substring(
                    0,
                    widget.category.title.length > 18
                        ? 18
                        : widget.category.title.length),
                style: TextStyle(fontSize: 15, fontFamily: "SofiaProBold"),
                //overflow: TextOverflow.ellipsis,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: CachedNetworkImage(
                  imageUrl: widget.category.picture,
                  placeholder: (context, url) => Center(
                    child: CupertinoActivityIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  height: 45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double getOpacity() {
    if (widget.categorySelected == null) {
      return 1;
    } else if (widget.categorySelected == widget.category) {
      return 1;
    } else {
      return 0.4;
    }
  }

  Future<void> _onTap(BuildContext context) async {
   
     HttpHandler httpHandler = Provider.of<HttpHandler>(context);
       
    final drinksProvider = Provider.of<CategoryProvider>(context);
       final categories = await loadDishFromCategory(httpHandler, widget.category);
       drinksProvider.categories[widget.index].dishesList=categories;
       if (widget.category == widget.categorySelected) {
        Provider.of<CategoryProvider>(context).selectedCategory = null;
      } else {
        Provider.of<CategoryProvider>(context).selectedCategory = widget.category;
      }
  }
   Future<List<Dish>> loadDishFromCategory(
      HttpHandler httpHandler, Category category) async {
    if (category == null) {
      return [];
    }
    return await httpHandler.getDishes(category);
  }
}
