var messageBus, logger;

function handle(visitreport) {
    visitreport.eventType = 'VisitReportAddedEvent';
    visitreport.version = '1';
    var message = {
        body: visitreport,
        sessionId: '00000000-0000-0000-0000-000000000000' // as soon as we have a user, this will be replaced.
    };
    messageBus.topic.send(message).then(() => {
        logger.info('created_event: successful.');
    }).catch((error) => {
        logger.error(error);
    });
}

function init(mb, log) {
    messageBus = mb;
    logger = log;
}

module.exports = {
    handler: handle,
    initialize: init
}