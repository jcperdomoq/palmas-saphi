import 'package:flutter/material.dart';
import 'package:las_palmas/models/home/category.dart';

class PlantsProvider with ChangeNotifier {
  Category? _categoryAreaSelected;
  final List<Category> _categoriesEvaluationSelected = [];

  Category? get categoryAreaSelected => _categoryAreaSelected;

  set categoryAreaSelected(Category? category) {
    _categoryAreaSelected = category;
    notifyListeners();
  }

  List<Category> get categoriesEvaluationSelected =>
      _categoriesEvaluationSelected;

  addCategoryEvaluationSelected(Category category) {
    if (!categoriesEvaluationSelected.contains(category)) {
      _categoriesEvaluationSelected.add(category);
    } else {
      _categoriesEvaluationSelected.remove(category);
    }
    notifyListeners();
  }

  bool containsForName(String name) {
    return _categoriesEvaluationSelected
            .any((category) => category.name == name) ||
        _categoryAreaSelected?.name == name;
  }
}
