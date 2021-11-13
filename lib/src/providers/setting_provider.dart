import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:las_palmas/models/api/Plot.dart';

class SettingProvider with ChangeNotifier {
  int _rangeLocation = 0;

  int get rangeLocation => _rangeLocation;

  set rangeLocation(int rangeLocation) {
    _rangeLocation = rangeLocation;
    notifyListeners();
  }
}
