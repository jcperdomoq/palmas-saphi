import 'package:flutter/material.dart';

class SettingProvider with ChangeNotifier {
  int _rangeLocation = 0;

  int get rangeLocation => _rangeLocation;

  set rangeLocation(int rangeLocation) {
    _rangeLocation = rangeLocation;
    notifyListeners();
  }
}
