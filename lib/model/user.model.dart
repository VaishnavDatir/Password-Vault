// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  final String? id;
  final String? name;
  final String? mobileNo;
  final String? emailId;
  final DateTime? signUpDate;
  final bool? isActive;
  final DateTime? deleteDate;
  final List<String>? savedPasswords;

  UserModel({
    this.id,
    this.name,
    this.mobileNo,
    this.emailId,
    this.signUpDate,
    this.isActive,
    this.deleteDate,
    this.savedPasswords,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        mobileNo: json["mobileNo"],
        emailId: json["emailId"],
        signUpDate: json["signUpDate"] == null
            ? null
            : DateTime.parse(json["signUpDate"]),
        isActive: json["isActive"],
        deleteDate: json["deleteDate"] == null
            ? null
            : DateTime.parse(json["deleteDate"]),
        savedPasswords: json["savedPasswords"] == null
            ? []
            : List<String>.from(json["savedPasswords"]!.map((x) => (x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobileNo": mobileNo,
        "emailId": emailId,
        "signUpDate": signUpDate?.toIso8601String(),
        "isActive": isActive,
        "deleteDate": deleteDate?.toIso8601String(),
        "savedPasswords": savedPasswords == null
            ? []
            : List<String>.from(savedPasswords!.map((x) => x)),
      };
}
