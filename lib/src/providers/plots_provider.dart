import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:las_palmas/api/plotService.dart';
import 'package:las_palmas/models/api/Plot.dart';

class PlotsProvider with ChangeNotifier {
  List<Plot> _plots = [];

  final NAMElIST = 'plots';

  late PlotService plotService;

  PlotsProvider() {
    plotService = PlotService();
  }

  List<Plot> get getPlots => _plots;

  set plots(List<Plot> plots) {
    _plots = plots;
    notifyListeners();
  }

  Future<void> saveData() async {
    const storage = FlutterSecureStorage();
    const options = IOSOptions(accessibility: IOSAccessibility.first_unlock);
    await storage.write(
        key: NAMElIST, value: _plots.join(','), iOptions: options);
  }

  Future<String?> loadData() async {
    try {
      const storage = FlutterSecureStorage();
      final res = await storage.read(key: NAMElIST);
      return res;
    } catch (e) {
      return null;
    }
  }
}
