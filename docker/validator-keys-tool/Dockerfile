FROM ubuntu:24.10

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    python3 \
    python3-full \
    python3-dev \
    python3-pip \
    python3-xyzservices \
    libboost-all-dev \
    libxxhash-dev \
    libdate-tz3

RUN pip3 install --upgrade pip && pip3 install conan

# Clone du projet Ripple
RUN git clone https://github.com/ripple/validator-keys-tool /app

WORKDIR /app
RUN mkdir .build
WORKDIR /app/.build

# Configuration de Conan
RUN conan profile detect
RUN conan remote add ripple http://18.143.149.228:8081/artifactory/api/conan/conan-non-prod

# Création d'un fichier conanfile.txt temporaire pour date
# RUN echo "[requires]" > /tmp/conanfile.txt && \
#     echo "date/3.0.1" >> /tmp/conanfile.txt && \
#     echo "[generators]" >> /tmp/conanfile.txt && \
#     echo "CMakeDeps" >> /tmp/conanfile.txt && \
#     echo "CMakeToolchain" >> /tmp/conanfile.txt

# Installation de date avec son propre conanfile
# RUN conan install /tmp/conanfile.txt \
#     --output-folder=. \
#     --build=missing

# Installation des dépendances du projet
RUN conan install .. \
    --output-folder=. \
    --build=missing

# Compilation avec CMake
RUN cmake -DCMAKE_POLICY_DEFAULT_CMP0091=NEW \
    -DCMAKE_TOOLCHAIN_FILE:FILEPATH=conan_toolchain.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH="/root/.conan2/p" \
    ..

RUN cmake --build .

# Maintien du conteneur actif
CMD ["tail", "-f", "/dev/null"]