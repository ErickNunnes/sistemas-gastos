const Transacao = require("../models/transacao"); // importa a classe transação do arquivo transacao.js.
const { pessoas, transacoes } = require("../data/database"); // importa os arrays de pessoas e de transações do arquivo database.js.

const createTransacao = (req, res) => {
  const { pessoaId, descricao, tipo, valor } = req.body;

  // verifica se os campos estão preenchidos
  if (!pessoaId || !tipo || !valor || !descricao) {
    return res
      .status(400)
      .json({ erro: "ID da pessoa, descrição, tipo ou valor não definidos" });
  }

  const pessoa = pessoas.find((p) => p.id === pessoaId); // procura a pessoa pelo ID.
  if (!pessoa) {
    return res
      .status(400)
      .json({ erro: "Não foi possivel encontrar a pessoa" }); // caso não ache a pessoa retorna erro.
  }
  //restringe o tipo de transação apenas para 'receita' ou 'despesa'. Caso seja diferente retorna erro.
  if (tipo !== "receita" && tipo !== "despesa") {
    return res
      .status(400)
      .json({ erro: "tipo deve ser 'receita' ou 'despesa'" });
  }

  // logica para verificar se a pessoa é menor de idade e se for não permite utilizar o tipo 'receita'
  if (pessoa.idade < 18 && tipo === "receita") {
    return res
      .status(400)
      .json({ erro: "Menores de 18 anos não podem ter receitas" });
  }

  const transacao = new Transacao(pessoaId, tipo, valor, descricao); // cria uma nova transação
  transacoes.push(transacao); // adiciona a nova transação ao array de transações(banco de dados em memoria)
  res.status(201).json(transacao); // retorna a transação criada
};

// faz a requisição de todas as transações
const listTransacao = (req, res) => {
  res.json(transacoes);
};
// logica para deletar uma transação pelo Id da transação.
const deleteTransacao = (req, res) => {
  const id = parseInt(req.params.id);
  const index = transacoes.findIndex((t) => t.id === id);

  //logica para ver se a transação existe.
  if (index === -1) {
    return res
      .status(404)
      .json({ erro: "Não foi possivel encontrar a transação" }); // retorna o erro caso a transação não possa ser encontrada.
  }

  transacoes.splice(index, 1);
  res.status(204).send();
};

module.exports = { createTransacao, listTransacao, deleteTransacao }; // exporta as funções para serem utilizadas em outros arquivos.
