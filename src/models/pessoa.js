let pessoaId = 1; // variavel para gerar o id da pessoa

class Pessoa {
  constructor(nome, idade) {
    this.id = pessoaId++;
    this.nome = nome;
    this.idade = idade;
  }
} // classe para criar uma pessoa

module.exports = Pessoa; // exporta a classe para ser utilizada em outros arquivos.
