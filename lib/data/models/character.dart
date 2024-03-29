import 'package:flutter/material.dart';

class Character {
  late int id;
  late String name;
  late String status;
  late String origin;
  late String type;
  late String image;
  late List<dynamic> appearence;

  Character.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    origin = json['origin']['name'];
    type = json['species'];
    image = json['image'];
    appearence = json['episode'];
  }
}
