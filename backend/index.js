const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const mysql = require("mysql2/promise"); // Use promise-based API
const bcrypt = require("bcryptjs"); // Use bcryptjs
const saltRounds = 10;
const nodemailer = require("nodemailer");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.json());

// MySQL connection
const dbConfig = {
  host: "localhost",
  user: "root",
  password: "",
  database: "fitsole",
};

const transporter = nodemailer.createTransport({
  service: "Gmail",
  auth: {
    user: "your_email@gmail.com",
    pass: "your_password",
  },
});

// Middleware to verify token
const authenticateToken = (req, res, next) => {
  const token = req.headers["authorization"]?.split(" ")[1]; // Assumes Bearer token format
  if (token == null) return res.sendStatus(401);

  jwt.verify(token, "passwordKey", (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
};

// Helper function to check if email exists
const emailExists = async (email) => {
  const connection = await mysql.createConnection(dbConfig);
  try {
    const [results] = await connection.execute(
      "SELECT COUNT(*) AS count FROM users WHERE email = ?",
      [email]
    );
    return results[0].count > 0;
  } finally {
    await connection.end();
  }
};

// Routes
app.post("/user/signup", async (req, res) => {
  const { fullName, email, password } = req.body;

  try {
    const exists = await emailExists(email);
    if (exists) {
      return res
        .status(400)
        .json({ resp: false, message: "Email already exists" });
    }

    const hash = await bcrypt.hash(password, saltRounds);
    const otp = crypto.randomInt(100000, 999999);

    const connection = await mysql.createConnection(dbConfig);
    try {
      await transporter.sendMail({
        from: "your_email@gmail.com",
        to: email,
        subject: "Your OTP Code",
        text: `Your OTP code is ${otp}. It will expire in 10 minutes.`,
      });

      await connection.execute(
        "INSERT INTO users (fullName, email, password, otp, is_verified, created_at) VALUES (?, ?, ?, ?, 0, NOW())",
        [fullName, email, hash, otp]
      );

      res.status(200).json({
        resp: true,
        message: "User signed up successfully. OTP sent to email.",
      });
    } finally {
      await connection.end();
    }
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ resp: false, message: "Internal server error" });
  }
});

app.post("/user/verify-otp", async (req, res) => {
  const { email, otp } = req.body;

  const connection = await mysql.createConnection(dbConfig);
  try {
    const [results] = await connection.execute(
      "SELECT otp FROM users WHERE email = ? AND is_verified = 0",
      [email]
    );

    if (results.length === 0) {
      return res.status(400).json({
        resp: false,
        message: "Invalid email or user already verified",
      });
    }

    const storedOtp = results[0].otp;

    if (parseInt(storedOtp, 10) === parseInt(otp, 10)) {
      await connection.execute(
        "UPDATE users SET is_verified = 1 WHERE email = ?",
        [email]
      );
      res
        .status(200)
        .json({ resp: true, message: "OTP verified successfully" });
    } else {
      res.status(400).json({ resp: false, message: "Invalid OTP" });
    }
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ resp: false, message: "Internal server error" });
  } finally {
    await connection.end();
  }
});

app.post("/user/login", async (req, res) => {
  const { email, password } = req.body;

  const connection = await mysql.createConnection(dbConfig);
  try {
    const [results] = await connection.execute(
      "SELECT * FROM users WHERE email = ?",
      [email]
    );

    if (results.length === 0) {
      return res.status(400).json({ resp: false, message: "User not found" });
    }

    const user = results[0];
    const isMatch = await bcrypt.compare(password, user.password);

    if (isMatch) {
      if (user.is_verified === 0) {
        const verificationToken = crypto.randomBytes(20).toString("hex");
        const verificationLink = `http://192.168.1.88:3000/verify/${verificationToken}`;

        await connection.execute(
          "UPDATE users SET verification_token = ? WHERE email = ?",
          [verificationToken, email]
        );

        await transporter.sendMail({
          from: "your_email@gmail.com",
          to: email,
          subject: "Account Verification",
          html: `<p>Please verify your account by clicking the following link:</p><a href="${verificationLink}">Verify your account</a>`,
        });

        res.status(400).json({
          resp: false,
          message: "A verification link has been sent to your inbox.",
          messageStatus: "User not verified.",
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
        message: "Invalid Credentials.",
        messageStatus: "Error",
      });
    }
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ resp: false, message: "Internal server error" });
  } finally {
    await connection.end();
  }
});

