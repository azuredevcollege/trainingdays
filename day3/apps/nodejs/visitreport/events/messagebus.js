const { ServiceBusClient } = require("@azure/service-bus");

module.exports = {
    initialize: init
};

function init(connectionString) {
    return new Promise((resolve, reject) => {
        try {
            const serviceBusNs = ServiceBusClient.createFromConnectionString(connectionString);
            const topic = serviceBusNs.createTopicClient('sbt-visitreports').createSender();
            return resolve({ serviceBus: serviceBusNs, topic: topic });
        } catch {
            err => {
                return reject(err);
            }
        }
    })
}