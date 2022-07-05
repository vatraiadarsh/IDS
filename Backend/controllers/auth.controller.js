const config = require("../config/auth.config");
const db = require("../models");
const User = db.user;
const Role = db.role;
const Otp = db.otp;
var jwt = require("jsonwebtoken");
var bcrypt = require("bcryptjs");
var nodemailer = require('nodemailer');


exports.signup = (req, res) => {
    User.findOne({
        email: req.body.email,
    }).exec((err, user) => {
        if (err) {
            res.status(500).send({ message: err });
        }
        if (!user) {
            const user = new User({
                username: req.body.username,
                email: req.body.email,
                password: bcrypt.hashSync(req.body.password, 8),
            });
            user.save((err, user) => {
                if (err) {
                    console.log("err", err)
                    res.status(500).send({ message: err });
                    return;
                }
                else {
                    res.status(200).send({ message: "User was registered successfully!" });
                }

            });
        }
        else {
            res.status(400).send({ message: "User email already used!" });
        }
    });

};
exports.signin = (req, res) => {

    if (!req.body.email) {
        return res.status(404).send({ message: "email is missing!" });
    }

    User.findOne({
        email: req.body.email,
    }).exec((err, user) => {
        if (err) {
            res.status(500).send({ message: err });
            return;
        }
        if (!user) {
            return res.status(404).send({ message: "User Not found." });
        }
        var passwordIsValid = bcrypt.compareSync(
            req.body.password,
            user.password
        );
        if (!passwordIsValid) {
            return res.status(401).send({ message: "Invalid Password!" });
        }
        var token = jwt.sign({ id: user.id }, config.secret, {
            expiresIn: 86400, // 24 hours
        });

        req.session.token = token;
        req.session.email = user.email;
        res.status(200).send({
            id: user._id,
            username: user.username,
            email: user.email,
        });
    });
};
exports.signout = async (req, res) => {
    try {
        req.session = null;
        return res.status(200).send({ message: "You've been signed out!" });
    } catch (err) {
        this.next(err);
    }
};


exports.forgetPassword = async (req, res) => {
    try {
        User.findOne({
            email: req.body.email,
        }).exec((err, user) => {
            if (err) {
                res.status(500).send({ message: err });
                return;
            }
            if (!user) {
                return res.status(404).send({ message: "User Not found." });
            }


            let generatedOtp = Math.floor((Math.random() * 100000) + 1);
            let username = user.username;
            let useremail = user.email;
            const userOtp = new Otp({
                username: user.username,
                email: user.email,
                otp: generatedOtp,
                validated: false,
                datetime: new Date().toLocaleString()
            });
            userOtp.save((err, Otp) => {
                if (err) {
                    console.log("err", err)
                    res.status(500).send({ message: err });
                    return;
                }
                else {
                    var transporter = nodemailer.createTransport({
                        service: 'gmail',
                        auth: {
                            user: 'test@gmail.com',
                            pass: 'test'
                        }
                    });

                    var mailOptions = {
                        from: 'test@gmail.com',
                        to: useremail,
                        subject: 'Parallax Solution - Forget Password OTP',
                        html: '<p>Dear ' + username + ',</p> <p>Your OTP is </p> <h2>' + generatedOtp + '<h2>'

                    };

                    transporter.sendMail(mailOptions, function (error, info) {
                        if (error) {
                            console.log(error);
                            res.send({ message: "OTP send failed!" });
                        } else {
                            console.log('Email sent: ' + info.response);
                            res.send({ message: "OTP send via email successfully!" });
                        }
                    });
                }

            });
        });
    } catch (err) {
        this.next(err);
        res.send({ message: "error" });
    }
};

exports.validateForgetPassword = async (req, res) => {
    try {

        if (req.body && (!req.body.email || !req.body.otp || !req.body.password)) {
            return res.status(404).send({ message: "email or password is missing" });
        }

        Otp.findOne({
            email: req.body.email,
            otp: req.body.otp,
            validated: false
        }).sort({ _id: -1 }).exec((err, userOtp) => {
            if (err) {
                res.status(500).send({ message: err });
                return;
            }
            if (!userOtp) {
                return res.status(404).send({ message: "OTP/email is not valid" });
            }

            Otp.updateOne({
                email: req.body.email,
                otp: req.body.otp,
                validated: false
            }, { updated: true }).exec((err, userOTPupdated) => {
                if (err) {
                    res.status(500).send({ message: err });
                    return;
                }
                if (!userOTPupdated) {
                    return res.status(404).send({ message: "OTP status is not validated" });
                }
            });

            let newPassword = bcrypt.hashSync(req.body.password, 8);

            let useremail = req.body.email;
            User.findOneAndUpdate({
                email: req.body.email,
            }, { password: newPassword }).exec((err, passwordupdated) => {
                if (err) {
                    res.status(500).send({ message: err });
                    return;
                }
                if (!passwordupdated) {
                    return res.status(404).send({ message: "password is not updated!" });
                }

                var transporter = nodemailer.createTransport({
                    service: 'gmail',
                    auth: {
                        user: 'test@gmail.com',
                        pass: 'test'
                    }
                });

                var mailOptions = {
                    from: 'test@gmail.com',
                    to: useremail,
                    subject: 'Forget Password - OTP Validated',
                    html: '<p>Dear ' + passwordupdated.username + ',</p> <p>Your OTP is validated successfully</p>'

                };

                transporter.sendMail(mailOptions, function (error, info) {
                    if (error) {
                        console.log(error);
                        res.send({ message: "email send failed!" });
                    } else {
                        console.log('Email sent: ' + info.response);
                        res.send({ message: "password updated" });
                    }
                });
            });





        });
    } catch (err) {
        this.next(err);
        res.send({ message: "error" });
    }
};

