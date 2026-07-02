# Key Features:
Automated CI/CD pipeline with Jenkins
Dockerized Flask and Nginx application
Reverse proxy configuration with Nginx
Docker Compose orchestration
Automated deployment to AWS EC2 via SSH
Health checks and functional testing

# Project Overview

## The Application

This project demonstrates a containerized web application built with **Flask**, **Nginx**, and **Docker Compose**.

The application consists of two containers:

* **Flask container:** Runs a Python Flask application that collects system resource usage (CPU, memory, and other metrics) from the running Flask container and renders the information on a web page.
* **Nginx container:** Acts as a reverse proxy. It receives incoming HTTP requests and forwards them to the Flask application.

The request flow is:

```
Client → Nginx → Flask
```

Both containers are orchestrated using **Docker Compose**, allowing the application to be deployed with a single command.

After cloning this repository, the application can be deployed locally or on an AWS EC2 instance, using Docker Compose.

---

## CI/CD Pipeline

This project also includes a **Jenkins pipeline** that automates the build, testing, and deployment process.

The pipeline performs the following stages:

* Checkout the source code from GitHub.
* Build the Docker images.
* Start the application containers.
* Perform a health check on the Nginx web server.
* Execute a functional test to verify that the application is working correctly.
* Deploy the latest version of the application to a running AWS EC2 instance.

The deployment server (EC2) hosts the same Docker Compose application, allowing Jenkins to automatically update the running containers whenever a new version is deployed.

The Jenkins instance itself runs inside a Docker container on a local machine and includes the required Docker tools to execute the pipeline.

The deployment workflow is illustrated below:

```
Developer
    │
git push
    │
    ▼
GitHub Repository
    │
    ▼
Jenkins Pipeline
    │
    ▼
AWS EC2 Instance
    │
    ▼
Docker Compose
    │
    ▼
Updated Application
```

This project demonstrates the integration of containerization, reverse proxy configuration, automated testing, and continuous deployment using Docker, Docker Compose, Jenkins, Nginx, Flask, GitHub, and AWS EC2.


Pipeline Stages:

| Stage            | Description                                              |
| ---------------- | -------------------------------------------------------- |
| Checkout         | Clones the latest version from GitHub                    |
| Build            | Builds the Docker images                                 |
| Start Containers | Starts the Flask and Nginx containers                    |
| Health Check     | Verifies that Nginx is responding                        |
| Functional Test  | Confirms the application returns the expected HTML       |
| Deploy           | Connects to the EC2 instance and updates the application |
| Verify Deploymnt | Verifies the EC2 instance is responding                  |
| Cleanup          | Stops the local test environment                         |


# Project Structure

* **`flask/`** – Contains the Flask application, including the Python source code and HTML templates used to collect and display system resource usage.
* **`nginx/`** – Contains the Nginx configuration files, including the reverse proxy configuration used to forward requests to the Flask application.
* **`Dockerfile`** – Defines the custom Jenkins image used to run the CI/CD pipeline locally with the required Docker tools installed.
* **`Jenkinsfile`** – Defines the Jenkins CI/CD pipeline, including the build, testing, and deployment stages.
* **`docker-compose.yml`** – Defines and orchestrates the Flask and Nginx containers.

# Running the Application

From the project's root directory, build the Docker images:

```bash
docker compose build
```

Start the application:

```bash
docker compose up -d
```

# AWS EC2 Requirements

To deploy the application using the CD stage of the Jenkins pipeline, an AWS EC2 instance must be configured with the following requirements:

## Operating System

* Ubuntu 24.04 LTS (recommended)

## Required Software

The following software must be installed on the EC2 instance:

* Git
* Docker Engine
* Docker Compose

Example installation:

```bash
sudo apt update
sudo apt install -y git docker.io docker-compose-v2
sudo usermod -aG docker ubuntu
```

> **Note:** After adding the `ubuntu` user to the `docker` group, log out and log back in (or restart the instance) for the changes to take effect.

## Network Configuration

The EC2 Security Group should allow the following inbound traffic:

| Port | Protocol | Purpose                                                     |
| ---- | -------- | ----------------------------------------------------------- |
| 22   | SSH      | Remote access from Jenkins (or your public IP during setup) |
| 80   | HTTP     | Access to the web application                               |

## Project Setup

Clone this repository onto the EC2 instance:

```bash
git clone https://github.com/marcosolano21/ci-cd-project-docker-jenkins-ec2.git
```

Build and start the application:

```bash
cd ci-cd-proyect
docker compose up -d --build
```

Once the containers are running, the application should be accessible from:
```text
http://<EC2_PUBLIC_IP>
```

## SSH Access for Jenkins
For the deployment stage to work, Jenkins must be able to connect to the EC2 instance via SSH.


# Accessing the Application

### Local Deployment

If you are running the application locally, open your browser and navigate to:

```text
http://localhost
```

### AWS EC2 Deployment

If the application is deployed on an AWS EC2 instance, access it using the instance's public IP address:

```text
http://<EC2_PUBLIC_IP>
```


# Additional Instructions

## Build the Jenkins Docker Image

To build the custom Jenkins image used for the CI/CD pipeline, run:

```bash
docker build -t my-jenkins .
```

## Run the Jenkins Container

To start the Jenkins container with the required Docker socket and persistent Jenkins data, run:

```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v //var/run/docker.sock:/var/run/docker.sock \
  my-jenkins
```

> **Note:** The Docker socket is mounted into the Jenkins container so that Jenkins can execute Docker and Docker Compose commands on the host machine. The `jenkins_home` volume persists Jenkins configuration, installed plugins, credentials, and job data across container restarts.
>
> **Windows (Docker Desktop):** Use the command above, which mounts the Docker socket using `//var/run/docker.sock`.
>
> **Linux:** Replace the Docker socket mount with:
>
> ```bash
> -v /var/run/docker.sock:/var/run/docker.sock
> ```
>
> The remainder of the `docker run` command stays the same.
