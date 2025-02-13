const express = require("express"); // impotta o framework express
const router = express.Router(); // cria uma instância de rotas do express
const {
  createTransacao,
  listTransacao,
  deleteTransacao,
} = require("../controllers/transacaoController"); // importa as funções de transação

router.post("/", createTransacao); //define a rota para criar uma transação.
router.get("/", listTransacao); // define a rota para listar as transações.
router.delete("/:id", deleteTransacao); // define a rota para deletar uma transação.

module.exports = router; // exporta as rotas para serem utilizadas em outros arquivos.
