const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const db = require("../config/db");
const transporter = require("../utils/email");

const saltRounds = 10;

const emailExists = (email, callback) => {
  const sql = "SELECT COUNT(*) AS count FROM users WHERE email = ?";
  db.query(sql, [email], (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      callback(err, null);
      return;
    }
    callback(null, results[0].count > 0);
  });
};

exports.signup = async (req, res) => {
  const { fullName, email, password } = req.body;

  emailExists(email, (err, exists) => {
    if (err) {
      return res
        .status(500)
        .json({ resp: false, message: "Internal server error" });
    }

    if (exists) {
      return res
        .status(400)
        .json({ resp: false, message: "Email already exists" });
    }

    bcrypt.hash(password, saltRounds, (err, hash) => {
      if (err) {
        console.error("Error hashing password:", err);
        return res
          .status(500)
          .json({ resp: false, message: "Internal server error" });
      }

      const otp = crypto.randomInt(100000, 999999);

      const mailOptions = {
        from: "your_email@gmail.com",
        to: email,
        subject: "Your OTP Code",
        text: `Your OTP code is ${otp}. It will expire in 10 minutes.`,
      };

      transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
          console.error("Error sending email:", error);
          return res
            .status(500)
            .json({ resp: false, message: "Internal server error" });
        }

        const sql =
          "INSERT INTO users (fullName, email, password, otp, is_verified, created_at) VALUES (?, ?, ?, ?, 0, NOW())";
        db.query(sql, [fullName, email, hash, otp], (err, result) => {
          if (err) {
            console.error("Error executing query:", err);
            return res
              .status(500)
              .json({ resp: false, message: "Internal server error" });
          }

          res.status(200).json({
            resp: true,
            message: "User signed up successfully. OTP sent to email.",
          });
        });
      });
    });
  });
};

exports.verifyOtp = (req, res) => {
  const { email, otp } = req.body;

  const sql = "SELECT otp FROM users WHERE email = ? AND is_verified = 0";
  db.query(sql, [email], (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      return res
        .status(500)
        .json({ resp: false, message: "Internal server error" });
    }

    if (results.length === 0) {
      return res.status(400).json({
        resp: false,
        message: "Invalid email or user already verified",
      });
    }

    const storedOtp = results[0].otp;

    if (parseInt(storedOtp, 10) === parseInt(otp, 10)) {
      const updateSql = "UPDATE users SET is_verified = 1 WHERE email = ?";
      db.query(updateSql, [email], (err, result) => {
        if (err) {
          console.error("Error executing query:", err);
          return res
            .status(500)
            .json({ resp: false, message: "Internal server error" });
        }

        res
          .status(200)
          .json({ resp: true, message: "OTP verified successfully" });
      });
    } else {
      res.status(400).json({ resp: false, message: "Invalid OTP" });
    }
  });
};
exports.login = async (req, res) => {
  const { email, password } = req.body;

  const sql = "SELECT * FROM users WHERE email = ?";
  db.query(sql, [email], (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      return res
        .status(500)
        .json({ resp: false, message: "Internal server error" });
    }

    if (results.length === 0) {
      return res.status(400).json({ resp: false, message: "User not found" });
    }

    const user = results[0];

    bcrypt.compare(password, user.password, (err, isMatch) => {
      if (err) {
        console.error("Error comparing passwords:", err);
        return res
          .status(500)
          .json({ resp: false, message: "Internal server error" });
      }

      if (isMatch) {
        if (user.is_verified === 0) {
          const verificationToken = crypto.randomBytes(20).toString("hex");
          const verificationLink = `http://192.168.1.88:3000/verify/${verificationToken}`;

          const updateSql =
            "UPDATE users SET verification_token = ? WHERE email = ?";
          db.query(updateSql, [verificationToken, email], (err, result) => {
            if (err) {
              console.error("Error executing query:", err);
              return res
                .status(500)
                .json({ resp: false, message: "Internal server error" });
            }

            const mailOptions = {
              from: "your_email@gmail.com",
              to: email,
              subject: "Account Verification",
              html: `<p>Please verify your account by clicking the following link:</p>
                     <a href="${verificationLink}">Verify your account</a>`,
            };

            transporter.sendMail(mailOptions, (error, info) => {
              if (error) {
                console.error("Error sending email:", error);
                return res
                  .status(500)
                  .json({ resp: false, message: "Internal server error" });
              }

              res.status(400).json({
                resp: false,
                message: "A verification link has been sent to your inbox.",
                messageStatus: "User not verified.",
              });
            });
          });
        } else {
          const token = jwt.sign({ id: user.id }, "passwordKey", {
            expiresIn: "24h",
          });
          res.status(200).json({
            resp: true,
            message: "Login successful",
            token: token,
            messageStatus: "User verified.",
          });
        }
      } else {
        res.status(400).json({
          resp: false,
          message: "Invalid password",
          messageStatus: "Error",
        });
      }
    });
  });
};

exports.verifyAccount = (req, res) => {
  const { token } = req.params;

  const sql = "SELECT email FROM users WHERE verification_token = ?";
  db.query(sql, [token], (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      return res
        .status(500)
        .json({ resp: false, message: "Internal server error" });
    }

    if (results.length === 0) {
      return res.status(400).json({
        resp: false,
        message: "Invalid or expired verification token",
      });
    }

    const email = results[0].email;

    const updateSql =
      "UPDATE users SET is_verified = 1, verification_token = NULL WHERE email = ?";
    db.query(updateSql, [email], (err, result) => {
      if (err) {
        console.error("Error executing query:", err);
        return res
          .status(500)
          .json({ resp: false, message: "Internal server error" });
      }

      res
        .status(200)
        .json({ resp: true, message: "Account verified successfully" });
    });
  });
};

exports.renewToken = (req, res) => {
  const { id } = req.user;
  console.log(id);
  const sql = "SELECT * FROM users WHERE id = ?";
  db.query(sql, [id], (err, results) => {
    if (err) {
      console.error("Error executing query:", err);
      return res
        .status(500)
        .json({ resp: false, message: "Internal server error" });
    }

    if (results.length === 0) {
      return res.status(404).json({ resp: false, message: "User not found" });
    }

    const user = results[0];
    const newToken = jwt.sign({ id: user.id }, "passwordKey", {
      expiresIn: "24h",
    });

    res
      .status(200)
      .json({ resp: true, message: "Token renewed", token: newToken });
  });
};
