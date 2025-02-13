const Pessoa = require("../models/pessoa"); // importa a classe pessoa do arquivo pessoa.js.
const { pessoas, transacoes } = require("../data/database"); // importa os arrays de pessoas e de transações do arquivo database.js.

const createPessoa = (req, res) => {
  const { nome, idade } = req.body;
  // verifica se os campos estão preenchidos
  if (!nome || !idade) {
    return res.status(400).json({ erro: "Nome e idade indefinidos" });
  }

  const pessoa = new Pessoa(nome, idade); // cria uma nova pessoa
  pessoas.push(pessoa); // adiciona a nova pessoa ao array de pessoas(banco de dados em memoria)
  res.status(201).json(pessoa); // retorna a pessoa criada
};

const listPessoa = (req, res) => {
  res.json(pessoas);
}; // faz a requisição de todas as pessoas

const deletePessoa = (req, res) => {
  const id = parseInt(req.params.id);
  const index = pessoas.findIndex((pessoa) => pessoa.id === id);

  if (index === -1) {
    res.status(404).json({ erro: "Pessoa não encontrada" });
  } //logica para deletar uma pessoa pelo ID da pessoa e verificar se a pessoa existe. Caso não exista retorna erro.

  let transacoesRemovidas = 0;
  for (let i = transacoes.length - 1; i >= 0; i--) {
    if (transacoes[i].pessoaId === id) {
      transacoes.splice(i, 1);
      transacoesRemovidas++;
    }
  } //declara uma variavel para contar as transações removidas e faz um loop para verificar se a pessoa tem transações e remove-las.

  pessoas.splice(index, 1); //remove a pessoa do array de pessoas.

  res.status(200).json({ mensagem: "pessoa removida", transacoesRemovidas }); // retorna a mensagem de pessoa removida e a quantidade de transações removidas.
};

const consultTotal = (req, res) => {
  const totais = pessoas.map((pessoa) => {
    const receitas = transacoes
      .filter((t) => t.pessoaId === pessoa.id && t.tipo === "receita")
      .reduce((sum, t) => sum + t.valor, 0);

    const despesas = transacoes
      .filter((t) => t.pessoaId === pessoa.id && t.tipo === "despesa")
      .reduce((sum, t) => sum + t.valor, 0);

    return {
      pessoa: pessoa.nome,
      receitas,
      despesas,
      saldo: receitas - despesas,
    };
  });

  res.json(totais);
}; // consulta o total de receitas, despesas e saldo de cada pessoa e retorna um array com esses valores.

module.exports = { createPessoa, listPessoa, deletePessoa, consultTotal }; // exporta as funções para serem utilizadas em outros arquivos.
