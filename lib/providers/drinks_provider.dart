import 'package:flutter/cupertino.dart';
import '../service/http_handler.dart';
import '../models/category.dart';
import '../models/dish.dart';
import '../models/promotion.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories;
  Category _selectedCategory;
  bool _isPressedViewAllPromos;

  get selectedCategoryIndex {
    return categories?.indexOf(_selectedCategory) ?? null;
  }

  set selectedCategoryIndex(int index) {
    selectedCategory = categories[index];
  }

  List<Category> get categories => _categories;

  set categories(List<Category> value) {
    _categories = value;
    _isPressedViewAllPromos = false;
    //notifyListeners();
  }

  Category get selectedCategory => _selectedCategory;

  bool get isPressedViewAllPromos => _isPressedViewAllPromos;

  set selectedCategory(Category value) {
    _selectedCategory = value;
    _isPressedViewAllPromos = false;
    notifyListeners();
  }

  set isPressedViewAllPromos(bool value) {
    _isPressedViewAllPromos = value;
    notifyListeners();
  }

  set promotionSelected(Promotion promotion) {
    HttpHandler().getDish(promotion.dishId).then((value) {
      if (value != null) {
        final catId = value.categoryId;
        for (var category in _categories) {
          if (category.id == catId) {
            selectedCategory = category;
            return;
          }
        }
      }
    }).catchError((error) {
      print(error);
    });
  }

  List<Category> suggestedCategory() {
    var list = List<Category>();
    if (selectedCategory == null) {
      return list;
    }
    var l1 = _getCategory(selectedCategory.suggested1);
    var l2 = _getCategory(selectedCategory.suggested2);
    var l3 = _getCategory(selectedCategory.suggested3);
    if (l1 != null) {
      list.add(l1);
    }
    if (l2 != null) {
      list.add(l2);
    }
    if (l3 != null) {
      list.add(l3);
    }
    return list;
  }

  Category _getCategory(int id) {
    for (Category category in categories) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }

  List<Dish> getSuggestedDishes(Category category) {
    List<Dish> suggestedDishes = [];
    for (Dish dish in category.dishesList) {
      if (dish.suggested == true) {
        suggestedDishes.add(dish);
      }
    }
    print("Suggested Dishes Length : ${suggestedDishes.length}");
    return suggestedDishes;
  }

  String imageOfDish(Dish dishToSearch) {
    for (Category category in categories) {
      if (category.dishesList == null) {
        continue;
      }
      for (Dish dish in category.dishesList) {
        if (dish.id == dishToSearch.id) {
          if (dish.pictures != null && dish.pictures.isNotEmpty) {
            return dish.pictures[0];
          }
          return null;
        }
      }
    }
    return null;
  }

  void reset() {
    _selectedCategory = null;
  }
}
