import 'user.dart';

class UserDataModel {
  User? user;

  UserDataModel({this.user});

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
    user:
        json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {'user': user?.toJson()};
}
