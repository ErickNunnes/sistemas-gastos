let transactionId = 1; // variavel para gerar o id da transação

class Transaction {
  constructor(userId, type, value, description) {
    this.id = transactionId++;
    this.userId = userId;
    this.type = type;
    this.value = value;
    this.description = description;
  }
} // classe para criar uma transação

module.exports = Transaction; // exporta a classe para ser utilizada em outros arquivos.
