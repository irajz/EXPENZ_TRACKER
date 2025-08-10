const db = require("../db");
const bcrypt = require("bcrypt");

const createUser = async (req, res) => {
  try {
    const { name, email, pwd } = req.body;

    if (!name || !email || !pwd) {
      return res
        .status(400)
        .json({ message: "Name, email and password are required" });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(pwd, 10);

    const sql = "INSERT INTO users (name, email, pwd) VALUES (?, ?, ?)";
    db.query(sql, [name, email, hashedPassword], (err, result) => {
      if (err) {
        if (err.code === "ER_DUP_ENTRY") {
          return res.status(409).json({ message: "Email already exists" });
        }
        return res.status(500).json({ message: err.message });
      }
      res.status(201).json({ userID: result.insertId, email });
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

const getUsers = (req, res) => {
  const sql = "SELECT userID, name, email, created_at FROM users";
  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).json({ message: err.message });
    }
    res.json(results);
  });
};

module.exports = { createUser, getUsers };
