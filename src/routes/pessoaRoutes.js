const express = require("express");
const router = express.Router();
const {
  createPessoa,
  listPessoa,
  deletePessoa,
  consultTotal,
} = require("../controllers/pessoaController");

router.post("/", createPessoa);
router.get("/", listPessoa);
router.delete("/:id", deletePessoa);
router.get("/total", consultTotal);

module.exports = router;
