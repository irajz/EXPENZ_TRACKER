const express = require("express");
const router = express.Router();
const {
  createTransaction,
  getUserTransactions,
} = require("../controllers/transactionController");

router.post("/", createTransaction);
router.get("/:userID", getUserTransactions);

module.exports = router;
