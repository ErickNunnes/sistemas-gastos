class Transaction {
  final int id; //ID da transação
  final int userId; //ID do usuário
  final String type; //Seleciona o tipo de transação(receita ou despesa)
  final double value; //Valor da transação
  final String description; //Descrição da transação

  //Construtor da classe Transaction
  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.value,
    required this.description,
  });

  //Converte um JSON em um objeto Transaction
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      value: json['value'].toDouble(), //Converte o valor para double
      description: json['description'],
    );
  }
}
