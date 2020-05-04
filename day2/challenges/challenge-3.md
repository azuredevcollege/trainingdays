# Messaging #

In this chapter, you will get to know Azure messaging offerings to loosely connect services with each other. You will use *Azure Service Bus Topics* as an example. *Azure Storage Queues* will be used in the next Break Out session, our SCM Contacts application.

## Here is what you will learn ##

- Use Azure Service Bus for pub/sub scenarios (Consumer/Producer pattern)
- Use Azure Logic Apps to subscribe to topics and process them

## Azure Service Bus Publish / Subscriber Pattern ##

### Create an Azure Service Bus Namespace ###

To begin to use Azure Service Bus, you first need to create a namespace with a globally unique name. As done before with other services, create a resource group, e.g. *messaging-rg*, in West Europe and click on "Create Resource". Search for "Service Bus" and click on "Create".

Now fill out the form, giving your Service Bus a unique name and choosing the Pricing Tier **Standard**.

When the Service Bus is created, open it in the Portal and add a new Topic:

![portal_sb_topic](./img/portal_sb_topic.png "portal_sb_topic")

Give the **Topic** a name, e.g. *message* and leave the other parameters as proposed by Azure.

When the topic has been created, open it in the portal and create a **Subscription** via the menu bar. Give it a name, e.g. *testsubscription*, and again leave all other parameters as is. 

When the **Topic** and the **Subscription** have been created, we need to copy the **Connection String** to our Service Bus. Therefore, got to "Shared Access Policy", "RootManagedSharedAccessKey" (of the Service Bus, not the topic!) and copy/note down the **Primary Connection String**.

### Add a Producer ###

Now open Visual Studio Code and open the folder **day2/challenges/sbtester**. There, you will find a sample application that is able to send messages to a Service Bus Topic, like the one we have just created.

Open *Program.cs* and enter the connection string and the topic name to the predefined variables.

```csharp
const string ServiceBusConnectionString = "<your_connection_string>";
const string TopicName = "<your_topic_name>";
```

Make yourself familiar with the code and examine, how messages are created and sent to Azure Service Bus. If you are done with that, run the sample application.

Open a terminal in the folder *day2/challenges/sbtester* and execute:

```shell
$ dotnet build && dotnet run
Microsoft (R) Build Engine version 16.4.0+e901037fe for .NET Core
Copyright (C) Microsoft Corporation. All rights reserved.

  Restore completed in 32.32 ms for /Users/christiandennig/dev/azure-developer-college/day2/challenges/sbtester/sbtester.csproj.
  sbtester -> /Users/christiandennig/dev/azure-developer-college/day2/challenges/sbtester/bin/Debug/netcoreapp3.1/sbtester.dll

Build succeeded.
    0 Warning(s)
    0 Error(s)

Time Elapsed 00:00:01.29
======================================================
Press ENTER key to exit after sending all the messages.
======================================================
Sending message: Message d31e0280-d300-4a91-8b98-c84b0746040a
Sending message: Message 76ef548c-9483-439e-8b1f-ee9c1580dc50
Sending message: Message 383b103b-ab00-4162-ae8c-9ad6dc67669e
Sending message: Message e855bbc0-e74c-4739-ba65-33754d5aedce
Sending message: Message 424f5f20-074c-45a4-9f67-97c7cf43d027
Sending message: Message 76b35c84-1fe0-48f7-a82c-a279db2e0fec
Sending message: Message 25ece212-5a4c-45e1-a04d-bc3ac07a9058
Sending message: Message 8f0feabe-40fc-405b-a46d-8a6901805152
Sending message: Message e9f1ca91-82c5-40db-ad3f-e5f483424556
Sending message: Message d61b256c-5c8c-482c-904a-63d322003c70
```

Congratulations! You have just sent your first 10 messages to an Azure Service Bus Topic. Check that the messages have arrived in the subscription queue.

![portal_sb_messages](./img/portal_sb_messages.png "portal_sb_messages")

So, now let's create the subscriber that picks up the messages and does some kind of processing with each message. We could use another console application, but that's more than boring! We will use an Azure Logic App...*Serverless Resprise*, so to say!

### Add a Consumer ###

In the Portal create a new Azure Logic App. As usual via "Create a resource", give it a unique name, use the same resource group as for the Service Bus (*messaging-rg*) and put it in "West Europe".

When the Logic App has been deployed, open it in the Portal and in the *Templates* section, click on "Blank logic App". In the search box, search for "service bus topic" and choose "When a message is received in a topic subscription (auto-complete).

![portal_la_topic](./img/portal_la_topic.png "portal_la_topic")

Now give the connection a name and choose the Service Bus you created in the previous chapter. When the connection to the Service Bus is established, you can specify the *Topic* and the *Subscription* to use. Your Logic App should now look like that:

![portal_la_trigger](./img/portal_la_trigger.png "portal_la_trigger")

You have just created the trigger connection between the Logic App and your Service Bus Topic/Subscription.

Now, it's up to you what to do now with the messages, regarding the 200+ connectors we have in Azure Logic Apps! You can follow along with the sample that takes messages and creates blobs on a Storage Account.

> ...but you could also connect e.g. your O365 Mail or Gmail account and send a few messages to your colleagues next to you or add them to a database, a SAP System, Salesforce, use Azure Cognitive Services to analyze sentiment?! Imagine the possibilities :) So, be creative! 

Here, we will follow the *boring path* and put the messages in a storage account blob container.

> If you have already deleted the Storage Account from the previous challenge, go and create a new one and add a container! You now know, how this is can be done.

Back in the Logic App, you need to add a "New Step", click on that button. In the search field, enter "blob" and select "Create Blob" from the suggested Actions. Enter a name for the connection and choose the appropriate Storage Account. Click "Create".

Configure the action:

- choose the container to store the messages to (*Folder Path*).

- For the *blobname*, we simply let Azure create one for us. In the Expression tab, enter...```rand(100000,999999)``` ...followed by ".txt".

- For *Blob Content*, choose the predefined field "Content" (if that doesn't appear in the dropdown, switch to the Expression tab an enter ```base64ToString(triggerBody()?['ContentData'])```).

> INFO: The message body is a base64 encoded string we must decode first.

The designer should now look like that:

![portal_la_creatblob](./img/portal_la_creatblob.png "portal_la_creatblob")

Save the Logic App and click on the "Run" button in the command bar.

Now got back to the *sbtester* app and run it again. A few seconds later, after the messages have been sent, you should see a successfully processed Service Bus message.

![portal_la_sbsuccess](./img/portal_la_sbsuccess.png "portal_la_sbsuccess")

Also check the Storage Explorer and have a look at the files that have been written.

![storage_explorer_la](./img/storage_explorer_la.png "storage_explorer_la")

## Optional ##

You have seen how many connectors Azure Logic Apps has "under the hood". Take the same scenario and adjust the messages to your needs (e.g. send JSON) and connect to another service, maybe one outside of Azure? (Gmail, Outlook, O365, SAP, Twitter...?!)

**Happy Hacking!** :)

## House Keeping ##

Remove the sample resource group.

```shell
$ az group delete -n messaging-rg
```
