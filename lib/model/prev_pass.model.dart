// To parse this JSON data, do
//
//     final prevPassModel = prevPassModelFromJson(jsonString);

import 'dart:convert';

PrevPassModel prevPassModelFromJson(String str) =>
    PrevPassModel.fromJson(json.decode(str));

String prevPassModelToJson(PrevPassModel data) => json.encode(data.toJson());

class PrevPassModel {
  final String? name;
  final String? username;
  final String? password;
  final String? note;
  final List<String>? tags;
  final List<String>? sharedAccs;
  final DateTime? updateTime;
  final String? updateType;

  PrevPassModel({
    this.name,
    this.username,
    this.password,
    this.note,
    this.tags,
    this.sharedAccs,
    this.updateTime,
    this.updateType,
  });

  factory PrevPassModel.fromJson(Map<String, dynamic> json) => PrevPassModel(
        name: json["name"],
        username: json["username"],
        password: json["password"],
        note: json["note"],
        tags: json["tags"] == null
            ? []
            : List<String>.from(json["tags"]!.map((x) => x)),
        sharedAccs: json["sharedAccs"] == null
            ? []
            : List<String>.from(json["sharedAccs"]!.map((x) => x)),
        updateTime: json["updateTime"] == null
            ? null
            : DateTime.parse(json["updateTime"]),
        updateType: json["updateType"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "password": password,
        "note": note,
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "sharedAccs": sharedAccs == null
            ? []
            : List<dynamic>.from(sharedAccs!.map((x) => x)),
        "updateTime": updateTime?.toIso8601String(),
        "updateType": updateType,
      };
}
