// To parse this JSON data, do
//
//     final dnDSpell = dnDSpellFromJson(jsonString);

import 'dart:convert';

DnDSpell dnDSpellFromJson(String str) => DnDSpell.fromJson(json.decode(str));

String dnDSpellToJson(DnDSpell data) => json.encode(data.toJson());

class DnDSpell {
  DnDSpell({
    this.id,
    this.index,
    this.name,
    this.desc,
    this.higherLevel,
    this.range,
    this.components,
    this.material,
    this.ritual,
    this.duration,
    this.concentration,
    this.castingTime,
    this.level,
    this.attackType,
    //this.damage,
    this.school,
    this.classes,
    this.subclasses,
    this.url,
  });

  String id;
  String index;
  String name;
  List<String> desc;
  List<String> higherLevel;
  String range;
  List<String> components;
  String material;
  bool ritual;
  String duration;
  bool concentration;
  String castingTime;
  int level;
  String attackType;
  //Damage damage;
  School school;
  List<School> classes;
  List<School> subclasses;
  String url;

  factory DnDSpell.fromJson(Map<String, dynamic> json) => DnDSpell(
    id: json["_id"],
    index: json["index"],
    name: json["name"],
    desc: List<String>.from(json["desc"].map((x) => x)),
    higherLevel: List<String>.from(json["higher_level"].map((x) => x)),
    range: json["range"],
    components: List<String>.from(json["components"].map((x) => x)),
    material: json["material"],
    ritual: json["ritual"],
    duration: json["duration"],
    concentration: json["concentration"],
    castingTime: json["casting_time"],
    level: json["level"],
    attackType: json["attack_type"],
    //damage: Damage.fromJson(json["damage"]),
    school: School.fromJson(json["school"]),
    classes: List<School>.from(json["classes"].map((x) => School.fromJson(x))),
    subclasses: List<School>.from(json["subclasses"].map((x) => School.fromJson(x))),
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "index": index,
    "name": name,
    "desc": List<dynamic>.from(desc.map((x) => x)),
    "higher_level": List<dynamic>.from(higherLevel.map((x) => x)),
    "range": range,
    "components": List<dynamic>.from(components.map((x) => x)),
    "material": material,
    "ritual": ritual,
    "duration": duration,
    "concentration": concentration,
    "casting_time": castingTime,
    "level": level,
    "attack_type": attackType,
    //"damage": damage.toJson(),
    "school": school.toJson(),
    "classes": List<dynamic>.from(classes.map((x) => x.toJson())),
    "subclasses": List<dynamic>.from(subclasses.map((x) => x.toJson())),
    "url": url,
  };

  String getHigherLevel() {
    //Error checks if there is no higher level conditions for the spell
    if (higherLevel.isEmpty) {
      return "Nothing";
    } else {
      return higherLevel[0];
    }
  }


}

class School {
  School({
    this.index,
    this.name,
    this.url,
  });

  String index;
  String name;
  String url;

  factory School.fromJson(Map<String, dynamic> json) => School(
    index: json["index"],
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "index": index,
    "name": name,
    "url": url,
  };
}
