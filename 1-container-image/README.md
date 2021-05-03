# Build Container Images for Traditional Web Applications

It is essential to create a container images (often referred to as Docker images) to deploy an application in Kubernetes. They contain the runtime component(s) required to run the application files, which may also be included in the image, or be mounted as an external volume.

## Good reads

* [Best practices writing a Dockerfile](https://engineering.bitnami.com/articles/best-practices-writing-a-dockerfile.html)
* [Bitnami's Best Practices for Securing and Hardening Container Images](https://docs.bitnami.com/tutorials/bitnami-best-practices-hardening-containers/)

## Examples

For this talk, we have created a few examples of different ways to create a [WordPress](https://wordpress.org) container image. Find more information about them in the [examples](/1-container-image/examples) subfolder.

## Container image optimizations

At build-time and runtime, you would focus on different objectives because they are run by different users, in different environments, and have different requirements.

### Build-time optimizations

At build-time you would run actions actions that help reduce the deployment time of the container image, stabilize its logic and make it more secure. You have all the time of the world to create the image, but limited time to deploy it. For instance, the below items are good to run at build-time:

* Install app runtime dependencies, to reduce deployment time and possible network issues at runtime. You may also lack privileges to do so in runtime in certain cases (i.e. when running as a non-root user).
* Change file permissions/ownership: If the app has a large amount of files, setting permissions/ownership may take a lot of time depending on the environment used at runtime. Doing it at build-time may drastically reduce the deployment time.
* Run scripts to install app assets/dependencies or compile code: This may not only take a lot of time, but a high amount of resources, which is not ideal since some platforms (like Kubernetes) may impose a memory and CPU usage limit.

We will explain some of the different things you should keep an eye on when creating a container image.

#### Optimize container image size

It is very important that a `Dockerfile` is designed the **container image size optimization** in mind. This is because the layered format of OCI images can be a double-edged weapon: While they may help reduce network and disk resources if optimized properly, they can also cause huge network and disk resource usage, even causing the deployment time to suffer greatly.

These are some of the things you may want to look into:

* Using [multi-stage](https://docs.docker.com/develop/develop-images/multistage-build/) builds: When building a Dockerfile with multi-stage builds, only the layers in the final image are preserved, so the other ones can focus on running steps that are less efficient in terms of producing an optimal image size.
* Strategic Dockerfile design: You may want to group `RUN` commands (e.g. via shell `&&`) so that each step only produces the desired differences in the container image layers. That may require you install and remove packages per step, clear caches/temporary files, run a lot of commands in one step, etc.
* Docker `--squash` feature: When building an image with this option, all layers after the base image (defined in `FROM`) are "squashed" into one layer. This is the most efficient but has some [limitations](https://docs.docker.com/engine/reference/commandline/build/#squash-an-images-layers---squash-experimental).

A useful tool for troubleshooting container image size is [wagoodman/dive](https://github.com/wagoodman/dive).

##### Example: Multi-stage builds

Multi-stage builds are useful in the following cases:

* When building an image with build-time dependencies that to not need to be available at runtime.
* When files are modified in multiple container image layers, in which case they are counted twice.
* To simplify the Dockerfile, as cleanup can be avoided in each stage.

For example, given the following files:

* `Dockerfile`:

    ```Dockerfile
    FROM bitnami/minideb:buster as builder

    RUN apt-get update
    RUN apt-get install -y --no-install-recommends build-essential
    RUN rm -r /var/lib/apt/lists /var/cache/apt/archives
    COPY hello.c /
    RUN gcc -Wall hello.c -o hello
    RUN chmod a+x hello

    FROM bitnami/minideb:buster
    COPY --from=builder /hello /hello
    ```

* `hello.c`:

    ```Dockerfile
    #include <stdio.h>
    int main() {
      printf("Hello, world!");
      return 0;
    }
    ```

If you build that image, you can see that its size will be approximately 67.5MB. If you skip the multi-stage, it would weigh around 300MB just because of those unnecessary build dependencies (GCC).

##### Example: Strategic Dockerfile design

In a strategic Dockerfile design you would need to modify each file in one specific step, to avoid them getting added twice to the layers. You also need to ensure that each action is executed in a proper order, and that no unused files are left in the resulting image.

Given the previous example, here you would see an example of how to translate it into this approach:

```Dockerfile
FROM bitnami/minideb:buster as builder

COPY hello.c /
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && gcc -Wall hello.c -o hello && apt-get --purge autoremove -y build-essential && rm -r /var/lib/apt/lists /var/cache/apt/archives && rm hello.c
```

You can see that it is a lot more complex than the multi-stage equivalent. If you have limited capacity to use multi-stage, or require simpler layer structures, then you may be forced to use this approach unless you rely on Docker `--squash`.

In this case, the image is around 1MB bigger than the previous example with 68.6MB.

##### Example: Docker `--squash`

Docker `--squash` allows to reduce an entire image into two layers: The base image and the changes on top of it. Building is as simple as adding `--squash` to the `docker build` command, and allows for a Dockerfile like this:

```Dockerfile
FROM bitnami/minideb:buster

RUN apt-get update
RUN apt-get install -y --no-install-recommends build-essential
COPY hello.c /
RUN gcc -Wall hello.c -o hello
RUN apt-get autoremove -y --purge build-essential
RUN rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN rm hello.c
```

With `--squash`, the image weighs 67.9MB with 2 layers, while without, it's 312MB in size and 8 layers!

#### File permissions

In order to secure your application from write access to files that should not be writable, you need to protect files that are not meant to be writable by the application by restricting its access permissions.

You should keep the list of writable files/directories to the bare minimum. Ideally, only folders with application data and temporary files should be writable.

It is important to do this at build-time due to the reasons mentioned above in "Build-time optimizations". You must also keep an eye on how permissions are being set in the Dockerfile, as files with changed permissions are counted double (in terms of file size) when building the image, as they are basically duplicated between both layers.

#### Security with non-root users

In order to further secure your application from privilege escalations to get access files that should not be writable (in spite of having proper permissions), you should consider the usage of non-root users. There are three ways to do so:

* (NOT RECOMMENDED) Existing non-root user account with known UID: Run the container image as an existing system user.

  * Permissions: Setting file ownership at build time is enough for writable files.
  * Problem: It is incompatible with certain platforms that require the use of an arbitrary UID. This is the case of OpenShift, for example.

* (NOT RECOMMENDED) Existing non-root user account with arbitrary UID: Run the container image as an existing system user, but modify the UID at runtime at `/etc/passwd`.

  * Permissions: Writable files require group ownership, and `g+x` permissions.
  * Problem: It requires `/etc/passwd` to be writable at runtime, which can be a security risk.

* Unknown user account and arbitrary UID:

  * The most notable thing is its ugly prompts (`I have no name!) when entering the shell.
  * Incompatible with some apps that require an user account. This can be workaround with [`nss_wrapper`](https://cwrap.org/nss_wrapper.html).
  * Permissions: Writable files require require `root` group ownership, and `g+x` permissions.

Note that non-root containers have limited ability to set permissions at runtime, especially the ones with an arbitrary UID, so it is a good practice to use non-root containers if implemented with the proper security practices in mind.

### Runtime optimizations

The runtime scripts would contain the logic to run the application. At this point you would focus on reducing the container image deployment time.

There are some essential things that should be included in these scripts:

* Validation of inputs: Logic to ensure that the inputs sent to the image make sense, have a valid format, etc.
* Persistence of application data: Steps required to pre-populate the volume with app data, so that after a restart or recreation, the app data is still there.
* Run web application: Commands required to run the web application, so that it can be accessed from outside of the container image in the specified port.

It is important for these scripts to be as stable as possible, as well as running as the fastest possible. Any delay in these scripts will directly impact a re-deploy on Kubernetes, leading to the site getting down.

You may want to include other actions in your container image, but to do that, you should take into account the previous point and avoid it causing any relevant delay when deploying:

* Set app configuration based on inputs (i.e. DB credentials).
* Wait for external services (i.e. database) to avoid potential warnings in the logs.
* Logic for installing the app. For instance, to run a deployment wizard or to run database migrations.
* Other pre-installation and post-installation features: For instance, to extend the configuration of the app via inputs.

## Other considerations

When creating a container image, it is good to take into account the following actions:

#### Security considerations

Refer to the [Docker Security OWASP Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html) for a list of security recommendations for your image.

It is important to note that when restricting write privileges to the application files, you need to ensure that the application does not need write privileges to any of those files, and beware that it could limit app features (such as upgrades and so). Some of those folders may need to be persisted across different runs, while some others support being mounted as temporary file systems.

### Maintenance

It is important to design the image with maintenance in mind. Some good practices to follow are:

* Re-building the image periodically in a [CI/CD pipeline](/3-pipeline).
* Tag each new build of the image with a different name. In Bitnami, we are following the `-rX` to specify different revisions, where `X` is a number that increases for each build.
* Ensure that the image can be built consistently. Things to help this could be, for example, to use [Debian snapshot base images](https://hub.docker.com/r/debian/snapshot) or avoid dynamic network requests (i.e. rely on `package-lock.json` instead of `package.json` for installing dependencies).

### Visibility

If the image should be public or not. If it should not be public, identify the location where it will be stored, and ensure it can be accessed when needed at runtime, via [pull secrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/), a VPN amonst others.

### Multi-arch

If you are expecting your image to work in different architectures, like on an Intel/AMD-based server but also on a Raspberry Pi or an M1 Mac, you may want to consider adding support for [multi-arch](https://docs.docker.com/docker-for-mac/multi-arch/).

In this case, it is best to rely on system packages for app dependencies, if not, you would need to re-compile these for each supported arch.
