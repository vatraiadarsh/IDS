const { verifySignUp } = require("../middlewares");
const controller = require("../controllers/auth.controller");
module.exports = function (app) {
    app.use(function (req, res, next) {
        res.header(
            "Access-Control-Allow-Headers",
            "Origin, Content-Type, Accept"
        );
        next();
    });
    app.post(
        "/api/auth/signup",
        verifySignUp.checkDuplicateUsernameOrEmail,
        controller.signup
    );
    app.post("/api/auth/signin", controller.signin);
    app.post("/api/auth/signout", controller.signout);
    app.post("/api/auth/forget-password", controller.forgetPassword);
    app.post("/api/auth/validate-forget-password", controller.validateForgetPassword);
};