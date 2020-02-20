# Incremental Builds in Docker

This repository demonstrates *one* way to accomplish incrementally compiling
and packaging a C/C++ application in Docker. **Premake** is used in this demo
to automatically generate makefiles that support incremental compilation.

## Concepts

Rather than having a single Docker image, we use a multistage build to create
three:

* myapp-base : A base image that contains the dependencies that are shared
  between build-time and run-time
* myapp-builder : An image based on the *myapp-base* image that also contains
  all build dependencies for compiling and linking the *MyApp* application,
  such as library headers and the GCC toolchain
* myapp : An image based on the *myapp-base* image that also contains all
  run-time dependencies of MyApp, such as the creation of the non-root user the
  application should be run as

The general workflow will be:

* Build the base and builder images
    * We can build just these two images by specifying a target when executing
      our first `docker image build` command
* Use the builder image to compile and link the *MyApp* application
    * By passing in the working directory as a volume, we can effectively
      extract all of the build artifacts back to the host
* Build the myapp image
    * Copy in the pre-built artifacts via the `ADD` directive

## Walkthrough

First, build the *builder* image which will also implicitly build the *base*
image:

```bash
docker image build -t myapp-builder --target myapp-builder .
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
ls -la ./build
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
docker image build -t myapp --target myapp .
```

Finally, verify that we can run the *myapp* container image:

```bash
docker container run myapp
```

