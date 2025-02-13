let pessoaId = 1;

class Pessoa {
  constructor(nome, idade) {
    this.id = pessoaId++;
    this.nome = nome;
    this.idade = idade;
  }
}

module.exports = Pessoa;
