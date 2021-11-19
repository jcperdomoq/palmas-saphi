// To parse this JSON data, do
//
//     final plantacion = plantacionFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:syncfusion_flutter_maps/maps.dart';

Plantacion plantacionFromJson(String str) =>
    Plantacion.fromJson(json.decode(str));

String plantacionToJson(Plantacion data) => json.encode(data.toJson());

class Plantacion {
  Plantacion({
    this.plantacion = const [],
  });

  List<PlantacionElement> plantacion;

  Plantacion copyWith({
    List<PlantacionElement>? plantacion,
  }) =>
      Plantacion(
        plantacion: plantacion ?? this.plantacion,
      );

  factory Plantacion.fromJson(Map<String, dynamic> json) => Plantacion(
        plantacion: List<PlantacionElement>.from(
            json["plantacion"].map((x) => PlantacionElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "plantacion": List<dynamic>.from(plantacion),
      };
}

class PlantacionElement {
  PlantacionElement({
    this.type,
    this.name,
    this.features = const [],
  });

  String? type;
  String? name;
  List<Feature> features;

  PlantacionElement copyWith({
    String? type,
    String? name,
    List<Feature>? features,
  }) =>
      PlantacionElement(
        type: type ?? this.type,
        name: name ?? this.name,
        features: features ?? this.features,
      );

  factory PlantacionElement.fromJson(Map<String, dynamic> json) {
    return PlantacionElement(
      type: json["type"],
      name: json["name"],
      features:
          List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "name": name,
        "features": List<dynamic>.from(features),
      };
}

class Feature {
  Feature({
    this.type,
    this.properties,
    this.geometry,
    this.plantacion = "",
  });

  String? plantacion;
  FeatureType? type;
  Properties? properties;
  Geometry? geometry;

  Feature copyWith({
    FeatureType? type,
    Properties? properties,
    Geometry? geometry,
    String? plantacion,
  }) =>
      Feature(
        type: type ?? this.type,
        properties: properties ?? this.properties,
        geometry: geometry ?? this.geometry,
        plantacion: plantacion ?? this.plantacion,
      );

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      type: featureTypeValues.map?[json["type"]],
      properties: Properties.fromJson(json["properties"]),
      geometry: Geometry.fromJson(json["geometry"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "type": featureTypeValues.reverse[type],
        "properties": properties?.toJson(),
        "geometry": geometry?.toJson(),
      };
}

class Geometry {
  Geometry({
    this.type,
    this.coordinates = const [],
  });

  GeometryType? type;
  List<MapLatLng> coordinates;

  Geometry copyWith({
    GeometryType? type,
    List<MapLatLng>? coordinates,
  }) =>
      Geometry(
        type: type ?? this.type,
        coordinates: coordinates ?? this.coordinates,
      );

  factory Geometry.fromJson(Map<String, dynamic> json) {
    final List<MapLatLng> coordinates = [];

    // List<List<dynamic>>.from(
    //     json["coordinates"].map((x) => List<dynamic>.from(x.map((x) {
    //           print(x);
    //           if (x[0].runtimeType.toString() == 'double' ||
    //               x[0].runtimeType.toString() == 'int') {
    //             coordinates.add(MapLatLng(x[1].toDouble(), x[0].toDouble()));
    //           }
    //         }))));
    json["coordinates"].forEach((e) {
      // if (e.runtimeType.toString() == 'String') {
      //   e = e.split(',');
      // }
      if (e.runtimeType.toString() == 'String') {
        e = e.replaceAll('[', '').replaceAll(']', '').split(',');
        coordinates.add(MapLatLng(double.parse(e[0]), double.parse(e[1])));
        return;
      }
      e.forEach((x) {
        if (x[0].runtimeType.toString() == 'double' ||
            x[0].runtimeType.toString() == 'int') {
          coordinates.add(MapLatLng(x[1].toDouble(), x[0].toDouble()));
        }
      });
    });

    return Geometry(
      type: geometryTypeValues.map?[json["type"]],
      coordinates: List<MapLatLng>.from(coordinates),
    );
  }

  Map<String, dynamic> toJson() {
    // print('que mierda $coordinates');
    final coorToJson = [];
    for (final x in coordinates) {
      final temp = [x.latitude, x.longitude];
      coorToJson.add(jsonEncode(temp));
    }
    // print(coorToJson);
    return {
      "type": geometryTypeValues.reverse[type],
      "coordinates": coorToJson,
    };
  }
}

enum GeometryType { POLYGON, MULTI_POLYGON }

final geometryTypeValues = EnumValues({
  "MultiPolygon": GeometryType.MULTI_POLYGON,
  "Polygon": GeometryType.POLYGON
});

class Properties {
  Properties({
    this.objectid,
    this.empresa,
    this.cultivo,
    this.sector,
    this.auxiliar,
    this.campaa,
    this.parcela,
    this.codeParce,
    this.reaNeta,
    this.shapeLeng,
    this.shapeArea,
    this.rend2020,
    this.rend2019,
    this.rend2018,
    this.rend2017,
    this.rend2016,
    this.rend2015,
    this.rend2014,
    this.simbo,
    this.poda,
    this.interlinea,
    this.simbPoda,
    this.cQuimico,
    this.labelParce,
    this.cruzamient,
    this.codifica,
    this.rend2021,
    this.criticidad,
    this.criticid1,
    this.tipo,
    this.criticid2,
    this.criticid3,
    this.condicin,
    this.siembra,
    this.rend2013,
    this.rend2012,
    this.rend2011,
    this.rend2010,
    this.rend2009,
  });

  String? objectid;
  String? empresa;
  String? cultivo;
  Sector? sector;
  String? auxiliar;
  String? campaa;
  String? parcela;
  String? codeParce;
  String? reaNeta;
  String? shapeLeng;
  String? shapeArea;
  String? rend2020;
  String? rend2019;
  String? rend2018;
  String? rend2017;
  String? rend2016;
  String? rend2015;
  String? rend2014;
  String? simbo;
  String? poda;
  String? interlinea;
  String? simbPoda;
  String? cQuimico;
  String? labelParce;
  String? cruzamient;
  String? codifica;
  String? rend2021;
  Criticid? criticidad;
  Criticid? criticid1;
  Tipo? tipo;
  Criticid? criticid2;
  Criticid? criticid3;
  String? condicin;
  String? siembra;
  String? rend2013;
  String? rend2012;
  String? rend2011;
  String? rend2010;
  String? rend2009;

  Properties copyWith({
    String? objectid,
    String? empresa,
    String? cultivo,
    Sector? sector,
    String? auxiliar,
    String? campaa,
    String? parcela,
    String? codeParce,
    String? reaNeta,
    String? shapeLeng,
    String? shapeArea,
    String? rend2020,
    String? rend2019,
    String? rend2018,
    String? rend2017,
    String? rend2016,
    String? rend2015,
    String? rend2014,
    String? simbo,
    String? poda,
    String? interlinea,
    String? simbPoda,
    String? cQuimico,
    String? labelParce,
    String? cruzamient,
    String? codifica,
    String? rend2021,
    Criticid? criticidad,
    Criticid? criticid1,
    Tipo? tipo,
    Criticid? criticid2,
    Criticid? criticid3,
    String? condicin,
    String? siembra,
    String? rend2013,
    String? rend2012,
    String? rend2011,
    String? rend2010,
    String? rend2009,
  }) =>
      Properties(
        objectid: objectid ?? this.objectid,
        empresa: empresa ?? this.empresa,
        cultivo: cultivo ?? this.cultivo,
        sector: sector ?? this.sector,
        auxiliar: auxiliar ?? this.auxiliar,
        campaa: campaa ?? this.campaa,
        parcela: parcela ?? this.parcela,
        codeParce: codeParce ?? this.codeParce,
        reaNeta: reaNeta ?? this.reaNeta,
        shapeLeng: shapeLeng ?? this.shapeLeng,
        shapeArea: shapeArea ?? this.shapeArea,
        rend2020: rend2020 ?? this.rend2020,
        rend2019: rend2019 ?? this.rend2019,
        rend2018: rend2018 ?? this.rend2018,
        rend2017: rend2017 ?? this.rend2017,
        rend2016: rend2016 ?? this.rend2016,
        rend2015: rend2015 ?? this.rend2015,
        rend2014: rend2014 ?? this.rend2014,
        simbo: simbo ?? this.simbo,
        poda: poda ?? this.poda,
        interlinea: interlinea ?? this.interlinea,
        simbPoda: simbPoda ?? this.simbPoda,
        cQuimico: cQuimico ?? this.cQuimico,
        labelParce: labelParce ?? this.labelParce,
        cruzamient: cruzamient ?? this.cruzamient,
        codifica: codifica ?? this.codifica,
        rend2021: rend2021 ?? this.rend2021,
        criticidad: criticidad ?? this.criticidad,
        criticid1: criticid1 ?? this.criticid1,
        tipo: tipo ?? this.tipo,
        criticid2: criticid2 ?? this.criticid2,
        criticid3: criticid3 ?? this.criticid3,
        condicin: condicin ?? this.condicin,
        siembra: siembra ?? this.siembra,
        rend2013: rend2013 ?? this.rend2013,
        rend2012: rend2012 ?? this.rend2012,
        rend2011: rend2011 ?? this.rend2011,
        rend2010: rend2010 ?? this.rend2010,
        rend2009: rend2009 ?? this.rend2009,
      );

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        objectid: "${json["OBJECTID"]}",
        empresa: "${json["Empresa"]}",
        cultivo: "${json["Cultivo"]}",
        sector: sectorValues.map?[json["Sector"]],
        auxiliar: "${json["Auxiliar"]}",
        campaa: "${json["Campaña"]}",
        parcela: "${json["Parcela"]}",
        codeParce: "${json["Code_parce"]}",
        reaNeta: "${json["Área_neta"]}",
        shapeLeng: "${json["SHAPE_Leng"]}",
        shapeArea: "${json["SHAPE_Area"]}",
        rend2020: "${json["Rend2020"]}",
        rend2019: "${json["Rend2019"]}",
        rend2018: "${json["Rend2018"]}",
        rend2017: "${json["Rend2017"]}",
        rend2016: "${json["Rend2016"]}",
        rend2015: "${json["Rend2015"]}",
        rend2014: "${json["Rend2014"]}",
        simbo: "${json["Simbo"]}",
        poda: "${json["Poda"]}",
        interlinea: "${json["Interlinea"]}",
        simbPoda: "${json["SimbPoda"]}",
        cQuimico: "${json["CQuimico"]}",
        labelParce: "${json["LabelParce"]}",
        cruzamient: "${json["Cruzamient"]}",
        codifica: "${json["Codifica"]}",
        rend2021: "${json["Rend2021"]}",
        criticidad: json["Criticidad"] == null
            ? null
            : criticidValues.map?[json["Criticidad"]],
        criticid1: json["Criticid_1"] == null
            ? null
            : criticidValues.map?[json["Criticid_1"]],
        tipo: json["Tipo"] == null ? null : tipoValues.map?[json["Tipo"]],
        criticid2: json["Criticid_2"] == null
            ? null
            : criticidValues.map?[json["Criticid_2"]],
        criticid3: json["Criticid_3"] == null
            ? null
            : criticidValues.map?[json["Criticid_3"]],
        condicin: "${json["Condición"]}",
        siembra: "${json["Siembra"]}",
        rend2013: "${json["Rend2013"]}",
        rend2012: "${json["Rend2012"]}",
        rend2011: "${json["Rend2011"]}",
        rend2010: "${json["Rend2010"]}",
        rend2009: "${json["Rend2009"]}",
      );

  Map<String, dynamic> toJson() => {
        "OBJECTID": objectid,
        "Empresa": empresa,
        "Cultivo": cultivo,
        "Sector": sectorValues.reverse[sector],
        "Auxiliar": auxiliar,
        "Campaña": campaa,
        "Parcela": parcela,
        "Code_parce": codeParce,
        "Área_neta": reaNeta,
        "SHAPE_Leng": shapeLeng,
        "SHAPE_Area": shapeArea,
        "Rend2020": rend2020,
        "Rend2019": rend2019,
        "Rend2018": rend2018,
        "Rend2017": rend2017,
        "Rend2016": rend2016,
        "Rend2015": rend2015,
        "Rend2014": rend2014,
        "Simbo": simbo,
        "Poda": poda,
        "Interlinea": interlinea,
        "SimbPoda": simbPoda,
        "CQuimico": cQuimico,
        "LabelParce": labelParce,
        "Cruzamient": cruzamient,
        "Codifica": codifica,
        "Rend2021": rend2021,
        "Criticidad":
            criticidad == null ? null : criticidValues.reverse[criticidad],
        "Criticid_1":
            criticid1 == null ? null : criticidValues.reverse[criticid1],
        "Tipo": tipo == null ? null : tipoValues.reverse[tipo],
        "Criticid_2":
            criticid2 == null ? null : criticidValues.reverse[criticid2],
        "Criticid_3":
            criticid3 == null ? null : criticidValues.reverse[criticid3],
        "Condición": condicin,
        "Siembra": siembra,
        "Rend2013": rend2013,
        "Rend2012": rend2012,
        "Rend2011": rend2011,
        "Rend2010": rend2010,
        "Rend2009": rend2009,
      };
}

enum Criticid { CRTICO, REALIZADO, MODERADO, MUY_CRTICO }

final criticidValues = EnumValues({
  "Crítico": Criticid.CRTICO,
  "Moderado": Criticid.MODERADO,
  "Muy Crítico": Criticid.MUY_CRTICO,
  "Realizado": Criticid.REALIZADO
});

enum Sector { SE02, SE01, SE04, SE03, CA01, SE4_F, CA02, SE05 }

final sectorValues = EnumValues({
  "CA01": Sector.CA01,
  "CA02": Sector.CA02,
  "SE01": Sector.SE01,
  "SE02": Sector.SE02,
  "SE03": Sector.SE03,
  "SE04": Sector.SE04,
  "SE05": Sector.SE05,
  "SE4F": Sector.SE4_F
});

enum Tipo { MECANIZADO, MANUAL }

final tipoValues =
    EnumValues({"Manual": Tipo.MANUAL, "Mecanizado": Tipo.MECANIZADO});

enum FeatureType { Feature }

final featureTypeValues = EnumValues({"Feature": FeatureType.Feature});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null && map != null) {
      reverseMap = map!.map((k, v) => MapEntry(v, k));
    }
    return reverseMap ?? {};
  }
}
