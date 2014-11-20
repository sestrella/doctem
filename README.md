# docker + template = doctem

[![Build Status](https://travis-ci.org/sestrella/doctem.svg?branch=master)](https://travis-ci.org/sestrella/doctem)

Create multiple `Dockerfile`s from a single template and a properties file.

## Build

```
cabal sandbox init
cabal update
cabal install --only-dependencies --enable-tests
```

## Usage

Create a properties file named `doctem.yml` like:

```yaml
7.6:
  ghc: "7.6.3"
7.8:
  ghc: "7.8.3"
```

Create a file named `Dockertemplate` like:

```
FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:hvr/ghc
RUN apt-get update && apt-get install -y ghc-{{ghc}}

ENTRYPOINT ["ghci"]
```

Run `doctem` and you will get two `Dockerfile`s like:

```
# File 7.6/Dockerfile
FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:hvr/ghc
RUN apt-get update && apt-get install -y ghc-7.6.3

ENTRYPOINT ["ghci"]

# File 7.8/Dockerfile
FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:hvr/ghc
RUN apt-get update && apt-get install -y ghc-7.8.3

ENTRYPOINT ["ghci"]
```
