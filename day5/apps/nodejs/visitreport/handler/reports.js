const service = require('../service/reports');

async function listReportsHandler(request, reply) {
    var { contactid } = request.query;
    var { sub } = request.scm;
    try {
        var results = await service.listReports(sub, contactid);
        reply.code(200).send(results);
    } catch (err) {
        reply.code(500).send();
    }
};

async function createReportsHandler(request, reply) {
    var { sub } = request.scm;
    try {
        var item = await service.createReports(sub, request.body);
        reply.header('Location', `${item.id}`);
        reply.code(201).send();
    } catch (err) {
        reply.code(500).send(err.message);
    }
};

async function updateReportsHandler(request, reply) {
    var { sub } = request.scm;
    const { id } = request.params;
    try {
        var result = await service.updateReports(sub, id, request.body);
        reply.header('Location', `${id}`);
        reply.code(204).send();
    } catch (err) {
        reply.code(500).send(err.message);
    }
};

async function deleteReportsHandler(request, reply) {
    var { sub } = request.scm;
    const { id } = request.params;
    try {
        var ok = await service.deleteReports(sub, id);
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
    var { sub } = request.scm;
    const { id } = request.params;
    try {
        var result = await service.readReports(sub, id);
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
    var { sub } = request.scm;
    var { contactid } = request.params;
    try {
        var results = await service.statsByContact(contactid);
        reply.code(200).send(results);
    } catch (err) {
        reply.code(500).send();
    }
};

async function statsOverallHandler(request, reply) {
    var { sub } = request.scm;
    try {
        var results = await service.statsOverall();
        reply.code(200).send(results);
    } catch (err) {
        reply.code(500).send();
    }
};

async function statsTimelineHandler(request, reply) {
    var { sub } = request.scm;
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