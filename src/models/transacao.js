let transacaoId = 1;

class Transacao {
  constructor(pessoaId, tipo, valor, descricao) {
    this.id = transacaoId++;
    this.pessoaId = pessoaId;
    this.tipo = tipo;
    this.valor = valor;
    this.descricao = descricao;
  }
}

module.exports = Transacao;
