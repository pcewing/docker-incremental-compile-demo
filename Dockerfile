FROM centos:7 as myapp-base

FROM myapp-base as myapp-builder

RUN yum -y group install "Development Tools" && \
    yum clean all && \
    rm -rf /var/cache/yum

FROM myapp-base as myapp

RUN groupadd -g 2000 myapp && \
    useradd -m -u 2000 -g myapp myapp

ADD --chown=myapp:myapp ./build /myapp

WORKDIR /myapp
USER myapp:myapp

CMD ["bin/Debug/MyApp"]
