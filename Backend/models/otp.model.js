const mongoose = require("mongoose");
const OTP = mongoose.model(
  "otp",
  new mongoose.Schema({
    username: String,
    email: String,
    otp: String,
    validated:Boolean,
    datetime: String,
  })
);
module.exports = OTP;