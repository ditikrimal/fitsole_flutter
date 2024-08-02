const db = require("../config/db");

exports.getPromoBanners = (req, res) => {
  console.log("getPromoBanners");
  const sql = "SELECT * FROM promoBanners";

  db.query(sql, (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      return res
        .status(500)
        .json({ resp: false, message: "Internal server error" });
    }
    if (results.length === 0) {
      return res.status(404).json({
        resp: false,
        message: "No promo banners found",
      });
    }

    res.status(200).json({
      resp: true,
      promoBanners: results,
    });
  });
};
