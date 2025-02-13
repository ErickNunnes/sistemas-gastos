const User = require("../models/user"); // importa a classe pessoa do arquivo pessoa.js.
const { users, transactions } = require("../data/database"); // importa os arrays de pessoas e de transações do arquivo database.js.

const createUser = (req, res) => {
  const { name, age } = req.body;
  // verifica se os campos estão preenchidos
  if (!name || !age) {
    return res.status(400).json({ erro: "Nome e idade indefinidos" });
  }

  const user = new User(name, age); // cria uma nova pessoa
  users.push(user); // adiciona a nova pessoa ao array de pessoas(banco de dados em memoria)
  res.status(201).json(user); // retorna a pessoa criada
};

const listUser = (req, res) => {
  res.json(users);
}; // faz a requisição de todas as pessoas

const deleteUser = (req, res) => {
  const id = parseInt(req.params.id);
  const index = users.findIndex((user) => user.id === id);

  if (index === -1) {
    res.status(404).json({ erro: "Pessoa não encontrada" });
  } //logica para deletar uma pessoa pelo ID da pessoa e verificar se a pessoa existe. Caso não exista retorna erro.

  let removedTransactions = 0;
  for (let i = transactions.length - 1; i >= 0; i--) {
    if (transactions[i].userId === id) {
      transactions.splice(i, 1);
      removedTransactions++;
    }
  } //declara uma variavel para contar as transações removidas e faz um loop para verificar se a pessoa tem transações e remove-las.

  users.splice(index, 1); //remove a pessoa do array de pessoas.

  res.status(200).json({ mensage: "pessoa removida", removedTransactions }); // retorna a mensagem de pessoa removida e a quantidade de transações removidas.
};

const consultTotal = (req, res) => {
  const totals = users.map((user) => {
    const receitas = transactions
      .filter((t) => t.userId === user.id && t.type === "receita")
      .reduce((sum, t) => sum + t.value, 0);

    const despesas = transactions
      .filter((t) => t.userId === user.id && t.type === "despesa")
      .reduce((sum, t) => sum + t.value, 0);

    return {
      user: user.name,
      receitas,
      despesas,
      saldo: receitas - despesas,
    };
  });

  res.json(totals);
}; // consulta o total de receitas, despesas e saldo de cada pessoa e retorna um array com esses valores.

module.exports = { createUser, listUser, deleteUser, consultTotal }; // exporta as funções para serem utilizadas em outros arquivos.
