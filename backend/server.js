const express = require("express");
const app = express();

app.use(express.json()); // to parse JSON bodies

const userRoutes = require("./routes/userRoutes");
const transactionRoutes = require("./routes/transactionRoutes");

// Use the routes with a prefix (optional)
app.use("/api", userRoutes);
app.use("/api", transactionRoutes);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
