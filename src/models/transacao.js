let transacaoId = 1; // variavel para gerar o id da transação

class Transacao {
  constructor(pessoaId, tipo, valor, descricao) {
    this.id = transacaoId++;
    this.pessoaId = pessoaId;
    this.tipo = tipo;
    this.valor = valor;
    this.descricao = descricao;
  }
} // classe para criar uma transação

module.exports = Transacao; // exporta a classe para ser utilizada em outros arquivos.
