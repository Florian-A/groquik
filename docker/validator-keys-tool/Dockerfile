FROM ubuntu:22.04

# Set environment variables
ARG GCC_VERSION=11
ENV GCC_VERSION=${GCC_VERSION}
ARG CONAN_VERSION=1.60.0
ENV CONAN_VERSION=${CONAN_VERSION}

RUN mkdir /build
RUN cp /bin/bash /build/

# Install prerequisites
WORKDIR /root
COPY prerequisites.sh .
RUN ./prerequisites.sh

# # Make rippled build
# WORKDIR /root
# COPY compilation.sh .
# RUN ./compilation.sh


CMD ["tail", "-f", "/dev/null"]