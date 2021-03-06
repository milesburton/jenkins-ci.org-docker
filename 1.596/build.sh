JENKINS_HOME=/var/jenkins_home
JENKINS_USER=jenkins
JENKINS_DOCKER_IMAGE=ubuntu-jenkins-docker
JENKINS_DOCKER_CONTAINER=$JENKINS_DOCKER_IMAGE
rm -rf $JENKINS_HOME
userdel $JENKINS_USER
docker rm $JENKINS_DOCKER_CONTAINER

docker build -t $JENKINS_DOCKER_IMAGE .  
useradd -d "$JENKINS_HOME" -u 9765 -m -s /bin/bash $JENKINS_USER
chown -R $JENKINS_USER $JENKINS_HOME
docker run -i -t  --privileged --name $JENKINS_DOCKER_CONTAINER -p 9090:8080 -v $JENKINS_HOME:$JENKINS_HOME $JENKINS_DOCKER_IMAGE 


