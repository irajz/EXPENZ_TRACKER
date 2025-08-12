const express = require("express");
const router = express.Router();

const transactionController = require("../controllers/transactionController");

// Mounted under /api/transactions (see server.js)

// POST /api/transactions/ - create new transaction
router.post("/", transactionController.createTransaction);

// GET /api/transactions/:userID - get transactions for a user
router.get("/:userID", transactionController.getUserTransactions);

module.exports = router;
