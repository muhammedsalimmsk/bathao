class UserModel {
  String? token;
  String? message;

  UserModel({this.token, this.message});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    token: json['token'] as String?,
    message: json['message'] as String?,
  );

  Map<String, dynamic> toJson() => {'token': token, 'message': message};
}
