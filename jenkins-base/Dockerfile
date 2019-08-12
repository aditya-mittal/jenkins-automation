FROM jenkins/jenkins:2.175-slim

USER root

RUN apt-get update && \
    apt-get install --no-install-recommends -y apt-transport-https \
        ca-certificates curl gnupg2 software-properties-common lsb-release locales && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install --no-install-recommends -y docker-ce && \
    apt-get -y autoremove && \
    $(dpkg -l | grep '^rc' | awk '{print $2}') | xargs apt-get purge && \
    rm -rf /var/lib/apt/lists/* && \
    usermod -aG docker jenkins

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
    locale-gen en_US.UTF-8

ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"

USER jenkins

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

COPY casc-configs /usr/share/jenkins/ref/casc-configs

ENV CASC_JENKINS_CONFIG="/usr/share/jenkins/ref/casc-configs"