import 'receiver.dart';

class ListenersModel {
  int? total;
  int? page;
  int? limit;
  List<Receiver>? receivers;

  ListenersModel({this.total, this.page, this.limit, this.receivers});

  factory ListenersModel.fromJson(Map<String, dynamic> json) => ListenersModel(
    total: json['total'] as int?,
    page: json['page'] as int?,
    limit: json['limit'] as int?,
    receivers:
        (json['receivers'] as List<dynamic>?)
            ?.map((e) => Receiver.fromJson(e as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'total': total,
    'page': page,
    'limit': limit,
    'receivers': receivers?.map((e) => e.toJson()).toList(),
  };
}
