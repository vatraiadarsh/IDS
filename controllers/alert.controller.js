const mongoose = require("mongoose");
const fs = require("fs");
const moment = require("moment");
const { exec } = require("child_process");
const config = require("../config/auth.config");
const db = require("../models");
const User = db.user;
const Role = db.role;
const Otp = db.otp;
const Alert = db.alert;
var jwt = require("jsonwebtoken");
var bcrypt = require("bcryptjs");
var nodemailer = require("nodemailer");

exports.backupSnortLogs = (req, res) => {
    try {
        let sort = {};

        sort.actualDatetime = -1;

        if (req.body.enable && req.body.enable == "1") {
            Alert.find({})
                .sort(sort)
                .limit(200)
                .exec((err, alerts) => {
                    if (err) {
                        res.status(500).send({ message: err });
                        return;
                    }
                    if (alerts) {
                        if (!req.body.email) {
                            res.status(500).send({ message: "user email is missing!" });
                        } else {
                            var dir = "backups/";

                            if (!fs.existsSync(dir)) {
                                fs.mkdirSync(dir);
                            }

                            let dateTime = moment().format("DD-MM-YYYY-h:mm:a");
                            var fileName = dateTime.replace(" ", "-") + "_alert.json";
                            var filePath = "backups/" + fileName;
                            let json = JSON.stringify(alerts);

                            fs.writeFile(filePath, json, "utf8", (err, file) => {
                                if (err) {
                                    console.log(err);
                                    res.status(500).send({ message: err });
                                } else {
                                    console.log("req.session.email", req.session.email);
                                    var transporter = nodemailer.createTransport({
                                        service: "gmail",
                                        auth: {
                                            user: "test@gmail.com",
                                            pass: "test",
                                        },
                                    });
                                    console.log("toEmail", req.body.email);
                                    var mailOptions = {
                                        from: "test@gmail.com",
                                        to: req.body.email,
                                        subject: "Parallax Solution - Alert attack backup",
                                        html: "<p>Dear user,</p> <p>Backup process is completed successfully! . It is already saved in the server. Please find the json file from the attachment</p>",
                                        attachments: [
                                            {
                                                filename: fileName,
                                                path: filePath,
                                            },
                                        ],
                                    };

                                    transporter.sendMail(mailOptions, function (error, info) {
                                        if (error) {
                                            console.log(error);
                                            res.send({ message: "OTP send failed!" });
                                        } else {
                                            console.log("Email sent: " + info.response);
                                            res.send({ message: "OTP send via email successfully!" });
                                        }
                                    });

                                    console.log("File written successfully\n");
                                    res.status(200).send({ message: true });
                                }
                            });
                        }
                    }
                });
        }
    } catch (error) {
        console.log("error", error);
        res.status(500).send({ message: error });
    }
};

exports.enableFirewall = (req, res) => {
    let enable = req.body.enable;
    enable = enable.trim();

    if (enable == "1") {
        // exec("sudo ufw enable", (error, stdout, stderr) => {
        //     if (error) {
        //         console.log(`error: ${error.message}`);
        //         res.status(500).send({ message: false });
        //         return;
        //     }
        //     if (stderr) {
        //         console.log(`stderr: ${stderr}`);
        //         res.status(500).send({ message: false });
        //         return;
        //     }
        //     console.log(`stdout: ${stdout}`);

        // });

        res.status(200).send({ message: true });
    } else {
        // exec("sudo ufw disable", (error, stdout, stderr) => {
        //     if (error) {
        //         console.log(`error: ${error.message}`);
        //         res.status(500).send({ message: false });
        //         return;
        //     }
        //     if (stderr) {
        //         console.log(`stderr: ${stderr}`);
        //         res.status(500).send({ message: false });
        //         return;
        //     }
        //     console.log(`stdout: ${stdout}`);
        //     res.status(200).send({ message: true });

        // });
        res.status(200).send({ message: true });
    }
};

exports.hideSnortLogs = async (req, res) => {
    try {
        let hideItems = req.body.id;
        let alertItems = [];

        for (let items of hideItems) {
            alertItems.push(mongoose.Types.ObjectId(items));
        }

        Alert.updateMany({ _id: { $in: hideItems } }, { isHidden: true }).exec(
            (err, alert) => {
                if (err) {
                    res.status(500).send({ message: err });
                    return;
                }

                if (alert) {
                    res.status(200).send({ message: alert });
                }
            }
        );
    } catch (err) {
        res.send({ message: err });
    }
};

