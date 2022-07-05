const config = require("../config/auth.config");
const db = require("../models");
const fs = require("fs");
const moment = require("moment");
const request = require("request-promise");
const alerts = db.alert;
const notification = db.notification;

exports.readandInsertSnortLogs = (req, res) => {
  try {
    let filename = "../../../var/log/snort/alert";

    let alertData = [];
    let lines;
    let content = fs.readFileSync(process.cwd() + "/" + filename).toString();
    let splittedData = content.split(/\n\s*\n/);

    for (let i = 0; i < splittedData.length; i++) {
      lines = splittedData[i].split(/[\r\n]+/g);

      if (lines && lines.length > 1) {
        let requiredString1 = lines[0].split("[**]");
        let requiredString2 = lines[1].split("Priority");
        let requiredString3 = lines[2].split(" ");
        let requiredString4 = lines[3].split(" ");

        let alertName;
        let priorityString;
        let actualDatetime;
        let priority;
        let sourceIP;
        let destinationIP;
        let protocol;
        let attackLevel;
        let isHidden;
        let datetime;

        if (requiredString1) {
          alertName = requiredString1[1].split("]");
          alertName = alertName[1].trim();
        }

        if (requiredString2) {
          priorityString = requiredString2[1].replace(/[^\d\.]*/g, "");
          priority = priorityString.trim();
        }

        if (requiredString3) {
          actualDatetime = requiredString3[0];
          actualDatetime = actualDatetime.replace("-", " ");
          actualDatetime = actualDatetime.trim();
          actualDatetime = new Date(actualDatetime);
          actualDatetime = moment(actualDatetime).format("MM/DD h:mm A");
          sourceIP = requiredString3[1].trim();
          destinationIP = requiredString3[3].trim();
        }

        if (requiredString4) {
          protocol = requiredString4[0].trim();
        }

        if (priority && priority == 0) {
          attackLevel = "Low";
        } else if (priority && priority == 1) {
          attackLevel = "Medium";
        } else if (priority && priority == 2) {
          attackLevel = "Medium";
        } else if (priority && priority == 3) {
          attackLevel = "High";
        } else if (priority && priority == 4) {
          attackLevel = "Highest";
        }

        isHidden = false;
        datetime = new Date().toLocaleString();

        let newObject = {};
        newObject.alertName = alertName;
        newObject.actualDatetime = actualDatetime;
        newObject.priority = priority;
        newObject.sourceIP = sourceIP;
        newObject.destinationIP = destinationIP;
        newObject.protocol = protocol;
        newObject.attackLevel = attackLevel;
        newObject.isHidden = isHidden;
        newObject.datetime = datetime;
        newObject.alertDescription = splittedData[i];
        alertData.push(newObject);
      }
    }
    alerts.deleteMany((err, deletedata) => {
      if (err) {
        console.log("err", err);
        res.status(500).send({ message: err });
        return;
      } else {
        alerts.insertMany(alertData, (err, insertdata) => {
          if (err) {
            console.log("err", err);
            res.status(500).send({ message: err });
            return;
          } else {
            res.send({ message: insertdata });
          }
        });
      }
    });
  } catch (error) {
    console.log("error");
    res.send({ message: error });
  }
};

exports.getNotification = (req, res) => {
  notification.find({}).exec((err, notification) => {
    if (err) {
      res.status(500).send({ message: err });
      return;
    }

    res.status(200).send({
      notification,
    });
  });
};

exports.sendNotification = async (req, res) => {
  let pastdateTime = new Date(Date.now() - 1000 * 300).toLocaleString();
  let currentdateTime = new Date().toLocaleString();

  console.log("fromto time", pastdateTime);

  alerts
    .find({
      priority: { $gte: 3 },
      datetime: { $gte: pastdateTime, $lte: currentdateTime },
    })
    .sort({ actualDatetime: -1 })
    .limit(1)
    .exec((err, data) => {
      if (err) {
        res.status(500).send({ message: err });
        return;
      }
      console.log("data", data);
      if (data.length > 0) {
        let notificationData = {};
        var attackLevel = data[0].attackLevel;
        var attackName = data[0].alertName;
        var attackBody = "An Attack detected from " + data[0].sourceIP;
        notificationData.alertId = data[0]._id;
        notificationData.alertName = data[0].alertName;
        notificationData.actualDatetime = data[0].actualDatetime;
        notificationData.sourceIP = data[0].sourceIP;
        notificationData.destinationIP = data[0].destinationIP;
        notificationData.notificationMessage = attackBody;
        notificationData.protocol = data[0].protocol;
        notificationData.priority = data[0].priority;
        notificationData.notificationSentDatetime =
          moment().format("DD-MM-YYYY H:mm:a");

        const insertData = new notification(notificationData);

        insertData.save((err, notificationres) => {
          if (err) {
            console.log("err", err);
            res.status(500).send({ message: err });
            return;
          } else {
            console.log("notificationres", notificationres);
            let notificationTitle =
              capitalizeFirstLetter(attackLevel) +
              " Attack Alert - " +
              attackName;
            const options = {
              method: "POST",
              uri: "https://fcm.googleapis.com/fcm/send",
              body: {
                to: "/topics/app_android",
                collapse_key: "type_a",
                notification: {
                  body: attackBody,
                  title: notificationTitle,
                },
                data: {
                  body: attackBody,
                  title: notificationTitle,
                  key_1: "Value for key_1",
                  key_2: "Value for key_2",
                },
              },
              headers: {
                "Content-Type": "application/json",
                Authorization:
                  "key=xxx",
              },
              json: true,
            };
            request(options)
              .then(function (response) {
                if (response.message_id) {
                  let updateData = {};
                  let id = notificationres._id;
                  updateData.notificationId = response.message_id;
                  updateData.isSent = true;

                  notification.findOneAndUpdate(
                    { _id: id },
                    updateData,
                    (error, updateRes) => {
                      console.log("error", error);
                      if (error) {
                        res.status(500).send({ message: error });
                      }
                      console.log("updateRes", updateRes);
                      res.status(200).send({ message: updateRes });
                    }
                  );
                }
              })
              .catch(function (err) {
                res.status(500).send({ message: err });
              });
          }
        });
      } else {
        res.status(400).send({ message: "empty" });
      }
    });
};

function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}
