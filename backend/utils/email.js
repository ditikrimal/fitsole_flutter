const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  service: "Gmail",
  auth: {
    user: "rml.ditik69@gmail.com",
    pass: "xkrm sdxs xtzc hgsw",
  },
});

module.exports = transporter;
