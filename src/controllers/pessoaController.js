const Pessoa = require("../models/pessoa");
const { pessoas, transacoes } = require("../data/database");

const createPessoa = (req, res) => {
  const { nome, idade } = req.body;

  if (!nome || !idade) {
    return res.status(400).json({ erro: "Nome e idade indefinidos" });
  }

  const pessoa = new Pessoa(nome, idade);
  pessoas.push(pessoa);
  res.status(201).json(pessoa);
};

const listPessoa = (req, res) => {
  res.json(pessoas);
};

const deletePessoa = (req, res) => {
  const id = parseInt(req.params.id);
  const index = pessoas.findIndex((pessoa) => pessoa.id === id);

  if (index === -1) {
    res.status(404).json({ erro: "Pessoa não encontrada" });
  }

  let transacoesRemovidas = 0;
  for (let i = transacoes.length - 1; i >= 0; i--) {
    if (transacoes[i].pessoaId === id) {
      transacoes.splice(i, 1);
      transacoesRemovidas++;
    }
  }

  pessoas.splice(index, 1);

  res.status(200).json({ mensagem: "pessoa removida", transacoesRemovidas });
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
};

module.exports = { createPessoa, listPessoa, deletePessoa, consultTotal };
