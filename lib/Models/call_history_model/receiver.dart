class Receiver {
  String? id;
  String? fullName;
  String? displayName;
  String? profilePic;

  Receiver({this.id, this.fullName, this.displayName, this.profilePic});

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
    id: json['_id'] as String?,
    fullName: json['FullName'] as String?,
    displayName: json['DisplayName'] as String?,
    profilePic: json['profilePic'] as String?,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'FullName': fullName,
    'DisplayName': displayName,
    'profilePic': profilePic,
  };
}
