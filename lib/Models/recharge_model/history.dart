import 'plan.dart';
import 'transaction.dart';

class RechargeHistory {
  Transaction? transaction;
  String? id;
  String? user;
  int? amountOfCoins;
  String? type;
  Plan? plan;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  RechargeHistory({
    this.transaction,
    this.id,
    this.user,
    this.amountOfCoins,
    this.type,
    this.plan,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory RechargeHistory.fromJson(Map<String, dynamic> json) =>
      RechargeHistory(
        transaction:
            json['transaction'] is Map
                ? Transaction.fromJson(
                  json['transaction'] as Map<String, dynamic>,
                )
                : null,
        id: json['_id'] as String?,
        user: json['user'] as String?,
        amountOfCoins: json['amountOfCoins'] as int?,
        type: json['type'] as String?,
        plan:
            json['plan'] == null
                ? null
                : Plan.fromJson(json['plan'] as Map<String, dynamic>),
        createdAt:
            json['createdAt'] == null
                ? null
                : DateTime.parse(json['createdAt'] as String),
        updatedAt:
            json['updatedAt'] == null
                ? null
                : DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
    'transaction': transaction?.toJson(),
    '_id': id,
    'user': user,
    'amountOfCoins': amountOfCoins,
    'type': type,
    'plan': plan?.toJson(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}
