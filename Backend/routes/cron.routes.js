
const controller = require("../controllers/cron.controller");
module.exports = function (app) {
    app.use(function (req, res, next) {
        res.header(
            "Access-Control-Allow-Headers",
            "Origin, Content-Type, Accept"
        );
        next();
    });
    app.get(
        "/api/cron/read-snort-logs",
        controller.readandInsertSnortLogs
    );
    app.post(
        "/api/cron/send-notification",
        controller.sendNotification
    );
    app.get(
        "/api/cron/get-notification",
        controller.getNotification
    );
    
};