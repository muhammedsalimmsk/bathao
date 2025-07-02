import 'history.dart';

class CallHistoryModel {
  List<History>? history;
  int? total;
  int? totalPages;
  int? currentPage;

  CallHistoryModel({
    this.history,
    this.total,
    this.totalPages,
    this.currentPage,
  });

  factory CallHistoryModel.fromJson(Map<String, dynamic> json) {
    return CallHistoryModel(
      history:
          (json['history'] as List<dynamic>?)
              ?.map((e) => History.fromJson(e as Map<String, dynamic>))
              .toList(),
      total: json['total'] as int?,
      totalPages: json['totalPages'] as int?,
      currentPage: json['currentPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'history': history?.map((e) => e.toJson()).toList(),
    'total': total,
    'totalPages': totalPages,
    'currentPage': currentPage,
  };
}
