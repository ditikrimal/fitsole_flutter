const db = require("../config/db");

exports.getProducts = (req, res) => {
  const sql = "SELECT * FROM products";

  db.query(sql, (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      return res
        .status(500)
        .json({ resp: false, message: "Internal server error" });
    }

    res.status(200).json({
      resp: true,
      products: results,
    });
  });
};