app.get("/verify/:token", async (req, res) => {
  const { token } = req.params;

  const connection = await mysql.createConnection(dbConfig);
  try {
    const [results] = await connection.execute(
      "SELECT email FROM users WHERE verification_token = ?",
      [token]
    );

    if (results.length === 0) {
      return res.status(400).json({
        resp: false,
        message: "Invalid or expired verification token",
      });
    }

    const email = results[0].email;

    await connection.execute(
      "UPDATE users SET is_verified = 1, verification_token = NULL WHERE email = ?",
      [email]
    );
    res
      .status(200)
      .json({ resp: true, message: "Account verified successfully" });
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ resp: false, message: "Internal server error" });
  } finally {
    await connection.end();
  }
});

app.post("/auth/renew-token", authenticateToken, async (req, res) => {
  const { id } = req.user;

  const connection = await mysql.createConnection(dbConfig);
  try {
    const [results] = await connection.execute(
      "SELECT * FROM users WHERE id = ?",
      [id]
    );

    if (results.length === 0) {
      return res.status(404).json({ resp: false, message: "User not found" });
    }

    const user = results[0];
    const newToken = jwt.sign({ id: user.id }, "passwordKey", {
      expiresIn: "1h",
    });

    res.status(200).json({
      resp: true,
      message: "Token renewed",
      token: newToken,
      messageStatus: "Success",
    });
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ resp: false, message: "Internal server error" });
  } finally {
    await connection.end();
  }
});

app.get("/repositories/promo-banners", async (req, res) => {
  const connection = await mysql.createConnection(dbConfig);
  try {
    const [results] = await connection.execute("SELECT * FROM promoBanners");
    if (results.length === 0) {
      return res
        .status(404)
        .json({ resp: false, message: "No promo banners found" });
    }
    res.status(200).json({ resp: true, promoBanners: results });
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ resp: false, message: "Internal server error" });
  } finally {
    await connection.end();
  }
});

app.get("/products/brands", async (req, res) => {
  const connection = await mysql.createConnection(dbConfig);
  try {
    const [results] = await connection.execute(
      "SELECT DISTINCT brand FROM products"
    );
    res.status(200).json({ resp: true, brands: results });
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ resp: false, message: "Internal server error" });
  } finally {
    await connection.end();
  }
});

app.get("/products/categories", async (req, res) => {
  const connection = await mysql.createConnection(dbConfig);
  try {
    const [results] = await connection.execute(
      "SELECT DISTINCT category FROM products"
    );
    res.status(200).json({ resp: true, shoecategory: results });
  } catch (err) {
    console.error("Error:", err);
    res.status(500).json({ resp: false, message: "Internal server error" });
  } finally {
    await connection.end();
  }
});

app.get("/api/products", async (req, res) => {
  const connection = await mysql.createConnection(dbConfig);
  try {
    const [rows] = await connection.execute("SELECT * FROM products LIMIT 6");
    res.status(200).json({ resp: true, products: rows });
  } catch (error) {
    res.status(500).json({ error: "Failed to load products" });
  } finally {
    await connection.end();
  }
});

app.get("/api/products/popular", async (req, res) => {
  const connection = await mysql.createConnection(dbConfig);
  try {
    const [rows] = await connection.execute(
      "SELECT * FROM products ORDER BY quantity_sold DESC LIMIT 6"
    );
    res.status(200).json({ resp: true, products: rows });
  } catch (error) {
    res.status(500).json({ error: "Failed to load popular products" });
  } finally {
    await connection.end();
  }
});

app.get("/api/products/latest", async (req, res) => {
  const connection = await mysql.createConnection(dbConfig);
  try {
    const [rows] = await connection.execute(
      "SELECT * FROM products ORDER BY arrival_date DESC LIMIT 6"
    );
    res.status(200).json({ resp: true, products: rows });
  } catch (error) {
    res.status(500).json({ error: "Failed to load latest arrivals" });
  } finally {
    await connection.end();
  }
});

app.get("/test", (req, res) => {
  res.status(200).send("Test route is working");
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
