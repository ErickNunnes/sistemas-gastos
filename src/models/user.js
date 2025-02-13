let userId = 1; // variavel para gerar o id da pessoa

class User {
  constructor(name, age) {
    this.id = userId++;
    this.name = name;
    this.age = age;
  }
} // classe para criar uma pessoa

module.exports = User; // exporta a classe para ser utilizada em outros arquivos.
