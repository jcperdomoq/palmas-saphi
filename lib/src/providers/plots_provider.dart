import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:las_palmas/api/plot_service.dart';
import 'package:las_palmas/models/api/plots.dart';
import 'package:las_palmas/models/cache/cache_key.dart';
import 'package:las_palmas/models/plot/plot.dart';

class PlotsProvider with ChangeNotifier {
  final nameList = 'plots';

  late PlotService plotService;

  List<Plots> allPlots = [];
  // Parcelas cerca a la distancia configurada
  List<Plots> plots = [];
  List<Plots> plantReports = [];
  Position? currentLocation;
  int distanceMeters = 1500;

  TextEditingController dniController = TextEditingController();
  TextEditingController campaniaController = TextEditingController();
  TextEditingController ensayoController = TextEditingController();
  TextEditingController bloqueController = TextEditingController();
  TextEditingController tratamientoController = TextEditingController();
  TextEditingController circunferenciaController = TextEditingController();

  TextEditingController hojasVerdesController = TextEditingController();
  TextEditingController stpAnchoController = TextEditingController();
  TextEditingController stpEspesorController = TextEditingController();
  TextEditingController numeroFoliolosController = TextEditingController();
  TextEditingController largoFoliolosController = TextEditingController();
  TextEditingController anchoFoliolosController = TextEditingController();
  TextEditingController longPecioloController = TextEditingController();
  TextEditingController longRaquizController = TextEditingController();
  TextEditingController alturaPlantaController = TextEditingController();
  TextEditingController longArqueoController = TextEditingController();
  TextEditingController deficienciaNaturalController = TextEditingController();
  TextEditingController observacionController = TextEditingController();

  PlotsProvider() {
    plotService = PlotService();
    _determinePosition();
  }

  Future<int> loadPlotsFromServer() async {
    plots = [];
    allPlots = [];
    int status = HttpStatus.ok;
    await plotService.getPlots().then((response) {
      allPlots = response;
      // notifyListeners();
      filterPlotsByDistance();
    }).catchError((onError) {
      status = HttpStatus.internalServerError;
    });
    return status;
  }

  filterPlotsByDistance() {
    for (final plot in allPlots) {
      for (final plant in plot.plants) {
        if (calculateDistance(
              plant.lat!,
              plant.lng!,
              currentLocation!.latitude,
              currentLocation!.longitude,
            ).round() <=
            distanceMeters) {
          if (plots.any((p) => p.id == plot.id)) {
            plots.firstWhere((p) => p.id == plot.id).plants.add(plant);
          } else {
            plots.add(Plots(id: plot.id, name: plot.name, plants: [plant]));
          }
        }
      }
    }
    notifyListeners();
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

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    currentLocation = await Geolocator.getCurrentPosition();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a))) * 1000;
  }
}
