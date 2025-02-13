const Transaction = require("../models/transaction"); // importa a classe transação do arquivo transacao.js.
const { users, transactions } = require("../data/database"); // importa os arrays de pessoas e de transações do arquivo database.js.

const createTransaction = (req, res) => {
  const { userId, description, type, value } = req.body;

  // verifica se os campos estão preenchidos
  if (!userId || !type || !value || !description) {
    return res
      .status(400)
      .json({ erro: "ID da pessoa, descrição, tipo ou valor não definidos" });
  }

  const user = users.find((user) => user.id === userId); // procura a pessoa pelo ID.
  if (!user) {
    return res
      .status(400)
      .json({ erro: "Não foi possivel encontrar a pessoa" }); // caso não ache a pessoa retorna erro.
  }
  //restringe o tipo de transação apenas para 'receita' ou 'despesa'. Caso seja diferente retorna erro.
  if (type !== "receita" && type !== "despesa") {
    return res
      .status(400)
      .json({ erro: "tipo deve ser 'receita' ou 'despesa'" });
  }

  // logica para verificar se a pessoa é menor de idade e se for não permite utilizar o tipo 'receita'
  if (user.age < 18 && type === "receita") {
    return res
      .status(400)
      .json({ erro: "Menores de 18 anos não podem ter receitas" });
  }

  const transaction = new Transaction(userId, type, value, description); // cria uma nova transação
  transactions.push(transaction); // adiciona a nova transação ao array de transações(banco de dados em memoria)
  res.status(201).json(transaction); // retorna a transação criada
};

// faz a requisição de todas as transações
const listTransaction = (req, res) => {
  res.json(transactions);
};
// logica para deletar uma transação pelo Id da transação.
const deleteTransaction = (req, res) => {
  const id = parseInt(req.params.id);
  const index = transactions.findIndex((t) => t.id === id);

  //logica para ver se a transação existe.
  if (index === -1) {
    return res
      .status(404)
      .json({ erro: "Não foi possivel encontrar a transação" }); // retorna o erro caso a transação não possa ser encontrada.
  }

  transactions.splice(index, 1);
  res.status(204).send();
};

module.exports = { createTransaction, listTransaction, deleteTransaction }; // exporta as funções para serem utilizadas em outros arquivos.
