import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:las_palmas/api/plot_service.dart';
import 'package:las_palmas/models/api/plots.dart';
import 'package:las_palmas/models/cache/cache_key.dart';
import 'package:las_palmas/models/plot/plot.dart';

class PlotsProvider with ChangeNotifier {
  final nameList = 'plots';

  late PlotService plotService;

  List<Plots> plots = [];
  List<Plots> plantReports = [];

  PlotsProvider() {
    plotService = PlotService();
  }

  Future<int> loadPlotsFromServer() async {
    int status = HttpStatus.ok;
    await plotService.getPlots().then((response) {
      plots = response;
      notifyListeners();
    }).catchError((onError) {
      status = HttpStatus.internalServerError;
    });
    return status;
  }

  /// Permite asignar el color de las parcelas y plantas
  /// si existen en la lista de reports
  loadColorPlots(List<Plots> reports) {
    for (final plot in plots) {
      for (final reportPlot in reports) {
        if (plot.id == reportPlot.id) {
          for (final reportPlant in reportPlot.plants) {
            try {
              final plant =
                  plot.plants.firstWhere((plant) => plant.id == reportPlant.id);
              plant.color = const Color(0xFF00C347);
            } catch (_) {}
          }
        }
      }
    }
    if (reports.isEmpty) {
      for (final plot in plots) {
        for (final plant in plot.plants) {
          print('plant: ${plant.plant}, lat: ${plant.lat}, long: ${plant.lng}');
          plant.color = const Color(0xFFF92B77);
        }
      }
    }
    notifyListeners();
  }

  Future<void> saveStorageData() async {
    const storage = FlutterSecureStorage();
    const options = IOSOptions(accessibility: IOSAccessibility.first_unlock);
    await storage.write(
        key: nameList, value: jsonEncode(plots), iOptions: options);
  }

  Future<String?> loadStorageData() async {
    try {
      const storage = FlutterSecureStorage();
      final res = await storage.read(key: nameList);
      return res;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveData({required String key, required String data}) async {
    const storage = FlutterSecureStorage();
    const options = IOSOptions(accessibility: IOSAccessibility.first_unlock);
    await storage.write(key: key, value: data, iOptions: options);
  }

  Future<void> loadPlotReports() async {
    final data = await _loadData(CacheKey.reports.toString());
    print(data);
    plantReports = data != null
        ? (json.decode(data) as List<dynamic>)
            .map((plot) => Plots.fromJson(plot))
            .toList()
        : [];
    // if (data != null) {
    //   Map<String, dynamic> decodeMap = json.decode(data);
    //   final reports = decode(decodeMap);
    //   plantReports= reports;
    // } else {
    //   plotReports = {};
    // }
  }

  void refreshReports() async {
    await loadPlotReports();
    notifyListeners();
  }

  Map<String, List<Plant>> decode(Map<String, dynamic> data) {
    Map<String, List<Plant>> reports = {};

    data.forEach((key, value) {
      reports[key] = [];
      value.forEach((element) {
        final decodeData = json.decode(element);
        reports[key]!.add(Plant.fromJson(decodeData));
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

  Future<void> clearReports() async {
    try {
      const storage = FlutterSecureStorage();
      await storage.delete(key: CacheKey.reports.toString());
    } catch (_) {}
  }
}
