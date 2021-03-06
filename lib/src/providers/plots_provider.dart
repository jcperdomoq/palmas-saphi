import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:las_palmas/api/plot_service.dart';
import 'package:las_palmas/models/api/plantacion.dart';
import 'package:las_palmas/models/api/plots.dart';
import 'package:las_palmas/models/cache/cache_key.dart';
import 'package:las_palmas/models/plot/plot.dart';
import 'package:las_palmas/util/filter_coordinates.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class PlotsProvider with ChangeNotifier {
  Timer? timer;
  final nameList = 'plots';

  late PlotService plotService;
  DateTime syncDateTime = DateTime.now();
  DateTime downloadDateTime = DateTime.now();

  List<Plots> allPlots = [];
  // Parcelas cerca a la distancia configurada
  List<Plots> plots = [];
  List<Plots> plantReports = [];
  Plantacion? plantacion;

  // Features disponibles en mi ubicación
  List<Feature> features = [];

  Position? currentLocation;
  int distanceMeters = 1500;

  String ensayo = '';
  String bloque = '';
  String tratamiento = '';

  final TextEditingController dniController = TextEditingController();
  final TextEditingController campaniaController = TextEditingController();
  final TextEditingController circunferenciaController =
      TextEditingController();
  final TextEditingController lineaController = TextEditingController();
  final TextEditingController plantaController = TextEditingController();
  final TextEditingController hojasVerdesController = TextEditingController();
  final TextEditingController stpAnchoController = TextEditingController();
  final TextEditingController stpEspesorController = TextEditingController();
  final TextEditingController numeroFoliolosController =
      TextEditingController();
  final TextEditingController largoFoliolosController = TextEditingController();
  final TextEditingController anchoFoliolosController = TextEditingController();
  final TextEditingController longPecioloController = TextEditingController();
  final TextEditingController longRaquizController = TextEditingController();
  final TextEditingController alturaPlantaController = TextEditingController();
  final TextEditingController longArqueoController = TextEditingController();
  List<String> deficienciaNutricional = [];
  TextEditingController observacionController = TextEditingController();

  PlotsProvider() {
    plotService = PlotService();
    _determinePosition();

    loadSyncDateTime();
    loadDownloadDateTime();
  }

  loadSyncDateTime() async {
    const storage = FlutterSecureStorage();
    final key = CacheKey.syncDateTime.toString();
    final value = await storage.read(key: key);
    if (value != null) {
      syncDateTime = DateTime.parse(value);
      notifyListeners();
    }
  }

  loadDownloadDateTime() async {
    const storage = FlutterSecureStorage();
    final key = CacheKey.downloadDateTime.toString();
    final value = await storage.read(key: key);
    if (value != null) {
      downloadDateTime = DateTime.parse(value);
      notifyListeners();
    }
  }

  Future<int> loadPlantacionFromServer() async {
    int status = HttpStatus.ok;
    await plotService.getPlantacion().then((response) {
      plantacion = response;
      if (plantacion != null) {
        filterFeaturesByPolygon();
        updateDownloadTime();
        saveData(
          key: nameList,
          data: jsonEncode(plantacion!.toJson()),
        );
      } else {
        status = HttpStatus.internalServerError;
      }
    }).catchError((onError) {
      status = HttpStatus.internalServerError;
      if (onError is SocketException) {
        status = HttpStatus.serviceUnavailable;
      }
      notifyListeners();
    });
    return status;
  }

  Future<int> loadPlotsFromServer() async {
    plots = [];
    allPlots = [];
    int status = HttpStatus.ok;
    await plotService.getPlots().then((response) {
      allPlots = response;
      updateDownloadTime();
      saveData(
        key: nameList,
        data: jsonEncode(List<dynamic>.from(allPlots.map((x) => x.toJson()))),
      );
    }).catchError((onError) {
      status = HttpStatus.internalServerError;
    });
    return status;
  }

  filterFeaturesByPolygon() {
    features = [];
    if (plantacion != null) {
      (plantacion!.plantacion).map((p) {
        p.features.map((f) {
          if (currentLocation != null && f.geometry != null) {
            // features.add(f);
            // f.plantacion = p.name;

            final check = FilterCoordinates.checkIfValidMarker(
                MapLatLng(
                    currentLocation!.latitude, currentLocation!.longitude),
                f.geometry!.coordinates);

            bool hasNearbyPoints = false;
            for (final MapLatLng c in f.geometry!.coordinates) {
              if (calculateDistance(c.latitude, c.longitude,
                      currentLocation!.latitude, currentLocation!.longitude) <
                  distanceMeters) {
                hasNearbyPoints = true;
                break;
              }
            }
            if (check || hasNearbyPoints) {
              features.add(f);
              f.plantacion = p.name;
            }
          }
        }).toList();
      }).toList();
    }
    notifyListeners();
  }

  bool plantIsInspected(Plant p) {
    for (final plot in plantReports) {
      for (final plant in plot.plants) {
        if (p.parcela == plant.parcela &&
            p.campania == plant.campania &&
            p.plantacion == plant.plantacion) {
          return true;
        }
      }
    }
    return false;
  }

  filterPlotsByDistance() {
    // plots = [];
    // for (final plot in allPlots) {
    //   for (final plant in plot.plants) {
    //     if (calculateDistance(
    //           plant.lat!,
    //           plant.lng!,
    //           currentLocation!.latitude,
    //           currentLocation!.longitude,
    //         ).round() <=
    //         distanceMeters) {
    //       if (plots.any((p) => p.id == plot.id)) {
    //         plots.firstWhere((p) => p.id == plot.id).plants.add(plant);
    //       } else {
    //         plots.add(Plots(id: plot.id, name: plot.name, plants: [plant]));
    //       }
    //     }
    //   }
    // }
    // notifyListeners();
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

  /// Permite cargar todas las parcelas que estan en local
  Future<void> loadStorageData() async {
    try {
      const storage = FlutterSecureStorage();
      final res = await storage.read(key: nameList);
      allPlots = res != null
          ? (json.decode(res) as List<dynamic>)
              .map((e) => Plots.fromJson(e))
              .toList()
          : [];
      _determinePosition();
      filterPlotsByDistance();
    } catch (_) {}
  }

  Future<void> loadPlantacionFromStorage() async {
    const storage = FlutterSecureStorage();
    final res = await storage.read(key: nameList);
    plantacion = res != null ? Plantacion.fromJson(json.decode(res)) : null;
    await _determinePosition();
    filterFeaturesByPolygon();
    // filterPlotsByDistance();
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
      updateSyncTime();
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

  Future<int> saveReports(List<Plots> reports) async {
    int status = HttpStatus.ok;
    List<Plant> onlyPlants = [];
    onlyPlants.addAll(reports.map((plot) => plot.plants).expand((i) => i));
    final parseToJson = onlyPlants.map((plant) => plant.toJson()).toList();
    await plotService.saveReports(parseToJson).then((res) {
      if (res == HttpStatus.ok) {
        return status;
      }
      return HttpStatus.internalServerError;
    }).catchError((onError) {
      status = HttpStatus.internalServerError;
      if (onError is SocketException) {
        status = HttpStatus.serviceUnavailable;
      }
      return status;
    });
    return status;
  }

  updateSyncTime() {
    syncDateTime = DateTime.now();
    saveData(
      key: CacheKey.syncDateTime.toString(),
      data: syncDateTime.toString(),
    );
  }

  updateDownloadTime() {
    downloadDateTime = DateTime.now();
    saveData(
      key: CacheKey.downloadDateTime.toString(),
      data: downloadDateTime.toString(),
    );
  }

  resetFields() {
    dniController.text = '';
    campaniaController.text = '';
    ensayo = '';
    bloque = '';
    tratamiento = '';
    circunferenciaController.text = '';
    lineaController.text = '';
    plantaController.text = '';
    hojasVerdesController.text = '';
    stpAnchoController.text = '';
    stpEspesorController.text = '';
    numeroFoliolosController.text = '';
    largoFoliolosController.text = '';
    anchoFoliolosController.text = '';
    longPecioloController.text = '';
    longRaquizController.text = '';
    alturaPlantaController.text = '';
    longArqueoController.text = '';
    deficienciaNutricional = [];
    observacionController.text = '';
  }

  loadPeriodicData() {
    if (timer != null) {
      timer!.cancel();
    }

    loadPlantacionFromStorage();
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      loadPlantacionFromStorage();
    });
  }
}
