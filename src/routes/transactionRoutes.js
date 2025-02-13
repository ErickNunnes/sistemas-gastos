const express = require("express"); // impotta o framework express
const router = express.Router(); // cria uma instância de rotas do express
const {
  createTransaction,
  listTransaction,
  deleteTransaction,
} = require("../controllers/transactionController"); // importa as funções de transação

router.post("/", createTransaction); //define a rota para criar uma transação.
router.get("/", listTransaction); // define a rota para listar as transações.
router.delete("/:id", deleteTransaction); // define a rota para deletar uma transação.

module.exports = router; // exporta as rotas para serem utilizadas em outros arquivos.
