const bcrypt = require("bcrypt");
const User = require("../models/user");
const validator = require("validator"); // optional, install with npm

const createUser = async (req, res) => {
  try {
    const { name, email, pwd } = req.body;

    if (!name || !email || !pwd) {
      return res
        .status(400)
        .json({ message: "Name, email and password are required" });
    }

    if (!validator.isEmail(email)) {
      return res.status(400).json({ message: "Invalid email format" });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(pwd, 10);

    // Call model
    const result = await User.createUser(name, email, hashedPassword);

    res.status(201).json({ userID: result.insertId, email });
  } catch (error) {
    if (error.code === "ER_DUP_ENTRY") {
      return res.status(409).json({ message: "Email already exists" });
    }
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};

const getUsers = async (req, res) => {
  try {
    const users = await User.getUsers();
    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};

module.exports = { createUser, getUsers };
