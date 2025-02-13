const express = require("express"); // importa o framework express
const app = express(); // cria uma instância do express
const userRoutes = require("./src/routes/userRoutes"); // importa as rotas de pessoa
const transactionRoutes = require("./src/routes/transactionRoutes"); // importa as rotas de transação

app.use(express.json()); // habilita o uso de JSON no express
app.use("/users", userRoutes); // define a rota para pessoa
app.use("/transactions", transactionRoutes); // define a rota para transação

const PORT = 3000; // define a porta que o servidor irá rodar
// inicia o servidor na porta definida (porta 3000)
app.listen(PORT, () => {
  console.log("Server is running on port " + PORT);
});
