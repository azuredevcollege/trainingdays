# get dotnetcore sdk image to build the function project
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
COPY . /src/dotnet-function-app
RUN cd /src/dotnet-function-app && mkdir -p /home/site/wwwroot && dotnet publish *.csproj --output /home/site/wwwroot

# get the azure function image
FROM mcr.microsoft.com/azure-functions/dotnet:3.0
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

# copy files from build image to runtime image
COPY --from=build ["/home/site/wwwroot", "/home/site/wwwroot"]