import 'dart:convert';

List<Plot> plotFromJson(String str) =>
    List<Plot>.from(json.decode(str).map((x) => Plot.fromJson(x)));

String plotToJson(List<Plot> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Plot {
  Plot({
    required this.id,
    required this.plants,
    required this.name,
    required this.v,
  });

  String id;
  List<Plant> plants;
  String name;
  int v;

  factory Plot.fromJson(Map<String, dynamic> json) => Plot(
        id: json["_id"],
        plants: List<Plant>.from(json["plants"].map((x) => Plant.fromJson(x))),
        name: json["name"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "plants": List<dynamic>.from(plants.map((x) => x.toJson())),
        "name": name,
        "__v": v,
      };
}

class Plant {
  Plant({
    required this.lng,
    required this.lat,
    required this.plant,
    required this.line,
    required this.id,
    required this.record,
  });

  double lng;
  double lat;
  int plant;
  int line;
  String id;
  List<Record> record;

  factory Plant.fromJson(Map<String, dynamic> json) => Plant(
        lng: json["lng"].toDouble(),
        lat: json["lat"].toDouble(),
        plant: json["plant"],
        line: json["line"],
        id: json["_id"],
        record:
            List<Record>.from(json["record"].map((x) => Record.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lng": lng,
        "lat": lat,
        "plant": plant,
        "line": line,
        "_id": id,
        "record": List<dynamic>.from(record.map((x) => x.toJson())),
      };
}

class Record {
  Record({
    required this.observacion,
    required this.deficiencaNatural,
    required this.longArqueo,
    required this.alturaPlanta,
    required this.longRaquiz,
    required this.longPeciolo,
    required this.anchoFoliolos,
    required this.largoFoliolos,
    required this.numeroFoliolos,
    required this.stpEspesor,
    required this.stpAncho,
    required this.hojasVerdes,
    required this.type,
    required this.id,
  });

  String observacion;
  List<String> deficiencaNatural;
  int longArqueo;
  int alturaPlanta;
  int longRaquiz;
  int longPeciolo;
  int anchoFoliolos;
  int largoFoliolos;
  int numeroFoliolos;
  int stpEspesor;
  int stpAncho;
  int hojasVerdes;
  String type;
  String id;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        observacion: json["observacion"],
        deficiencaNatural: List<String>.from(json["deficienca_natural"]),
        longArqueo: json["long_arqueo"],
        alturaPlanta: json["altura_planta"],
        longRaquiz: json["long_raquiz"],
        longPeciolo: json["long_peciolo"],
        anchoFoliolos: json["ancho_foliolos"],
        largoFoliolos: json["largo_foliolos"],
        numeroFoliolos: json["numero_foliolos"],
        stpEspesor: json["stp_espesor"],
        stpAncho: json["stp_ancho"],
        hojasVerdes: json["hojas_verdes"],
        type: json["type"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "observacion": observacion,
        "deficienca_natural": List<dynamic>.from(deficiencaNatural),
        "long_arqueo": longArqueo,
        "altura_planta": alturaPlanta,
        "long_raquiz": longRaquiz,
        "long_peciolo": longPeciolo,
        "ancho_foliolos": anchoFoliolos,
        "largo_foliolos": largoFoliolos,
        "numero_foliolos": numeroFoliolos,
        "stp_espesor": stpEspesor,
        "stp_ancho": stpAncho,
        "hojas_verdes": hojasVerdes,
        "type": type,
        "_id": id,
      };
}
