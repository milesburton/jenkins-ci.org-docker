FROM ubuntu

RUN apt-get update

RUN apt-get install -y python-software-properties build-essential curl git

RUN curl -sL https://deb.nodesource.com/setup | sudo bash -

RUN apt-get update

RUN apt-get install -y nodejs

RUN "wget -qO- https://get.docker.io/gpg | apt-key add -"

RUN "echo deb http://get.docker.io/ubuntu docker main /etc/apt/sources.list.d/docker.list"

RUN apt-get update && apt-get install -y curl openjdk-7-jdk unzip linux-image-extra-`uname -r`

RUN apt-get install -y lxc-docker

# NOTE DEFAULT FIREWALL

RUN apt-get update && apt-get install -y wget git curl zip && rm -rf /var/lib/apt/lists/*

ENV JENKINS_HOME /var/jenkins_home

# Jenkins is ran with user `jenkins`, uid = 1000
# If you bind mount a volume from host/vloume from a data container, 
# ensure you use same uid
RUN useradd -d "$JENKINS_HOME" -u 1000 -m -s /bin/bash jenkins

# Jenkins home directoy is a volume, so configuration and build history 
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

# `/usr/share/jenkins/ref/` contains all reference configuration we want 
# to set on a fresh new installation. Use it to bundle additional plugins 
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d


COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-angent-port.groovy

ENV JENKINS_VERSION 1.596

# could use ADD but this one does not check Last-Modified header 
# see https://github.com/docker/docker/issues/8331
RUN curl -L http://mirrors.jenkins-ci.org/war/1.596/jenkins.war -o /usr/share/jenkins/jenkins.war

ENV JENKINS_UC https://updates.jenkins-ci.org
RUN chown -R jenkins "$JENKINS_HOME" /usr/share/jenkins/ref

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

USER jenkins

COPY jenkins.sh /usr/local/bin/jenkins.sh
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]

# from a derived Dockerfile, can use `RUN plugin.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
COPY plugins.sh /usr/local/bin/plugins.sh
