# Configuration

## Why?

Separate config from containers, env variables etc.

## ConfigMaps

### Literal Values

create cfgmp (kubectl + yaml). perhaps show how to do a dry-run?! kubectl create cofigmap --dry-run -o yaml

use key in a pod

### From File

create cfgmp

use file as mount (shortly describe volume/mount in pods) in frontend pod

## Secrets

What for?
Not really secure --> use KeyVault

### Literal Values

show creation and how to use in case of contacts api (env: ConnectionStrings\_\_DefaultConnectionString)
