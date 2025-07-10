class Transaction {
  String? id;
  int? amount;

  Transaction({this.id, this.amount});

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      Transaction(id: json['id'] as String?, amount: json['amount'] as int?);

  Map<String, dynamic> toJson() => {'id': id, 'amount': amount};
}
