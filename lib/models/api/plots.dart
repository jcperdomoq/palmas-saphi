// To parse this JSON data, do
//
//     final plots = plotsFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

List<Plots> plotsFromJson(String str) =>
    List<Plots>.from(json.decode(str).map((x) => Plots.fromJson(x)));

String plotsToJson(List<Plots> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Plots {
  Plots({
    this.id,
    this.plants = const [],
    this.name,
  });

  String? id;
  List<Plant> plants = [];
  String? name;

  Plots copyWith({
    String? id,
    List<Plant>? plants,
    String? name,
  }) =>
      Plots(
        id: id ?? this.id,
        plants: plants ?? this.plants,
        name: name ?? this.name,
      );

  factory Plots.fromJson(Map<String, dynamic> json) => Plots(
        id: json["_id"],
        plants: List<Plant>.from(json["plants"].map((x) => Plant.fromJson(x))),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "plants": List<dynamic>.from(plants.map((x) => x.toJson())),
        "name": name,
      };

  @override
  String toString() {
    return 'Plots{id: $id, plants: $plants, name: $name}';
  }
}

class Plant {
  Plant({
    this.lng,
    this.lat,
    this.plant,
    this.line,
    this.id,
    this.color,
    this.dniEvaluador,
    this.campania,
    this.ensayo,
    this.bloque,
    this.tratamiento,
    this.circunferencia,
    this.plotId,
    this.plantId,
    this.hojasVerdes,
    this.stpAncho,
    this.stpEspesor,
    this.numeroFoliolos,
    this.largoFoliolos,
    this.anchoFoliolos,
    this.longPeciolo,
    this.longRaquiz,
    this.alturaPlanta,
    this.longArqueo,
    this.deficienciaNutricional,
    this.observacion,
  });

  double? lng;
  double? lat;
  int? plant;
  int? line;
  String? id;
  Color? color;

  /// Fields for reports
  String type = "1";

  String? dniEvaluador;
  String? campania;
  String? ensayo;
  String? bloque;
  String? tratamiento;
  String? circunferencia;

  String? plotId;
  String? plantId;
  String? hojasVerdes;
  String? stpAncho;
  String? stpEspesor;
  String? numeroFoliolos;
  String? largoFoliolos;
  String? anchoFoliolos;
  String? longPeciolo;
  String? longRaquiz;
  String? alturaPlanta;
  String? longArqueo;
  List<String>? deficienciaNutricional;
  String? observacion;

  Plant copyWith({
    double? lng,
    double? lat,
    int? plant,
    int? line,
    String? id,
    Color? color,
    String? dniEvaluador,
    String? campania,
    String? ensayo,
    String? bloque,
    String? tratamiento,
    String? circunferencia,
    String? plotId,
    String? plantId,
    String? hojasVerdes,
    String? stpAncho,
    String? stpEspesor,
    String? numeroFoliolos,
    String? largoFoliolos,
    String? anchoFoliolos,
    String? longPeciolo,
    String? longRaquiz,
    String? alturaPlanta,
    String? longArqueo,
    List<String>? deficienciaNutricional,
    String? observacion,
  }) =>
      Plant(
        lng: lng ?? this.lng,
        lat: lat ?? this.lat,
        plant: plant ?? this.plant,
        line: line ?? this.line,
        id: id ?? this.id,
        color: color ?? this.color,
        dniEvaluador: dniEvaluador ?? this.dniEvaluador,
        campania: campania ?? this.campania,
        ensayo: ensayo ?? this.ensayo,
        bloque: bloque ?? this.bloque,
        tratamiento: tratamiento ?? this.tratamiento,
        circunferencia: circunferencia ?? this.circunferencia,
        plotId: plotId ?? this.plotId,
        plantId: plantId ?? this.plantId,
        hojasVerdes: hojasVerdes ?? this.hojasVerdes,
        stpAncho: stpAncho ?? this.stpAncho,
        stpEspesor: stpEspesor ?? this.stpEspesor,
        numeroFoliolos: numeroFoliolos ?? this.numeroFoliolos,
        largoFoliolos: largoFoliolos ?? this.largoFoliolos,
        anchoFoliolos: anchoFoliolos ?? this.anchoFoliolos,
        longPeciolo: longPeciolo ?? this.longPeciolo,
        longRaquiz: longRaquiz ?? this.longRaquiz,
        alturaPlanta: alturaPlanta ?? this.alturaPlanta,
        longArqueo: longArqueo ?? this.longArqueo,
        deficienciaNutricional:
            deficienciaNutricional ?? this.deficienciaNutricional,
        observacion: observacion ?? this.observacion,
      );

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        lng: json["lng"].toDouble(),
        lat: json["lat"].toDouble(),
        plant: json["plant"],
        line: json["line"],
        id: json["_id"],
        dniEvaluador: json["dni_evaluador"],
        campania: json["campania"],
        ensayo: json["ensayo"],
        bloque: json["bloque"],
        tratamiento: json["tratamiento"],
        circunferencia: json["circunferencia"],
        plotId: json["plot_id"],
        plantId: json["plant_id"],
        hojasVerdes: json["hojas_verdes"],
        stpAncho: json["stp_ancho"],
        stpEspesor: json["stp_espesor"],
        numeroFoliolos: json["numero_foliolos"],
        largoFoliolos: json["largo_foliolos"],
        anchoFoliolos: json["ancho_foliolos"],
        longPeciolo: json["long_peciolo"],
        longRaquiz: json["long_raquiz"],
        alturaPlanta: json["altura_planta"],
        longArqueo: json["long_arqueo"],
        deficienciaNutricional: json["deficienca_natural"],
        observacion: json["observacion"],
      );

  Map<String, dynamic> toJson() => {
        "lng": lng,
        "lat": lat,
        "plant": plant,
        "line": line,
        "_id": id,
        "type": type,
        "dniEvaluador": dniEvaluador,
        "campania": campania,
        "ensayo": ensayo,
        "bloque": bloque,
        "tratamiento": tratamiento,
        "circunferencia": circunferencia,
        "plot_id": plotId,
        "plant_id": plantId,
        "hojas_verdes": hojasVerdes,
        "stp_ancho": stpAncho,
        "stp_espesor": stpEspesor,
        "numero_foliolos": numeroFoliolos,
        "largo_foliolos": largoFoliolos,
        "ancho_foliolos": anchoFoliolos,
        "long_peciolo": longPeciolo,
        "long_raquiz": longRaquiz,
        "altura_planta": alturaPlanta,
        "long_arqueo": longArqueo,
        "deficienca_natural": deficienciaNutricional,
        "observacion": observacion,
      };

  @override
  String toString() {
    return 'Plant{dni: $dniEvaluador, lng: $lng, lat: $lat, plant: $plant, line: $line, id: $id}';
  }
}
