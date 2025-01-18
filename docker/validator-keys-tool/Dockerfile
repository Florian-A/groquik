FROM ubuntu:22.04

# Set environment variables
ARG GCC_VERSION=11
ENV GCC_VERSION=${GCC_VERSION}
ARG CONAN_VERSION=1.60.0
ENV CONAN_VERSION=${CONAN_VERSION}

# Install prerequisites
WORKDIR /root
COPY prerequisites.sh .
RUN chmod +x prerequisites.sh
RUN ./prerequisites.sh

RUN mkdir /app

# Make validation keys tool
WORKDIR /app
COPY compilation.sh .
RUN chmod +x compilation.sh
RUN ./compilation.sh

CMD ["tail", "-f", "/dev/null"]