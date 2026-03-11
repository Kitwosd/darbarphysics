// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String? role;
  final String? bio;
  final String? profilePicture;
  final String? academicLevel;

  ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.role,
    this.bio,
    this.profilePicture,
    this.academicLevel,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    phone: json["phone"],
    role: json["role"],
    bio: json["bio"],
    profilePicture: json["profile_picture"],
    academicLevel: json["academic_level"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "phone": phone,
    "role": role,
    "bio": bio,
    "profile_picture": profilePicture,
    "academic_level": academicLevel,
  };

  ProfileModel copyWith({
    int? id,
    String? username,
    String? email,
    String? phone,
    String? role,
    String? bio,
    String? profilePicture,
    String? academicLevel,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      academicLevel: academicLevel ?? this.academicLevel,
      bio: bio ?? this.bio,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
