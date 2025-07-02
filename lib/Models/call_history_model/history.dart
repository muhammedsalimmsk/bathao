import 'receiver.dart';

class History {
  String? id;
  String? user;
  Receiver? receiver;
  String? callType;
  DateTime? startAt;
  int? minutesCharged;
  int? coinsDeducted;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  DateTime? endAt;

  History({
    this.id,
    this.user,
    this.receiver,
    this.callType,
    this.startAt,
    this.minutesCharged,
    this.coinsDeducted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.endAt,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
    id: json['_id'] as String?,
    user: json['user'] as String?,
    receiver:
        json['receiver'] == null
            ? null
            : Receiver.fromJson(json['receiver'] as Map<String, dynamic>),
    callType: json['callType'] as String?,
    startAt:
        json['startAt'] == null
            ? null
            : DateTime.parse(json['startAt'] as String),
    minutesCharged: json['minutesCharged'] as int?,
    coinsDeducted: json['coinsDeducted'] as int?,
    createdAt:
        json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
    updatedAt:
        json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
    v: json['__v'] as int?,
    endAt:
        json['endAt'] == null ? null : DateTime.parse(json['endAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user': user,
    'receiver': receiver?.toJson(),
    'callType': callType,
    'startAt': startAt?.toIso8601String(),
    'minutesCharged': minutesCharged,
    'coinsDeducted': coinsDeducted,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
    'endAt': endAt?.toIso8601String(),
  };
}
