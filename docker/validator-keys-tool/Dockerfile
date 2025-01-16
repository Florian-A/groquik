FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    python3 \
    python3-pip

RUN pip3 install --upgrade pip && pip3 install conan

RUN git clone https://github.com/ripple/validator-keys-tool /app

WORKDIR /app
RUN mkdir .build
WORKDIR /app/.build

RUN conan profile detect
RUN conan remote add ripple http://18.143.149.228:8081/artifactory/api/conan/conan-non-prod
RUN conan install .. --output-folder=. --build=missing

RUN cmake -DCMAKE_POLICY_DEFAULT_CMP0091=NEW \
    -DCMAKE_TOOLCHAIN_FILE:FILEPATH=conan_toolchain.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    ..

RUN cmake --build .

# CMD ["sh", "-c", "./validator-keys --unittest || ctest --test-dir ."]
CMD ["tail", "-f", "/dev/null"]