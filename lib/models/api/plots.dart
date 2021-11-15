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
  });

  double? lng;
  double? lat;
  int? plant;
  int? line;
  String? id;
  Color? color;

  Plant copyWith({
    double? lng,
    double? lat,
    int? plant,
    int? line,
    String? id,
    Color? color,
  }) =>
      Plant(
        lng: lng ?? this.lng,
        lat: lat ?? this.lat,
        plant: plant ?? this.plant,
        line: line ?? this.line,
        id: id ?? this.id,
        color: color ?? this.color,
      );

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        lng: json["lng"].toDouble(),
        lat: json["lat"].toDouble(),
        plant: json["plant"],
        line: json["line"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "lng": lng,
        "lat": lat,
        "plant": plant,
        "line": line,
        "_id": id,
      };

  @override
  String toString() {
    return 'Plant{lng: $lng, lat: $lat, plant: $plant, line: $line, id: $id}';
  }
}
