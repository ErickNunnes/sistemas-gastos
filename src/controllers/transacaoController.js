const Transacao = require("../models/transacao");
const { pessoas, transacoes } = require("../data/database");

const createTransacao = (req, res) => {
  const { pessoaId, descricao, tipo, valor } = req.body;

  if (!pessoaId || !tipo || !valor || !descricao) {
    return res
      .status(400)
      .json({ erro: "ID da pessoa, descrição, tipo ou valor não definidos" });
  }

  const pessoa = pessoas.find((p) => p.id === pessoaId);
  if (!pessoa) {
    return res
      .status(400)
      .json({ erro: "Não foi possivel encontrar a pessoa" });
  }

  if (tipo !== "receita" && tipo !== "despesa") {
    return res
      .status(400)
      .json({ erro: "tipo deve ser 'receita' ou 'despesa'" });
  }

  if (pessoa.idade < 18 && tipo === "receita") {
    return res
      .status(400)
      .json({ erro: "Menores de 18 anos não podem ter receitas" });
  }

  const transacao = new Transacao(pessoaId, tipo, valor, descricao);
  transacoes.push(transacao);
  res.status(201).json(transacao);
};

const listTransacao = (req, res) => {
  res.json(transacoes);
};

const deleteTransacao = (req, res) => {
  const id = parseInt(req.params.id);
  const index = transacoes.findIndex((t) => t.id === id);

  if (index === -1) {
    return res
      .status(404)
      .json({ erro: "Não foi possivel encontrar a transação" });
  }

  transacoes.splice(index, 1);
  res.status(204).send();
};

module.exports = { createTransacao, listTransacao, deleteTransacao };
