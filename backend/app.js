const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
const port = process.env.PORT || 3001;

app.use(cors());
app.use(bodyParser.json());

// Import routes
const userRoutes = require("./routes/user");
const productRoutes = require("./routes/product");

// Use routes
app.use("/user", userRoutes);
app.use("/product", productRoutes);

app.get("/test", (req, res) => {
  res.status(200).send("Test route is working");
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
