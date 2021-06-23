const CosmosClient = require('@azure/cosmos').CosmosClient;
const client = new CosmosClient({ endpoint: process.env.COSMOSDB, key: process.env.CUSTOMCONNSTR_COSMOSKEY });
const uuidv4 = require('uuid/v4');
const databaseId = 'scmvisitreports';
const containerId = 'visitreports';
const eventEmitter = require('../events/emitter');

async function listReports(contactid) {
    var querySpec = null;
    if (contactid == undefined || contactid == null || contactid == '') {
        querySpec = {
            query: "SELECT c.id, c.contact, c.subject, c.visitDate FROM c where c.type = 'visitreport'"
        }
    } else {
        querySpec = {
            query: "SELECT c.id, c.contact, c.subject, c.visitDate FROM c where c.type = 'visitreport' AND c.contact.id = @contactid",
            parameters: [
                {
                    name: "@contactid",
                    value: contactid
                }
            ]
        }
    }

    try {
        const { resources } =
            await client.database(databaseId).container(containerId).items.query(querySpec,
                { enableCrossPartitionQuery: true }).fetchAll();
        return resources;
    } catch (error) {
        throw new Error(error.message);
    }
}

async function createReports(report) {
    report.id = uuidv4();
    report.type = "visitreport";
    try {
        const { item } = await client.database(databaseId).container(containerId).items.upsert(report);
        report.id = item.id;
        eventEmitter.emit('created', report);
        return item;
    } catch (error) {
        throw new Error(error.message);
    }
}

async function readReports(id) {
    const querySpec = {
        query: "SELECT * FROM c where c.id = @id AND c.type = 'visitreport'",
        parameters: [
            {
                name: "@id",
                value: id
            }
        ]
    };
    try {
        const { resources: results } = await client.database(databaseId).container(containerId).items.query(querySpec, { enableCrossPartitionQuery: true }).fetchAll();
        return results.length > 0 ? results[0] : null;
    } catch (error) {
        throw new Error(error.message);
    }
}

async function updateReports(id, report) {
    try {
        report.type = "visitreport";
        const { item } = await client.database(databaseId).container(containerId).item(report.id, 'visitreport').replace(report);
        eventEmitter.emit('updated', report);
        return true;
    } catch (error) {
        throw new Error(error.message);
    }
}

async function deleteReports(id) {
    try {
        const { item } = await client.database(databaseId).container(containerId).item(id, 'visitreport').delete();
        eventEmitter.emit('deleted', { id: item.id });
        return true;
    } catch (error) {
        if (error.code == 404) {
            return false;
        }
        throw new Error(error.message);
    }
}

async function statsOverall() {
    var querySpec = {
        query: "SELECT \
            COUNT(1) as countScore, \
            AVG(c.visitResultSentimentScore) as avgScore, \
            MAX(c.visitResultSentimentScore) as maxScore, \
            MIN(c.visitResultSentimentScore) as minScore  \
          FROM c \
          WHERE c.type = 'visitreport' and c.result != '' \
          GROUP BY c.type"
    }

    try {
        const { resources } =
            await client.database(databaseId).container(containerId).items.query(querySpec).fetchAll();
        return resources;
    } catch (error) {
        throw new Error(error.message);
    }
}

async function statsByContact(contactid) {
    var querySpec = {
        query: "SELECT \
            c.contact.id, \
            COUNT(1) as countScore, \
            AVG(c.visitResultSentimentScore) as avgScore, \
            MAX(c.visitResultSentimentScore) as maxScore, \
            MIN(c.visitResultSentimentScore) as minScore  \
          FROM c \
          WHERE c.type = 'visitreport' and c.result != ''  AND c.contact.id = @contactid \
          GROUP BY c.contact.id",
        parameters: [
            {
                name: "@contactid",
                value: contactid
            }
        ]
    }

    try {
        const { resources } =
            await client.database(databaseId).container(containerId).items.query(querySpec).fetchAll();
        return resources;
    } catch (error) {
        throw new Error(error.message);
    }
}

async function statsTimeline() {
    var querySpec = {
        query: "SELECT \
            c.visitDate, \
            COUNT(1) as visits \
            FROM c \
            WHERE c.type = 'visitreport' AND c.result != '' \
            GROUP BY c.visitDate"
    }

    try {
        const { resources } =
            await client.database(databaseId).container(containerId).items.query(querySpec).fetchAll();
        return resources;
    } catch (error) {
        throw new Error(error.message);
    }
}

module.exports = {
    listReports,
    createReports,
    deleteReports,
    readReports,
    updateReports,
    statsByContact,
    statsOverall,
    statsTimeline
}