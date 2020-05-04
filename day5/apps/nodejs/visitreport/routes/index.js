const {
    listReportsSchema,
    createReportsSchema,
    readReportsSchema,
    deleteReportsSchema,
    updateReportsSchema,
    statsByContactSchema,
    statsOverallSchema,
    statsTimelineSchema
} = require('../schemas/reports');


const {
    listReportsHandler,
    createReportsHandler,
    deleteReportsHandler,
    readReportsHandler,
    updateReportsHandler,
    statsByContactHandler,
    statsOverallHandler,
    statsTimelineHandler
} = require('../handler/reports');

module.exports = async function (fastify, opts) {
    fastify.route({
        method: 'GET',
        url: '/',
        handler: async function (request, reply) {
            reply.code(200).send();
        }
    });

    fastify.route({
        method: 'GET',
        url: '/reports',
        schema: listReportsSchema,
        handler: listReportsHandler,
        preValidation: (request, reply, done) => {
            if (request.scm.scopes.includes('VisitReports.Read')) {
                done();
            } else {
                reply.code(403).send();
                done();
            }
        }
    });

    fastify.route({
        method: 'POST',
        url: '/reports',
        schema: createReportsSchema,
        handler: createReportsHandler,
        preValidation: (request, reply, done) => {
            if (request.scm.scopes.includes('VisitReports.Create')) {
                done();
            } else {
                reply.code(403).send();
                done();
            }
        }
    });

    fastify.route({
        method: 'GET',
        url: '/reports/:id',
        schema: readReportsSchema,
        handler: readReportsHandler,
        preValidation: (request, reply, done) => {
            if (request.scm.scopes.includes('VisitReports.Read')) {
                done();
            } else {
                reply.code(403).send();
                done();
            }
        }
    });

    fastify.route({
        method: 'PUT',
        url: '/reports/:id',
        schema: updateReportsSchema,
        handler: updateReportsHandler,
        preValidation: (request, reply, done) => {
            if (request.scm.scopes.includes('VisitReports.Update')) {
                done();
            } else {
                reply.code(403).send();
                done();
            }
        }
    });

    fastify.route({
        method: 'DELETE',
        url: '/reports/:id',
        schema: deleteReportsSchema,
        handler: deleteReportsHandler,
        preValidation: (request, reply, done) => {
            if (request.scm.scopes.includes('VisitReports.Delete')) {
                done();
            } else {
                reply.code(403).send();
                done();
            }
        }
    });

    // Stats

    fastify.route({
        method: 'GET',
        url: '/stats/timeline',
        schema: statsTimelineSchema,
        handler: statsTimelineHandler,
        preValidation: (request, reply, done) => {
            if (request.scm.scopes.includes('VisitReports.Read')) {
                done();
            } else {
                reply.code(403).send();
                done();
            }
        }
    });

    fastify.route({
        method: 'GET',
        url: '/stats/:contactid',
        schema: statsByContactSchema,
        handler: statsByContactHandler,
        preValidation: (request, reply, done) => {
            if (request.scm.scopes.includes('VisitReports.Read')) {
                done();
            } else {
                reply.code(403).send();
                done();
            }
        }
    });

    fastify.route({
        method: 'GET',
        url: '/stats',
        schema: statsOverallSchema,
        handler: statsOverallHandler,
        preValidation: (request, reply, done) => {
            if (request.scm.scopes.includes('VisitReports.Read')) {
                done();
            } else {
                reply.code(403).send();
                done();
            }
        }
    });
};