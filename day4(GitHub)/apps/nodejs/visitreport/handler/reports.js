const service = require('../service/reports');

async function listReportsHandler(request, reply) {
    var { contactid } = request.query;
    try {
        var results = await service.listReports(contactid);
        reply.code(200).send(results);
    } catch (err) {
        reply.code(500).send();
    }
};

async function createReportsHandler(request, reply) {
    try {
        var item = await service.createReports(request.body);
        reply.header('Location', `${item.id}`);
        reply.code(201).send();
    } catch (err) {
        reply.code(500).send(err.message);
    }
};

async function updateReportsHandler(request, reply) {
    const { id } = request.params;
    try {
        var result = await service.updateReports(id, request.body);
        reply.header('Location', `${id}`);
        reply.code(204).send();
    } catch (err) {
        reply.code(500).send(err.message);
    }
};

async function deleteReportsHandler(request, reply) {
    const { id } = request.params;
    try {
        var ok = await service.deleteReports(id);
        if (ok) {
            reply.code(204).send();
        } else {
            reply.code(404).send();
        }
    } catch (err) {
        reply.code(500).send(err.message);
    }
};

async function readReportsHandler(request, reply) {
    const { id } = request.params;
    try {
        var result = await service.readReports(id);
        if (result != null) {
            reply.code(200).send(result);
        } else {
            reply.code(404).send();
        }
    } catch (err) {
        reply.code(500).send(err.message);
    }
};

// Stats

async function statsByContactHandler(request, reply) {
    var { contactid } = request.params;
    try {
        var results = await service.statsByContact(contactid);
        reply.code(200).send(results);
    } catch (err) {
        reply.code(500).send();
    }
};

async function statsOverallHandler(request, reply) {
    try {
        var results = await service.statsOverall();
        reply.code(200).send(results);
    } catch (err) {
        reply.code(500).send();
    }
};

async function statsTimelineHandler(request, reply) {
    try {
        var results = await service.statsTimeline();
        reply.code(200).send(results);
    } catch (err) {
        reply.code(500).send();
    }
};

module.exports = {
    listReportsHandler,
    createReportsHandler,
    deleteReportsHandler,
    readReportsHandler,
    updateReportsHandler,
    statsByContactHandler,
    statsOverallHandler,
    statsTimelineHandler
}