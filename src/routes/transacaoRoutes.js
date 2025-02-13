const express = require("express");
const router = express.Router();
const {
  createTransacao,
  listTransacao,
  deleteTransacao,
} = require("../controllers/transacaoController");

router.post("/", createTransacao);
router.get("/", listTransacao);
router.delete("/:id", deleteTransacao);

module.exports = router;
