// To parse this JSON data, do
//
//     final getUsersModel = getUsersModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'get_user_model.g.dart';

GetUsersModel getUsersModelFromJson(String str) =>
    GetUsersModel.fromJson(json.decode(str));

String getUsersModelToJson(GetUsersModel data) => json.encode(data.toJson());

@JsonSerializable()
class GetUsersModel {
  @JsonKey(name: "isSuccess")
  bool isSuccess;
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "statusCode")
  int statusCode;
  @JsonKey(name: "timestamp")
  String timestamp;
  @JsonKey(name: "data")
  GetUsersModelData data;

  GetUsersModel({
    required this.isSuccess,
    required this.message,
    required this.statusCode,
    required this.timestamp,
    required this.data,
  });

  factory GetUsersModel.fromJson(Map<String, dynamic> json) =>
      _$GetUsersModelFromJson(json);

  Map<String, dynamic> toJson() => _$GetUsersModelToJson(this);
}

@JsonSerializable()
class GetUsersModelData {
  @JsonKey(name: "data")
  List<GetUsersModelDataPerson> data;
  @JsonKey(name: "pagination")
  Pagination pagination;

  GetUsersModelData({
    required this.data,
    required this.pagination,
  });

  factory GetUsersModelData.fromJson(Map<String, dynamic> json) =>
      _$GetUsersModelDataFromJson(json);

  Map<String, dynamic> toJson() => _$GetUsersModelDataToJson(this);
}

@JsonSerializable()
class GetUsersModelDataPerson {
  @JsonKey(name: "address")
  Address? address;
  @JsonKey(name: "_id")
  String id;
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "firstName")
  String firstName;
  @JsonKey(name: "lastName")
  String lastName;
  @JsonKey(name: "phoneNumber")
  PhoneNumber? phoneNumber;
  @JsonKey(name: "role")
  String role;
  @JsonKey(name: "branchId")
  BranchId? branchId;
  @JsonKey(name: "isActive")
  bool isActive;
  @JsonKey(name: "rewardPoints")
  int rewardPoints;
  @JsonKey(name: "appointmentHistory")
  List<dynamic> appointmentHistory;
  @JsonKey(name: "isHaveResource")
  bool isHaveResource;
  @JsonKey(name: "createdAt")
  String createdAt;
  @JsonKey(name: "updatedAt")
  String updatedAt;
  @JsonKey(name: "__v")
  int v;
  @JsonKey(name: "resourceId")
  String? resourceId;
  @JsonKey(name: "lastLogin")
  String? lastLogin;

  GetUsersModelDataPerson({
    this.address,
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.role,
    required this.branchId,
    required this.isActive,
    required this.rewardPoints,
    required this.appointmentHistory,
    required this.isHaveResource,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.resourceId,
    this.lastLogin,
  });

  factory GetUsersModelDataPerson.fromJson(Map<String, dynamic> json) =>
      _$GetUsersModelDataPersonFromJson(json);

  Map<String, dynamic> toJson() => _$GetUsersModelDataPersonToJson(this);
}

@JsonSerializable()
class Address {
  @JsonKey(name: "street")
  String street;
  @JsonKey(name: "city")
  String city;
  @JsonKey(name: "state")
  String state;
  @JsonKey(name: "postalCode")
  String postalCode;
  @JsonKey(name: "country")
  String country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class BranchId {
  @JsonKey(name: "_id")
  String id;

  BranchId({
    required this.id,
  });

  factory BranchId.fromJson(Map<String, dynamic> json) =>
      _$BranchIdFromJson(json);

  Map<String, dynamic> toJson() => _$BranchIdToJson(this);
}

@JsonSerializable()
class PhoneNumber {
  @JsonKey(name: "countryCode")
  String countryCode;
  @JsonKey(name: "number")
  String number;

  PhoneNumber({
    required this.countryCode,
    required this.number,
  });

  factory PhoneNumber.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneNumberToJson(this);
}

@JsonSerializable()
class Pagination {
  @JsonKey(name: "total")
  int total;
  @JsonKey(name: "page")
  int page;
  @JsonKey(name: "limit")
  int limit;
  @JsonKey(name: "totalPages")
  int totalPages;
  @JsonKey(name: "hasNextPage")
  bool hasNextPage;
  @JsonKey(name: "hasPrevPage")
  bool hasPrevPage;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
