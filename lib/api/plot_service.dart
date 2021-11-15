import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:las_palmas/models/api/plots.dart';

class PlotService {
  Future<List<Plots>> getPlots() async {
    final response = await http.get(Uri.parse("https://palmas.ga/plot"));
    if (response.statusCode == 200) {
      List<Plots> plots = [];
      for (var item in json.decode(response.body)) {
        plots.add(Plots.fromJson(item));
      }
      return plots;
    }
    return [];
  }

  Future<void> saveReports(List<Map<String, dynamic>> plants) async {
    await http.post(
      Uri.parse("https://palmas.ga/plot/plant"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(plants),
    );
  }
}
