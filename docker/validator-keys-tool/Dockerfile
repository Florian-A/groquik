FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    python3 \
    python3-pip \
    libboost-all-dev \
    libxxhash-dev

RUN pip3 install --upgrade pip && pip3 install conan

# Clone du projet Ripple
RUN git clone https://github.com/ripple/validator-keys-tool /app

WORKDIR /app
RUN mkdir .build
WORKDIR /app/.build

# Configuration de Conan
RUN conan profile detect
RUN conan remote add ripple http://18.143.149.228:8081/artifactory/api/conan/conan-non-prod

# Installation des dépendances avec Conan (une seule commande)
RUN conan install .. \
    --output-folder=. \
    --build=missing \
    --requires=date/3.0.1

# Compilation avec CMake
RUN cmake -DCMAKE_POLICY_DEFAULT_CMP0091=NEW \
    -DCMAKE_TOOLCHAIN_FILE:FILEPATH=conan_toolchain.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    ..

RUN cmake --build .

# Maintien du conteneur actif
CMD ["tail", "-f", "/dev/null"]