const express = require("express"); // importa o framework express.
const router = express.Router(); // cria uma instância de rotas do express.
const {
  createPessoa,
  listPessoa,
  deletePessoa,
  consultTotal,
} = require("../controllers/pessoaController"); // importa as funções de pessoa.

router.post("/", createPessoa); // define a rota para criar uma pessoa.
router.get("/", listPessoa); // define a rota para listar as pessoas.
router.delete("/:id", deletePessoa); // define a rota para deletar uma pessoa.
router.get("/total", consultTotal); // define a rota para consultar o total de receitas, despesas e saldo de cada pessoa.

module.exports = router;
