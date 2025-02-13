const express = require("express");
const app = express();
const pessoaRoutes = require("./src/routes/pessoaRoutes");
const transacaoRoutes = require("./src/routes/transacaoRoutes");

app.use(express.json());
app.use("/pessoas", pessoaRoutes);
app.use("/transacoes", transacaoRoutes);

const PORT = 3000;
app.listen(PORT, () => {
  console.log("Server is running on port " + PORT);
});