exports.deleteSnortLogs = async (req, res) => {
    try {
        let deleteItems = req.body.id;
        let alertItems = [];

        for (let items of deleteItems) {
            alertItems.push(mongoose.Types.ObjectId(items));
        }

        Alert.deleteMany({ _id: { $in: alertItems } }).exec((err, alert) => {
            if (err) {
                res.status(500).send({ message: err });
                return;
            }

            if (alert) {
                res.send({ message: alert });
            }
        });
    } catch (err) {
        res.send({ message: err });
    }
};

exports.searchSnortLogs = async (req, res) => {
    try {
        let search = {};
        let sort = {};
        sort.actualDatetime = -1;
        sort.priority = 1;
        sort.alertName = 1;
        let alertName;
        let attackLevels;
        let protocols;

        search.isHidden = false;

        if (req.query.name) {
            alertName = req.query.name.trim();
            search.alertName = new RegExp(alertName, "i");
        }

        if (req.query.levelFilters) {
            attackLevels = req.query.levelFilters
                .split(",")
                .map((item) => item.trim());
            search.attackLevel = attackLevels;
        }
        if (req.query.protocolFilters) {
            protocols = req.query.protocolFilters
                .split(",")
                .map((item) => item.trim());
            search.protocol = protocols;
        }

        if (req.query.fromDate && req.query.toDate) {
            let fromDate = req.query.fromDate.trim();
            let toDate = req.query.toDate.trim();

            search.actualDatetime = {
                $gte: fromDate,
                $lt: toDate,
            };
        }

        if (req.query.dateSort == 1) {
            sort.actualDatetime = -1;
        } else if (req.query.attacklevelSort == 1) {
            sort.priority = -1;
        } else if (req.query.alertNamesort == 1) {
            sort.alertName = -1;
        }

        Alert.find(search)
            .sort(sort)
            .limit(100)
            .exec((err, alert) => {
                if (err) {
                    res.status(500).send({ message: err });
                    return;
                }
                if (alert) {
                    var alertInfo = [];
                    for (let alertData of alert) {
                        if (alertData.attackLevel != "Low") {
                            alertInfo.push(alertData);
                        }
                    }
                    Alert.count(search).exec((err, data) => {
                        if (!err) {
                            let attackCount = alertInfo.length;
                            let totalAttackCount = data;
                            let percent = parseInt(attackCount) / parseInt(totalAttackCount);
                            percent = percent * 100;
                            percent = Number.parseFloat(percent).toFixed(2) + "%";
                            return res
                                .status(200)
                                .send({
                                    attackCount: attackCount,
                                    attackPercentage: percent,
                                    data: alert,
                                });
                        }
                    });
                }
            });
    } catch (err) {
        res.send({ message: err });
    }
};

exports.getGraphData = async (req, res) => {
    try {
        let search = {};
        let dateFrom = moment().subtract(7, "d").format("MM/DD");
        search.isHidden;
        search.actualDatetime = {
            $gte: dateFrom,
        };
        Alert.find(search, function (err, result) {
            if (err) {
                res.send({ message: err });
            }

            if (result) {
                // this gives an object with dates as keys
                const groups = result.reduce((groups, game) => {
                    const date = game.actualDatetime.split(" ")[0];
                    if (!groups[date]) {
                        groups[date] = [];
                    }

                    groups[date].push(game.attackLevel);
                    return groups;
                }, {});

                const groupArrays = Object.keys(groups).map((date) => {
                    return {
                        date,
                        counts: [
                            { Low: groups[date].filter((x) => x === "Low").length },
                            { Medium: groups[date].filter((x) => x === "Medium").length },
                            { High: groups[date].filter((x) => x === "High").length },
                            { Highest: groups[date].filter((x) => x === "Highest").length },
                        ],
                    };
                });
                res.send({ data: groupArrays });
            }
        });
    } catch (err) {
        res.send({ message: err });
    }
};

exports.listAttackLevels = async (req, res) => {
    try {
        Alert.find({})
            .select("attackLevel")
            .exec((err, attackLevels) => {
                if (err) {
                    res.status(500).send({ message: err });
                    return;
                }
                if (attackLevels) {
                    let attackLevel = [];
                    for (let level of attackLevels) {
                        attackLevel.push(level.attackLevel);
                    }
                    attackLevel = Array.from(new Set(attackLevel));
                    return res.status(200).send({ data: attackLevel });
                }
            });
    } catch (err) {
        res.send({ message: err });
    }
};

exports.listProtocols = async (req, res) => {
    try {
        Alert.find({})
            .select("protocol")
            .exec((err, protocols) => {
                if (err) {
                    res.status(500).send({ message: err });
                    return;
                }
                if (protocols) {
                    let protocolSet = [];
                    for (let data of protocols) {
                        protocolSet.push(data.protocol);
                    }
                    protocolSet = Array.from(new Set(protocolSet));
                    return res.status(200).send({ data: protocolSet });
                }
            });
    } catch (err) {
        res.send({ message: err });
    }
};
