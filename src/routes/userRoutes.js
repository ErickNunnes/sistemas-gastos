const express = require("express"); // importa o framework express.
const router = express.Router(); // cria uma instância de rotas do express.
const {
  createUser,
  listUser,
  deleteUser,
  consultTotal,
} = require("../controllers/userController"); // importa as funções de pessoa.

router.post("/", createUser); // define a rota para criar uma pessoa.
router.get("/", listUser); // define a rota para listar as pessoas.
router.delete("/:id", deleteUser); // define a rota para deletar uma pessoa.
router.get("/total", consultTotal); // define a rota para consultar o total de receitas, despesas e saldo de cada pessoa.

module.exports = router;
