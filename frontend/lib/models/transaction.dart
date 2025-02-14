class Transaction {
  final int id;
  final int userId;
  final String type;
  final double value;
  final String description;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.value,
    required this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      value: json['value'].toDouble(),
      description: json['description'],
    );
  }
}
