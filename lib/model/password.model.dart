// To parse this JSON data, do
//
//     final passwordModel = passwordModelFromJson(jsonString);

import 'dart:convert';

import 'prev_pass.model.dart';

PasswordModel passwordModelFromJson(String str) =>
    PasswordModel.fromJson(json.decode(str));

String passwordModelToJson(PasswordModel data) => json.encode(data.toJson());

class PasswordModel {
  final String? id;
  final String? authorId;
  final String? name;
  String? username;
  String? password;
  final String? note;
  final List<String>? tags;
  final List<String>? sharedAccs;
  final DateTime? createDate;
  final DateTime? updateTime;
  List<PrevPassModel>? prevPass;
  final bool? isFav;

  PasswordModel({
    this.id,
    this.authorId,
    this.name,
    this.username,
    this.password,
    this.note,
    this.tags,
    this.sharedAccs,
    this.createDate,
    this.updateTime,
    this.prevPass,
    this.isFav,
  });

  factory PasswordModel.fromJson(Map<String, dynamic> json) => PasswordModel(
        id: json["id"],
        authorId: json["authorId"],
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
        createDate: json["createDate"] == null
            ? null
            : DateTime.parse(json["createDate"]),
        updateTime: json["updateTime"] == null
            ? null
            : DateTime.parse(json["updateTime"]),
        prevPass: json["prevPass"] == null
            ? []
            : List<PrevPassModel>.from(
                json["prevPass"]!.map((x) => PrevPassModel.fromJson(x))),
        isFav: json["isFav"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "authorId": authorId,
        "name": name,
        "username": username,
        "password": password,
        "note": note,
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "sharedAccs": sharedAccs == null
            ? []
            : List<dynamic>.from(sharedAccs!.map((x) => x)),
        "createDate": createDate?.toIso8601String(),
        "updateTime": updateTime?.toIso8601String(),
        "prevPass": prevPass == null
            ? []
            : List<dynamic>.from(prevPass!.map((x) => x.toJson())),
        "isFav": isFav,
      };

  void setPassword(String text) {
    password = text;
  }

  void setUsername(String text) {
    username = text;
  }

  void setPrevPassModel(List<PrevPassModel>? prevPassList) {
    prevPass = prevPassList;
  }
}
