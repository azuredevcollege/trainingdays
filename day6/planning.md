# Azure Developer College - Day 6 

## Goal

The main goal of the Day 6 is basically building Linux Container and Docker knowledge. Day will start with fundamentals and skill building part will continue step by step. By the end of the day, all developers will be able to build Docker images and have all the information related to running them on production systems.


## Agenda

[Challenge 0]

09:00 - 09:45 [Info Slot 1] 45 min

09:45 - 10:15 [Challenge Slot 1] 30 min

10:15 - 10:30 [Break] 15 min

10:30 - 11:30 [Info Slot 2] 60 min

11:30 - 12:00 [Challenge Slot 2] 30 min

12:00 - 13:00 [Lunch Break] 60 min

13:00 - 13:45 [Info Slot 3] 45 min

13:45 - 14:15 [Challenge Slot 3] 30 min

14:15 - 14:30 [Break] 15 Min

14:30 - 15:30 [Info Slot 4] 60 min

15:30 - 16:00 [Challenge Slot 4] 30 min

16:00 - 16:30 [Info Slot 5] 30 min 

16:30 - 17:00 [Challenge Slot 5] 30 min

[Challenge 6]

## Agenda Details

* Challenge 0: Prerequisites

* Info Slot 1: Docker 101
  * What is Docker?
  * Docker CLI and Basics

* Challenge 1: Docker 101

* Info Slot 2: Container 101
  * Docker Container Basics

* Challenge 2: Container 101

* Info Slot 3: Docker Objects
  * Plug-ins
  * Volume
  * Network

* Challenge 3: Docker Objects

* Info Slot 4: Image and Registry
  * Image Basics
  * Registry
  * Image Creation

* Challenge 4: Image and Registry

* Info Slot 5: Azure Container Services
  * Different Container Services on Azure
  * CI/CD

* Challenge 5: Azure Container Services

* Challenge 6: Self-learning




## Info and Challenge Slots Details
### Challenge 0 (Prerequisite)
* Docker hub id and repo creation 
* Docker Desktop for Mac 
* Docker Desktop for Windows or Vm 
* Azure Installation
  * Vscode and Extensions installation 
  * GitHub Repo clone 

### INFO SLOT 1 (Docker 101)
  * What is Docker?
    * Linux Container Concept (LXC, Kernel, Namespaces, Cgroups)
    * Docker history
    * Container and Image
    * Container vs VM
  * Docker CLI and Basics
    *  How to use CLI? (Help, version, cli not equals to daemon, management sub command)
    * Version, info
    * Basics (Name, ID)
    * How to run Docker Containers (docker run, start, stop, delete, ls)
    * Most used options (rm, -it etc.)
    * Detach, Active, Task Containers
    * Exec (Executing commands inside Containers)

### Challenge 1 (Docker 101)
* Is Docker running?
* Check version and details
* Use --help option
* Create and run Docker containers. Detached, active, task. 
* Stop and Delete.
* List. Running, stopped
* Check IDs and names. 
* Use id instead of name. Vice versa
* Inspect container details

### INFO SLOT 2 (Container 101)
* Docker Container Basics
  * Theory (one app one container)
  * Union File System
  * Copy on Write
  * Container Life cycle (cattle vs pet)
  * Stdin, Stdout, Stderr
  * PIDs (Stats and Top)
  * Consumption Limits 
  * Environment Variables


### Challenge 2 (Container 101)
* Execute a command inside a running container
* TTY, Interactive. Connecting to the container. Running, from scratch
* Attach a running container and detach
* Check running processes inside and outside of the container
* Check container's current system resource consumption
* Check all containers' current system resource consumption on host
* Limit a container's memory and cpu consumption
* Define Environment Variables by options and files
* Create 2 containers from same image. Connect to one, add files, changes some files. Connect to other and see they are not there
* Check the layers of these containers and find writable layer. check the files inside these folders on host
* Copy a file from container to host and from host to container

### INFO SLOT 3 (Docker Objects)
* Batteries included but removable
* Docker Volume (Volume drivers, Bind Mounts)
* Docker Logging (Logging drivers)
* Docker Network (basics, drivers, port publish) 
		
### Challenge 3 (Docker Objects)	
* Create a volume, start a container with that. 
* Create another container with that volume mounted. 
* Create files on one and check from other. 
* Delete both containers. Create another one with that volume mounted and check files.
* Mount that volume to another container read only. 
* Check volume location on host and see files. 
* Bind mount a folder on host
* Create a nginx container and see logs, tail, since, until, follow. Check symlink.
* Create a new container on none network and check if it can connect or not. 
* Create a new container on host network and check it's ifconfig 
* Create a new user defined bridge network. connect a running container to that, inspect network object and see container's ip
* Create 2 containers connected to this network. check and see that dns resolution is possible. 
* Create a container connected to default network. ping other containers by their names and ips.

### INFO SLOT 4  (Image and Registry)
* Image Basics
  * Image naming scheme and tags
  * Layers
  * Image pull, push
* Registry
  * What is an image registry?
  * Docker hub (Official Images, non-official images)
  * Repository
  * Azure Container Registry
* Image Creation
  * Dockerfile (Instruction, format)
  * ADD vs. COPY - ENTRYPOINT vs. CMD
  * Exec vs. Shell form
  * Multi-stage builds and build cache
  * Build ARG
  * Docker Commit - Docker save/load

### Challenge 4 (Image and Registry)	
* Image pull and push
* Tags and tagging
* Build multiple images (Dockerfiles)
* Dockerfile Instructions 
* Build cache
* Commit a running container and convert it to an image

### INFO SLOT 5  (Azure Container Services)
* Different Container Services on Azure
  * Container Instances
  * App Service
  * Azure Kubernetes Service 
  * Container Registry
  * Service Fabric, Batch, Functions
  * CI/CD
  * Azure Devops
  * Github Actions

### Challenge 5 (Azure Container Services)
* Create your Azure Container Registry instance
* Tag your images and push them to ACR
* Build your image using Azure Devops and store it on ACR 
* Create a new app service web app using this container


### Challenge 5 (Self-Learning)
* Docker Compose
* Windows Containers
* WSL
* Azure Functions inside Containers