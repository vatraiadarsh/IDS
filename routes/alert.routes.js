
const controller = require("../controllers/alert.controller");
module.exports = function (app) {
    app.use(function (req, res, next) {
        res.header(
            "Access-Control-Allow-Headers",
            "Origin, Content-Type, Accept"
        );
        next();
    });
    app.post(
        "/api/alert/backup-snort-logs",
        controller.backupSnortLogs
    );
    app.put(
        "/api/alert/enable-Firewall",
        controller.enableFirewall
    );
    app.put(
        "/api/alert/hide-snort-logs",
        controller.hideSnortLogs
    );
    app.delete(
        "/api/alert/delete-snort-logs",
        controller.deleteSnortLogs
    );
    app.get(
        "/api/alert/search-snort-logs",
        controller.searchSnortLogs
    );
    app.get(
        "/api/alert/get-graph-data",
        controller.getGraphData
    );
    app.get(
        "/api/alert/list-attack-levels",
        controller.listAttackLevels
    );
    app.get(
        "/api/alert/list-attack-protocols",
        controller.listProtocols
    );
    

};