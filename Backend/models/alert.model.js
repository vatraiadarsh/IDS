const mongoose = require("mongoose");
const ALERTS = mongoose.model(
  "alerts",
  new mongoose.Schema({
    alertName: String,
    actualDatetime:String,
    priority:String,
    sourceIP: String,
    destinationIP: String,
    protocol:String,
    attackLevel:String,
    isHidden:Boolean,
    alertDescription:String,
    datetime: String,
  })
);
module.exports = ALERTS;