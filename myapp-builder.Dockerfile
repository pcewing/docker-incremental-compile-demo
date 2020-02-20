FROM myapp-base

RUN yum -y group install "Development Tools" && \
    yum clean all && \
    rm -rf /var/cache/yum

