# Base image with Java 17 and Maven
FROM maven:3.9.6-eclipse-temurin-17

# Switch to root for installing packages
USER root

# Install Docker CLI and Git
RUN apt-get update && \
    apt-get install -y docker.io git && \
    apt-get clean

# Optional: create a non-root Jenkins user (can skip this)
# RUN useradd -m -s /bin/bash jenkins

