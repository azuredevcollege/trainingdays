if (process.env.SCM_ENV && process.env.SCM_ENV.toLowerCase() != 'production') var env = require('dotenv').config();
const fastify = require('fastify')({
    logger: true
});

const eventEmitter = require('./events/emitter');
const messageBus = require('./events/messagebus');
const createdEvent = require('./events/created');
const updatedEvent = require('./events/updated');
const deletedEvent = require('./events/deleted');
const contactsListener = require('./events/contacts-listener');

const appInsights = require("applicationinsights");

if (process.env.APPINSIGHTS_KEY) {
    appInsights.setup(process.env.APPINSIGHTS_KEY)
        .setAutoDependencyCorrelation(true)
        .setAutoCollectRequests(true)
        .setAutoCollectPerformance(true)
        .setAutoCollectExceptions(true)
        .setAutoCollectDependencies(true)
        .setAutoCollectConsole(true)
        .setUseDiskRetryCaching(true);
    appInsights.start();
    appInsights.defaultClient.context.tags[appInsights.defaultClient.context.keys.cloudRole] = process.env.APPINSIGHTS_ROLENAME || "visitreport";
}
fastify.register(require('fastify-cors'), {
    exposedHeaders: ['Location'],
    maxAge: 600
});
fastify.register(require('fastify-swagger'), {
    routePrefix: '/docs',
    exposeRoute: true
});
fastify.addHook('onRequest', async (request, reply) => {
    if (process.env.APPINSIGHTS_KEY != '') {
        appInsights.defaultClient.trackNodeHttpRequest({ request: request.req, response: reply.res });
    }
    return;
});

fastify.register(require('./routes'));

// Contacts
messageBus.initialize(process.env.CUSTOMCONNSTR_SBCONTACTSTOPIC_CONNSTR).then((mb) => {
    contactsListener.initialize(mb, fastify.log).then(() => {
        fastify.log.info('Messagebus for contacts initialized...');
    }).catch(() => fastify.log.error("Error creating Subscription on Servicebus."));
});

// Visitreports
messageBus.initialize(process.env.CUSTOMCONNSTR_SBVRTOPIC_CONNSTR).then((mb) => {
    createdEvent.initialize(mb, fastify.log);
    eventEmitter.on('created', createdEvent.handler);
    updatedEvent.initialize(mb, fastify.log);
    eventEmitter.on('updated', updatedEvent.handler);
    deletedEvent.initialize(mb, fastify.log);
    eventEmitter.on('deleted', deletedEvent.handler);
    fastify.log.info('Messagebus for visitreports initialized...');
});

const start = async () => {
    try {
        await fastify.listen(process.env.PORT || 3000, '0.0.0.0', (err, address) => {

            if (err) {
                fastify.log.error(err)
                process.exit(1)
            }
        });
        fastify.swagger();
    } catch (err) {
        fastify.log.error(err)
        process.exit(1)
    }
};

start();