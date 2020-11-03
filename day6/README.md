# Day 6 Containerization

## Goal

The main goal of the Day 6 is basically building Linux Container and Docker knowledge. Day will start with fundamentals and skill building part will continue step by step. By the end of the day, all developers will be able to build Docker images and have all the information related to running them on production systems.

---

## Agenda and Syllabus

**[Challenge 0: Prerequisites](./challenges/challenge0.md)**

- Docker hub id and repo creation
- Docker Desktop for Mac
- Docker Desktop for Windows or Vm
- Azure Installation
  - Vscode and Extensions installation
  - GitHub Repo clone

**Info Slot 1: Docker 101**

- What is Docker?
  - Linux Container Concept (LXC, Kernel, Namespaces, Cgroups)
  - Docker history
  - Container and Image
  - Container vs VM
- Docker CLI and Basics
  - How to use CLI? (Help, version, cli not equals to daemon, management sub command)
  - Version, info
  - Basics (Name, ID)
  - How to run Docker Containers (docker run, start, stop, delete, ls)
  - Most used options (rm, -it etc.)
  - Detach, Active, Task Containers
  - Exec (Executing commands inside Containers)

**[Challenge 1: Docker 101](./challenges/challenge1.md)**

- First let's check the current status of the Docker.
- It's time to get more information about our Docker installation.
- Let's see "How to become a Docker Cli master?"
- It's time to run our first container
- Detach container
- Running another application inside the container
- Connect to a Docker container
- Inspecting a container's details

**Info Slot 2: Container 101**

- Docker Container Basics
  - Theory (one app one container)
  - Union File System
  - Copy on Write
  - Container Life cycle (cattle vs pet)
  - Stdin, Stdout, Stderr
  - PIDs (Stats and Top)
  - Consumption Limits
  - Environment Variables

**[Challenge 2: Container 101](./challenges/challenge2.md)**

- First let's create couple of containers
- Docker logs
- Docker top and stats
- CPU and Memory consumption limits
- Environment Variables

**Info Slot 3: Docker Objects**

- Batteries included but removable
- Docker Volume (Volume drivers, Bind Mounts)
- Docker Network (basics, drivers, port publish)

**[Challenge 3: Docker Objects](./challenges/challenge3.md)**

- Creating the first volume
- Other volume options
- Default networks - Bridge
- Default networks - Host
- Default networks - None
- User-defined bridge network
- Port publishing

**Info Slot 4: Image and Registry**

- Image Basics
  - Image naming scheme and tags
  - Layers
  - Image pull, push
- Registry
  - What is an image registry?
  - Docker hub (Official Images, non-official images)
  - Repository
  - Azure Container Registry
- Image Creation
  - Dockerfile (Instruction, format)
  - ADD vs. COPY - ENTRYPOINT vs. CMD
  - Exec vs. Shell form
  - Multi-stage builds and build cache
  - Build ARG
  - Docker Commit - Docker save/load

**[Challenge 4: Image and Registry](./challenges/challenge4.md)**

- Tagging
- Building the first image
- Building a nodejs image
- Multi-stage build
- Php contacts app
- Docker commit

**Info Slot 5: Azure Container Services**

- Container Services on Azure
  - Container Instances
  - App Service
  - Batch
  - Azure Service Fabric
  - Azure Red Hat OpenShift
  - Azure Container Registry (ACR)
  - Azure Kubernetes Service (AKS)

**[Challenge 5: Azure Container Services](./challenges/challenge5.md)**

- Azure Container Registry
- Azure Kubernetes Service
- Deploy php app to AKS
- Clean-up

**[Challenge 6: Self-learning](./challenges/challenge6.md)**

- Reading list (Home-work)

---

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
