class Plan {
  String? id;
  String? name;
  int? coins;
  int? rate;
  String? description;

  Plan({this.id, this.name, this.coins, this.rate, this.description});

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json['_id'] as String?,
    name: json['name'] as String?,
    coins: json['coins'] as int?,
    rate: json['rate'] as int?,
    description: json['description'] as String?,
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'coins': coins,
    'rate': rate,
    'description': description,
  };
}
