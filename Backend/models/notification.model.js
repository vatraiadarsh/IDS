const mongoose = require("mongoose");
const NOTIFICATION = mongoose.model(
  "notifications",
  new mongoose.Schema({
    alertName: String,
    alertId: String,
    actualDatetime:String,
    sourceIP: String,
    destinationIP: String,
    protocol:String,
    priority:String,
    attackLevel:String,
    notificationMessage: String,
    notificationId:String,
    isSent:Boolean,
    notificationSentDatetime: String,

  })
);
module.exports = NOTIFICATION;