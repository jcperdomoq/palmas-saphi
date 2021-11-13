import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:las_palmas/models/api/Plot.dart';

class PlotService {
  Future<List<Plot>> getPlots() async {
    final response = await http.get(new Uri.http("10.0.2.2:3000", '/plot'));
    if (response.statusCode == 200) {
      final decoded = await jsonDecode(response.body);
      var list = <Plot>[];
      for (var item in decoded) {
        list.add(Plot.fromJson(item));
      }
      return list;
    }
    return [];
  }
}
