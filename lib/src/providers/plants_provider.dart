import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:las_palmas/models/cache/cache_key.dart';
import 'package:las_palmas/models/home/category.dart';
import 'package:las_palmas/models/plot/plot.dart';

class PlantsProvider with ChangeNotifier {
  Category? _categoryAreaSelected;
  final List<Category> _categoriesEvaluationSelected = [];
  Map<String, List<Plot>> plotReports = {};

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

  Future<void> saveData({required String key, required String data}) async {
    const storage = FlutterSecureStorage();
    const options = IOSOptions(accessibility: IOSAccessibility.first_unlock);
    await storage.write(key: key, value: data, iOptions: options);
  }

  Future<void> loadPlotReports() async {
    final data = await _loadData(CacheKey.reports.toString());
    if (data != null) {
      Map<String, dynamic> decodeMap = json.decode(data);
      final reports = decode(decodeMap);
      plotReports = reports;
    } else {
      plotReports = {};
    }
  }

  void refreshReports() async {
    await loadPlotReports();
    notifyListeners();
  }

  Map<String, List<Plot>> decode(Map<String, dynamic> data) {
    Map<String, List<Plot>> reports = {};

    data.forEach((key, value) {
      reports[key] = [];
      value.forEach((element) {
        final decodeData = json.decode(element);
        reports[key]!.add(Plot.fromJson(decodeData));
      });
    });
    return reports;
  }

  Map<String, List<String>> encode(Map<String, List<Plot>> reports) {
    final Map<String, List<String>> encoded = {};
    reports.forEach((key, value) {
      encoded[key] = value.map((plot) => jsonEncode(plot.toJson())).toList();
    });
    return encoded;
  }

  Future<String?> _loadData(String key) async {
    try {
      const storage = FlutterSecureStorage();
      final res = await storage.read(key: key);
      return res;
    } catch (e) {
      return null;
    }
  }
}
