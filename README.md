## Build Host Setup

To get started building this distribution, there are a number of required utilities on
the build host.

It is recommended to follow the setup instructions described in the
[OpenEmbedded Getting Started guide](https://www.openembedded.org/wiki/Getting_started).

For Ubuntu/Debian systems, generally all that's required is to run

```bash
$ sudo apt-get install gawk wget git-core diffstat unzip texinfo \
    gcc-multilib build-essential chrpath socat
```

Alternatively, a Dockerfile is included for creating the necessary build
environment:

```bash
$ docker build -t yoctobuilder .
```

## Repo Build Setup

There are a number of git repos that need to be initialized under the project
directory, in order to bring in the OpenEmbedded build system and the
linux distribution definitions and dependencies.

To do this, simply run

```bash
$ git submodule update --init --recursive
```

The first time it's run, it will take a few moments to complete. After the
first time it's run, it is safe to re-run if you need to refresh things to
a sane state.

## Starting the Build

If using the docker environment, first run

```bash
$ docker run -it --mount type=bind,src="$(pwd)",dst=/home/yocto yoctobuilder
```

Each shell in which a build will be performed needs to have run

```bash
$ source sources/openembedded-core/oe-init-build-env
```

from the project root directory. This will update some environment variables
and change the current working directory to the build directory, where there
are some choices open to you, depending on what you need.

### Build Performance Notes

The first time running the build command will take a very long time to complete.

Subsequent runs should complete much faster, depending on what has been changed
since the previous execution. This speedup is dependent on preserving the
downloads cache and sstate-cache under the `build` directory.  The cached
downloads and build data may be shared between developers in order to
significantly improve rebuild times.

Production builds should occur from a completely clean state, so they cannot
benefit from cache sharing, but re-using the cache _from_ production builds
is recommended.

Additionally, local mirrors of upstream source control repositories may be
kept. Instructing the build to use a local mirror can be accomplished by
passing an additional env variable to the build process:

```bash
PREMIRRORS_prepend='git://.*/.* http://localnetworkhost.org/mirror/ \n http://.*/.* http://localnetworkhost.org/mirror/ \n" bitbake core-image-minimal
```

### Building an Image For Raspberry Pi

The default `MACHINE` set in local.conf is `raspberrypi3-64` and `DISTRO` is `picard`, so all that's required is to set which image to build (`picard-full-cmdline`):

```bash
$ bitbake picard-full-cmdline
```

This image may then be loaded in a qemu instance by running

```bash
$ runqemu qemuarm64
```

