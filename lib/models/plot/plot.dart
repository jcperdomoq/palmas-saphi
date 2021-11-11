import 'dart:ui';

import 'package:las_palmas/util/hex_color.dart';

class Plot {
  String? label;
  Color? color;

  Plot(this.label, this.color);

  Map<String, dynamic> toJson() => {
        'label': label,
        'color': color?.toHex(),
      };

  Plot.fromJson(Map<String, dynamic> parseJson) {
    label = parseJson['label'];
    color = HexColor.fromHex(parseJson['color']);
  }

  @override
  String toString() {
    return 'Plot{label: $label, color: $color}';
  }
}
