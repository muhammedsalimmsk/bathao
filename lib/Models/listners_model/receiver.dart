class Receiver {
  String? id;
  String? fullName;
  String? displayName;
  String? gender;
  List<String>? langs;
  String? status;
  List<String>? interestedCategories;
  String? callType;
  DateTime? dateOfBirth;
  String? profilePic;
  int? audioRate;
  int? videoRate;

  Receiver({
    this.id,
    this.fullName,
    this.displayName,
    this.gender,
    this.langs,
    this.status,
    this.interestedCategories,
    this.callType,
    this.dateOfBirth,
    this.profilePic,
    this.audioRate,
    this.videoRate,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
    id: json['_id'] as String?,
    fullName: json['FullName'] as String?,
    displayName: json['DisplayName'] as String?,
    gender: json['gender'] as String?,
    langs: (json['langs'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    status: json['status'] as String?,
    interestedCategories:
        (json['interestedCategories'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
    callType: json['callType'] as String?,
    dateOfBirth:
        json['dateOfBirth'] == null
            ? null
            : DateTime.parse(json['dateOfBirth']),
    profilePic: json['profilePic'] as String?,
    audioRate: json['audioRate'] as int?,
    videoRate: json['videoRate'] as int?,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'FullName': fullName,
    'DisplayName': displayName,
    'gender': gender,
    'langs': langs,
    'status': status,
    'interestedCategories': interestedCategories,
    'callType': callType,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'profilePic': profilePic,
    'videoRate': videoRate,
    'audioRate': audioRate,
  };
}
