// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'user_model.g.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

@JsonSerializable()
class UserModel {
  @JsonKey(name: "isSuccess")
  bool isSuccess;
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "statusCode")
  int statusCode;
  @JsonKey(name: "timestamp")
  String timestamp;
  @JsonKey(name: "data")
  Data data;

  UserModel({
    required this.isSuccess,
    required this.message,
    required this.statusCode,
    required this.timestamp,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: "user")
  User user;
  @JsonKey(name: "token")
  String token;

  Data({
    required this.user,
    required this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: "_id")
  String id;
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "firstName")
  String firstName;
  @JsonKey(name: "lastName")
  String lastName;
  @JsonKey(name: "role")
  String role;
  @JsonKey(name: "branchId")
  String branchId;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.branchId,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
