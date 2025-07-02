import 'plan.dart';

class PlanModel {
  List<Plan>? plans;

  PlanModel({this.plans});

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
    plans:
        (json['plans'] as List<dynamic>?)
            ?.map((e) => Plan.fromJson(e as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'plans': plans?.map((e) => e.toJson()).toList(),
  };
}
