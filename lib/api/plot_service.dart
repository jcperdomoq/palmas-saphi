import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:las_palmas/models/api/plots.dart';

class PlotService {
  Future<List<Plots>> getPlots() async {
    final response = await http.get(Uri.parse("https://palmas.ga/plot"));
    if (response.statusCode == 200) {
      // final decoded = await jsonDecode(response.body);
      // var list = <Plot>[];
      // for (var item in decoded) {
      //   list.add(Plot.fromJson(item));
      // }
      // return list;
      List<Plots> plots = [];
      for (var item in json.decode(response.body)) {
        plots.add(Plots.fromJson(item));
      }
      return plots;
    }
    return [];
  }
}
