FROM myapp-base

RUN groupadd -g 2000 myapp && \
    useradd -m -u 2000 -g myapp myapp

ADD --chown=myapp:myapp ./build /myapp

WORKDIR /myapp
USER myapp:myapp

CMD ["bin/Debug/MyApp"]
