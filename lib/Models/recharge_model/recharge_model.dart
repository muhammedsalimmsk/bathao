import 'history.dart';

class RechargeModel {
  List<RechargeHistory>? history;
  int? total;
  int? totalPages;
  int? currentPage;

  RechargeModel({this.history, this.total, this.totalPages, this.currentPage});

  factory RechargeModel.fromJson(Map<String, dynamic> json) => RechargeModel(
    history:
        (json['history'] as List<dynamic>?)
            ?.map((e) => RechargeHistory.fromJson(e as Map<String, dynamic>))
            .toList(),
    total: json['total'] as int?,
    totalPages: json['totalPages'] as int?,
    currentPage: json['currentPage'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'history': history?.map((e) => e.toJson()).toList(),
    'total': total,
    'totalPages': totalPages,
    'currentPage': currentPage,
  };
}
