const CosmosClient = require('@azure/cosmos').CosmosClient;
const client = new CosmosClient({ endpoint: process.env.COSMOSDB, key: process.env.CUSTOMCONNSTR_COSMOSKEY });
const uuidv4 = require('uuid/v4');
const databaseId = 'scmvisitreports';
const containerId = 'visitreports';
const eventEmitter = require('../events/emitter');

async function listReports(sub, contactid) {
    var querySpec = null;
    if (contactid == undefined || contactid == null || contactid == '') {
        querySpec = {
            query: "SELECT c.id, c.contact, c.subject, c.visitDate FROM c where c.type = 'visitreport' and c.userid = @sub",
            parameters: [
                {
                    name: "@sub",
                    value: sub
                }
            ]
        }
    } else {
        querySpec = {
            query: "SELECT c.id, c.contact, c.subject, c.visitDate FROM c where c.type = 'visitreport' AND c.contact.id = @contactid and c.userid = @sub",
            parameters: [
                {
                    name: "@contactid",
                    value: contactid
                },
                {
                    name: "@sub",
                    value: sub
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

async function createReports(sub, report) {
    report.id = uuidv4();
    report.type = "visitreport";
    report.userid = sub;
    try {
        const { item } = await client.database(databaseId).container(containerId).items.upsert(report);
        report.id = item.id;
        eventEmitter.emit('created', report);
        return item;
    } catch (error) {
        throw new Error(error.message);
    }
}

async function readReports(sub, id) {
    const querySpec = {
        query: "SELECT * FROM c where c.id = @id AND c.type = 'visitreport' and c.userid = @sub",
        parameters: [
            {
                name: "@id",
                value: id
            },
            {
                name: "@sub",
                value: sub
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

async function updateReports(sub, id, report) {
    // find it!
    const querySpec = {
        query: "SELECT * FROM c where c.id = @id AND c.type = 'visitreport' and c.userid = @sub",
        parameters: [
            {
                name: "@id",
                value: id
            },
            {
                name: "@sub",
                value: sub
            }
        ]
    };
    try {
        const { resources: results } = await client.database(databaseId).container(containerId).items.query(querySpec, { enableCrossPartitionQuery: true }).fetchAll();
        if (results.length > 0) {
            report.type = "visitreport";
            report.userid = sub;
            const { item } = await client.database(databaseId).container(containerId).item(report.id, 'visitreport').replace(report);
            eventEmitter.emit('updated', report);
            return true;
        } else {
            return false;
        }
    } catch (error) {
        throw new Error(error.message);
    }
}

async function deleteReports(sub, id) {
    // find it!
    const querySpec = {
        query: "SELECT * FROM c where c.id = @id AND c.type = 'visitreport' and c.userid = @sub",
        parameters: [
            {
                name: "@id",
                value: id
            },
            {
                name: "@sub",
                value: sub
            }
        ]
    };
    try {
        const { resources: results } = await client.database(databaseId).container(containerId).items.query(querySpec, { enableCrossPartitionQuery: true }).fetchAll();
        if (results.length > 0) {
            const { item } = await client.database(databaseId).container(containerId).item(id, 'visitreport').delete();
            eventEmitter.emit('deleted', { id: item.id });
            return true;
        } else {
            return false;
        }
    } catch (error) {
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