const express = require("express");
const router = express.Router();
const promoBannerController = require("../controllers/promoBannerController");

router.get(
  "/repositories/promo-banners",
  promoBannerController.getPromoBanners
);

module.exports = router;
