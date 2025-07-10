class Plan {
  String? id;
  String? name;
  int? coins;
  int? rate;

  Plan({this.id, this.name, this.coins, this.rate});

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    coins: json['coins'] as int?,
    rate: json['rate'] as int?,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'coins': coins,
    'rate': rate,
  };
}
