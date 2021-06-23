const CosmosClient = require('@azure/cosmos').CosmosClient;
const axios = require('axios').default;
const client = new CosmosClient({ endpoint: process.env.COSMOSDB, key: process.env.COSMOSKEY });
const databaseId = 'scmvisitreports';
const containerId = 'visitreports';
const container = client.database(databaseId).container(containerId);
const TA_SUBSCRIPTION_KEY = process.env.TA_SUBSCRIPTION_KEY;
var HEADERS_TEMPLATE = {
    'Ocp-Apim-Subscription-Key': TA_SUBSCRIPTION_KEY,
    'Content-Type': 'application/json'
};
const TA_SUBSCRIPTIONENDPOINT = process.env.TA_SUBSCRIPTIONENDPOINT;
const TA_LANGUAGE_PATH = '/text/analytics/v2.1/languages';
const TA_SENTIMENT_PATH = '/text/analytics/v2.1/sentiment';
const TA_KEYPHRASE_PATH = '/text/analytics/v2.1/keyPhrases';

module.exports = async function (context, mySbMsg) {
    context.log('ServiceBus topic trigger function processing message: ', mySbMsg);

    var current_language = '';
    var current_sentiment_score = -1;
    var current_keyphrases = [];

    if (mySbMsg != null) {
        if (mySbMsg.eventType == "VisitReportUpdatedEvent" || mySbMsg.eventType == "VisitReportCreatedEvent") {
            context.log('Message is of type "create" or "update".');
            if (mySbMsg.result != null && mySbMsg.result != undefined && mySbMsg.result != '') {
                current_language = await detectLanguage(mySbMsg, context);
                current_sentiment_score = await getSentimentScore(mySbMsg, current_language);
                current_keyphrases = await getKeyPhrases(mySbMsg, current_language);
            }

            // Query CosmosDB object
            const querySpec = {
                query: "SELECT * FROM c where c.id = @id AND c.type = 'visitreport'",
                parameters: [
                    {
                        name: "@id",
                        value: mySbMsg.id
                    }
                ]
            };

            // Read CosmosDB + update with results.
            try {
                const { resources: results } = await container.items.query(querySpec).fetchAll();
                var currentitem = results.length > 0 ? results[0] : null;
                if (currentitem == null) {
                    return context.done();
                }
                currentitem.detectedLanguage = current_language;
                currentitem.visitResultSentimentScore = current_sentiment_score;
                currentitem.visitResultKeyPhrases = current_keyphrases;
                await container.item(currentitem.id, 'visitreport').replace(currentitem);
                return context.done();
            } catch (error) {
                context.log.error(error.message);
                return context.done();
            }
        }
    }
    return context.done();
};

async function getKeyPhrases(mySbMsg, current_language, context) {
    var current_keyphrases = []; // default.
    try {
        var response_keyphrases = await axios.post(`${TA_SUBSCRIPTIONENDPOINT}${TA_KEYPHRASE_PATH}`,
            { documents: [{ id: mySbMsg.id, language: current_language, text: mySbMsg.result }] }, {
            headers: HEADERS_TEMPLATE
        });
        var docs_kp = response_keyphrases.data.documents || [];
        if (docs_kp.length) {
            current_keyphrases = docs_kp[0].keyPhrases;
        }
    } catch (error) {
        context.log.error(error.message);
    }
    return current_keyphrases;
}

async function getSentimentScore(mySbMsg, current_language, context) {
    var current_sentiment_score = 0.0; // default.
    try {
        var response_sen = await axios.post(`${TA_SUBSCRIPTIONENDPOINT}${TA_SENTIMENT_PATH}`,
            { documents: [{ id: mySbMsg.id, language: current_language, text: mySbMsg.result }] }, {
            headers: HEADERS_TEMPLATE
        });
        var docs_sen = response_sen.data.documents || [];
        if (docs_sen.length) {
            current_sentiment_score = docs_sen[0].score;
        }
    } catch (error) {
        context.log.error(error.message);
    }
    return current_sentiment_score;
}

async function detectLanguage(mySbMsg, context) {
    var current_language = "en";
    try {
        var response_ld = await axios.post(`${TA_SUBSCRIPTIONENDPOINT}${TA_LANGUAGE_PATH}`, { documents: [{ id: mySbMsg.id, text: mySbMsg.result }] }, {
            headers: HEADERS_TEMPLATE
        });
        var docs_ld = response_ld.data.documents || [];
        if (docs_ld.length > 0 && docs_ld[0].detectedLanguages.length > 0) {
            current_language = docs_ld[0].detectedLanguages[0].iso6391Name;
        }
    } catch (error) {
        context.log.error(error.message);
    }
    return current_language;
}
