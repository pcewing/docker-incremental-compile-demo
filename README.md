# Incremental Builds in Docker

This repository demonstrates one way to accomplish incrementally compiling and
packaging a C/C++ application in Docker. Note that this method does not take
advantage of multi-stage builds.

First, build the *base* image:

```bash
docker image build -t myapp-base -f myapp-base.Dockerfile .
```

Next, build the *builder* image:

```bash
docker image build -t myapp-builder -f myapp-builder.Dockerfile .
```

Remove any pre-existing build directory on the host:

```bash
rm -rf ./build
```

Use the builder image to compile the application:

```bash
docker container run \
    -u $(id -u):$(id -g) \
    -v $(pwd):/workspace \
    -w /workspace \
    myapp-builder \
    sh -c './premake.sh && cd build && make'
```

Ensure the build directory now exists and the artifacts in it have the correct
ownership:

```bash
ls -a ./build
```

Try running the same command as before to build the application:

```bash
docker container run \
    -u $(id -u):$(id -g) \
    -v $(pwd):/workspace \
    -w /workspace \
    myapp-builder \
    sh -c './premake.sh && cd build && make'
```

If no changes were made to the main.cpp file, you should notice in the output
that it is *not* recompiled. Try making a change to *main.cpp* and running the
command again.

Once the application is built, bake it into a docker container image by
building the *myapp* image:

```bash
docker image build -t myapp -f myapp.Dockerfile .
```

Finally, verify that we can run the *myapp* container image:

```bash
docker container run myapp
```

