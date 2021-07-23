# Challenge 04: Cognitive Services

⏲️ _Est. time to complete: 30 min._ ⏲️

## Here is what you will learn 🎯

In this challenge you will learn how to:

- create and use the Text Analysis Cognitive Service
- create and use the Translate Cognitive Service

## Table Of Contents

1. [What are Azure Cognitive Services?](#what-are-azure-cognitive-services)
2. [Create and use a Text Analysis Cognitive Service](#create-and-use-a-text-analysis-cognitive-service)
3. [Create and use the Translate Cognitive Service](#create-and-use-the-translate-cognitive-service)
4. [Cleanup](#cleanup)

## What are Azure Cognitive Services?

Azure Cognitive Services:

- are APIs, SDKs and services available to help developers build intelligent applications without having direct Artificial Intelligence (AI), data science skills or knowledge.
- enable developers to easily add cognitive features into their applications.
- The goal of Azure Cognitive Services is to help developers create applications that can see, hear, speak, understand and even begin to reason.
- The catalog of services within Azure Cognitive Services can be categorized into five main pillars - _Vision_, _Speech_, _Language_, _Web Search_, and _Decision_.

In this challenge we will focus on the following Cognitive Services:

| Service Name                                                                                           | Service Description                                                                                                                     |
| :----------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------- |
| [Text Analytics](https://docs.microsoft.com/azure/cognitive-services/text-analytics/ 'Text Analytics') | Text Analytics provides natural language processing over raw text for sentiment analysis, key phrase extraction and language detection. |
| [Translator Text](https://docs.microsoft.com/azure/cognitive-services/translator/ 'Translator Text')   | Translator text provides for machine-based text translation in near real-time.                                                          |

## Create and use a Text Analysis Cognitive Service

You can solve these tasks in a programming language of your choice. For the sake of convenience, we are providing hints in `Node.js`. SDK support for `C#` or `.NET Core` is also available.

| Azure Cognitive Services                                                                            | Information                                                                                   |
| --------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| [Text Analytics API](https://azure.microsoft.com/en-us/services/cognitive-services/text-analytics/) | <https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/quickstarts/nodejs> |

We will now leverage the _Text Analytics API_ for extracting language, sentiment, key phrases, and entities from text. When creating the service, please use a new resource group, e.g. **rg-azdc-cognitive**. As a **Pricing Tier**, select the smallest possible in the chosen region. You can choose as a name for the resource **cog-textanalytics-westeurope-001** as we learned on day1.

Go to the Azure Portal, create a Text Analytics Service (in the `West Europe` region):

![Create Text Analytics Service](./images/CreateTA.png)

We then skip the next view _Select additional features_ and hit the button **Skip this step**

![Details of Creating the Text Analytics Service](./images/detailscreateta.png)

Then we hit **Review + Create** and create the resource.

### Extract sentiment, key phrases and entities from unstructured text

#### Detect language

The Language Detection API detects the language of a text document, using the [Detect Language method](https://westcentralus.dev.cognitive.microsoft.com/docs/services/TextAnalytics-v2-1/operations/56f30ceeeda5650db055a3c7).

So, let's create a sample application:

- Create a new folder **azdc-cognitive** on you machine and start a new Node.JS project.
  - run `npm init` on the command line and accept all options the wizard proposes
- Open Visual Studio Code by typing `code .`
- Add the code provided below to a new `detect.js` file.

```javascript
'use strict';

let https = require('https');
let subscription_key = '<paste-your-text-analytics-key-here>';
let endpoint = '<paste-your-text-analytics-endpoint-here>';

let path = '/text/analytics/v3.1/languages';

let response_handler = function (response) {
    let body = '';
    response.on('data', function (d) {
        body += d;
    });
    response.on('end', function () {
        let body_ = JSON.parse(body);
        let body__ = JSON.stringify(body_, null, '  ');
        console.log(body__);
    });
    response.on('error', function (e) {
        console.log('Error: ' + e.message);
    });
};

let get_language = function (documents) {
    let body = JSON.stringify(documents);

    let request_params = {
        method: 'POST',
        hostname: new URL(endpoint).hostname,
        path: path,
        headers: {
            'Ocp-Apim-Subscription-Key': subscription_key,
        },
    };

    let req = https.request(request_params, response_handler);
    req.write(body);
    req.end();
};

let documents = {
    documents: [
        { id: '1', text: 'This is a document written in English.' },
        { id: '2', text: 'Este es un document escrito en Español.' },
        { id: '3', text: '这是一个用中文写的文件' },
    ],
};

get_language(documents);
```

- Copy your Azure Cognitive Services Account **key and endpoint** into the code. You can find both on the _Overview_ or _Quickstart_ view in the Cognitive Services Account

You are all set. Now run the program from a terminal, change into the directory where the code is and run `node detect.js`.

After a few seconds, a successful response is returned in JSON, as shown in the following example:

```json
{
  "documents": [
    {
      "id": "1",
      "detectedLanguages": [
        {
          "name": "English",
          "iso6391Name": "en",
          "score": 1.0
        }
      ]
    },
    {
      "id": "2",
      "detectedLanguages": [
        {
          "name": "Spanish",
          "iso6391Name": "es",
          "score": 1.0
        }
      ]
    },
    {
      "id": "3",
      "detectedLanguages": [
        {
          "name": "Chinese_Simplified",
          "iso6391Name": "zh_chs",
          "score": 1.0
        }
      ]
    }
  ],
  "errors": []
}
```

#### Analyze sentiment

The Sentiment Analysis API detects the sentiment of a set of text records, using the [Sentiment method](https://westcentralus.dev.cognitive.microsoft.com/docs/services/TextAnalytics-v2-1/operations/56f30ceeeda5650db055a3c9). Sentiment analysis can be used to find out what customers think of your brand or topic by analyzing raw text for clues about positive or negative sentiment. The following example provides scores for two documents, one in English and another one in Spanish.

- Go back to Visual Studio Code.
- Add the code provided below to a new `sentiment.js` file.

```javascript
'use strict';

let https = require('https');

let subscription_key = '<paste-your-text-analytics-key-here>';
let endpoint = '<paste-your-text-analytics-endpoint-here>';

let path = '/text/analytics/v3.1/sentiment';

let response_handler = function (response) {
    let body = '';
    response.on('data', function (d) {
        body += d;
    });
    response.on('end', function () {
        let body_ = JSON.parse(body);
        let body__ = JSON.stringify(body_, null, '  ');
        console.log(body__);
    });
    response.on('error', function (e) {
        console.log('Error: ' + e.message);
    });
};

let get_sentiments = function (documents) {
    let body = JSON.stringify(documents);

    let request_params = {
        method: 'POST',
        hostname: new URL(endpoint).hostname,
        path: path,
        headers: {
            'Ocp-Apim-Subscription-Key': subscription_key,
        },
    };

    let req = https.request(request_params, response_handler);
    req.write(body);
    req.end();
};

let documents = {
    documents: [
        {
            id: '1',
            language: 'en',
            text: 'I really enjoy the new XBox One S. It has a clean look, it has 4K/HDR resolution and it is affordable.',
        },
        {
            id: '2',
            language: 'es',
            text: 'Este ha sido un dia terrible, llegué tarde al trabajo debido a un accidente automobilistico.',
        },
    ],
};

get_sentiments(documents);
```

- Copy your Cognitive Services Account key and endpoint into the code - as done before.

You are all set. Now run the program from a terminal, change into the directory where the code is and run `node sentiment.js`.

The result is measured as positive if it's scored closer to 1.0 and negative if it's scored closer to 0.0.
A successful response is returned in JSON, as shown in the following example:

```json
{
  "documents": [
    {
      "id": "1",
      "sentiment": "positive",
      "confidenceScores": {
        "positive": 1,
        "neutral": 0,
        "negative": 0
      },
      "sentences": [
        {
          "sentiment": "positive",
          "confidenceScores": {
            "positive": 1,
            "neutral": 0,
            "negative": 0
          },
          "offset": 0,
          "length": 102,
          "text": "I really enjoy the new XBox One S. It has a clean look, it has 4K/HDR resolution and it is affordable."
        }
      ],
      "warnings": []
    },
    {
      "id": "2",
      "sentiment": "negative",
      "confidenceScores": {
        "positive": 0.02,
        "neutral": 0.05,
        "negative": 0.93
      },
      "sentences": [
        {
          "sentiment": "negative",
          "confidenceScores": {
            "positive": 0.02,
            "neutral": 0.05,
            "negative": 0.93
          },
          "offset": 0,
          "length": 92,
          "text": "Este ha sido un dia terrible, llegué tarde al trabajo debido a un accidente automobilistico."
        }
      ],
      "warnings": []
    }
  ],
  "errors": [],
  "modelVersion": "2020-04-01"
}
```

#### Identify linked entities

The [Entities API](https://docs.microsoft.com/azure/cognitive-services/text-analytics/how-tos/text-analytics-how-to-entity-linking) identifies well-known entities in a text document, using the [Entities Recognition method](https://westus.dev.cognitive.microsoft.com/docs/services/TextAnalytics-V3-1/operations/EntitiesRecognitionGeneral) and [Entities Linking method](https://westus.dev.cognitive.microsoft.com/docs/services/TextAnalytics-V3-1/operations/EntitiesLinking). It extracts words from text, like "United States", then give you the type and/or Wikipedia link for this word(s). The type for "United States" would be `location`, while the link to Wikipedia is `https://en.wikipedia.org/wiki/United_States`. The following example identifies entities for English documents.

- Go back to Visual Studio Code.
- Add the code provided below to a new `entities.js` file.

```javascript
'use strict';

let https = require('https');

let subscription_key = '<paste-your-text-analytics-key-here>';
let endpoint = '<paste-your-text-analytics-endpoint-here>';
let path_linking = '/text/analytics/v3.1/entities/linking';
let path_recognition = '/text/analytics/v3.1/entities/recognition/general';

let response_handler = function (response) {
    let body = '';
    response.on('data', function (d) {
        body += d;
    });
    response.on('end', function () {
        let body_ = JSON.parse(body);
        let body__ = JSON.stringify(body_, null, '  ');
        console.log(body__);
    });
    response.on('error', function (e) {
        console.log('Error: ' + e.message);
    });
};

let get_entities_linking = function (documents) {
    let body = JSON.stringify(documents);

    let request_params = {
        method: 'POST',
        hostname: new URL(endpoint).hostname,
        path: path_linking,
        headers: {
            'Ocp-Apim-Subscription-Key': subscription_key,
        },
    };

    let req = https.request(request_params, response_handler);
    req.write(body);
    req.end();
};

let get_entities_recognition = function (documents) {
    let body = JSON.stringify(documents);

    let request_params = {
        method: 'POST',
        hostname: new URL(endpoint).hostname,
        path: path_recognition,
        headers: {
            'Ocp-Apim-Subscription-Key': subscription_key,
        },
    };

    let req = https.request(request_params, response_handler);
    req.write(body);
    req.end();
};

let documents = {
    documents: [{ id: '1', language: 'en', text: 'Microsoft is an It company.' }],
};

get_entities_linking(documents);
get_entities_recognition(documents);
```

- Copy your Cognitive Services Account key and endpoint into the code - as done before.

You are all set. Now run the program from a terminal, change into the directory where the code is and run `node entities.js`.

A successful response is returned in JSON (for _lining_ and _recognition_ endpoints), as shown in the following example:

```json
{
  "documents": [
    {
      "id": "1",
      "entities": [
        {
          "bingId": "a093e9b9-90f5-a3d5-c4b8-5855e1b01f85",
          "name": "Microsoft",
          "matches": [
            {
              "text": "Microsoft",
              "offset": 0,
              "length": 9,
              "confidenceScore": 0.26
            }
          ],
          "language": "en",
          "id": "Microsoft",
          "url": "https://en.wikipedia.org/wiki/Microsoft",
          "dataSource": "Wikipedia"
        },
        {
          "bingId": "bc30426e-22ae-7a35-f24b-454722a47d8f",
          "name": "Technology company",
          "matches": [
            {
              "text": "It company",
              "offset": 16,
              "length": 10,
              "confidenceScore": 0.84
            }
          ],
          "language": "en",
          "id": "Technology company",
          "url": "https://en.wikipedia.org/wiki/Technology_company",
          "dataSource": "Wikipedia"
        }
      ],
      "warnings": []
    }
  ],
  "errors": [],
  "modelVersion": "2021-06-01"
}

{
  "documents": [
    {
      "id": "1",
      "entities": [
        {
          "text": "Microsoft",
          "category": "Organization",
          "offset": 0,
          "length": 9,
          "confidenceScore": 1
        }
      ],
      "warnings": []
    }
  ],
  "errors": [],
  "modelVersion": "2021-06-01"
}
```

## Create and use the Translate Cognitive Service

There is also a Cognitive Service that let's you translate text "on-the-fly" with just a simple request - same as for the Text Analysis service used before.

- To use the Translation Service, you need to create a "Translator Text" resource in Azure. please go back to the Portal, click on "Create a resource" and search for "Text Translator". Create such a service, giving it a globally unique name and choosing the lowest "Pricing Tier" available. Please choose again the naming convention as before: **cog-translate-westeurope-001**

  ![Translator Text API Details](./images/TTCreateDetails.png)

- Now, back in Visual Studio Code, add a new JavaScript file called `translate-text.js`.

  - Add the code provided below:

  ```javascript
  'use strict';

  let https = require('https');

  let subscription_key = '<paste-your-text-translator-key-here>';
  let endpoint = 'https://api.cognitive.microsofttranslator.com';
  let region = '<paste-your-text-translator-service-region here>';
  let path = '/translate?api-version=3.0&to=es&to=it';

  let response_handler = function (response) {
      let body = '';
      response.on('data', function (d) {
          body += d;
      });
      response.on('end', function () {
          let body_ = JSON.parse(body);
          let body__ = JSON.stringify(body_, null, '  ');
          console.log(body__);
      });
      response.on('error', function (e) {
          console.log('Error: ' + e.message);
      });
  };

  let translate_text = function (documents) {
      let body = JSON.stringify(documents);

      let request_params = {
          method: 'POST',
          hostname: new URL(endpoint).hostname,
          path: path,
          headers: {
              'Ocp-Apim-Subscription-Key': subscription_key,
              'Ocp-Apim-Subscription-Region': region,
              'Content-type': 'application/json',
          },
      };

      let req = https.request(request_params, response_handler);
      req.write(body);
      req.end();
  };

  let documents = [
      {
          text: 'Hello World! We hope you enjoy your day here at the Microsoft office in Munich!',
      },
  ];

  translate_text(documents);
  ```

- Copy your Text Translator Account **key** into the code - as done before.

  :::tip
  📝 The endpoint is already predefined. **_No_** need to change it.\*
  :::

You are all set. Now run the program from a terminal, change into the directory where the code is and run `node translate-text.js`.

A successful response is returned in JSON, as shown in the following example:

```json
[
  {
    "detectedLanguage": {
      "language": "en",
      "score": 1
    },
    "translations": [
      {
        "text": "¡Hola mundo! ¡Esperamos que disfrute de su día aquí en la oficina de Microsoft en Múnich!",
        "to": "es"
      },
      {
        "text": "Salve, mondo! Speriamo che vi piaccia la vostra giornata qui presso l'ufficio Microsoft a Monaco di Baviera!",
        "to": "it"
      }
    ]
  }
]
```

## Azure Samples

Cognitive Services code samples:

- <https://github.com/Azure-Samples/cognitive-services-quickstart-code>
- For more Details on Cognitive Services or Azure Machine Learning Services visit the **AI Developer College:** <https://github.com/aidevcollege/aidevcollege>

## Cleanup

Remove the sample resource group.

```shell
az group delete -n rg-azdc-cognitive
```

[◀ Previous challenge](./04-challenge-bo-1.md) | [🔼 Day 3](../README.md) | [Next challenge ▶](./06-challenge-bo-2.md)
