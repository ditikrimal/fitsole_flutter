const express = require("express");
const router = express.Router();
const userController = require("../controllers/userController");
const authenticateToken = require("../middlewares/auth");

router.post("/signup", userController.signup);
router.post("/verify-otp", userController.verifyOtp);
router.post("/login", userController.login);
router.get("/verify/:token", userController.verifyAccount);
router.post("/auth/renew-token", authenticateToken, userController.renewToken);

module.exports = router;
