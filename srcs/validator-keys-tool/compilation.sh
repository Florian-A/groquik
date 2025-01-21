#!/usr/bin/env bash

set -o errexit  # Exit script on any error
set -o nounset  # Treat unset variables as errors
set -o xtrace   # Trace what gets executed (for debugging)

# Clone the repository
git clone https://github.com/ripple/validator-keys-tool /app
cd /app

# Create a build directory
mkdir .build
cd .build

# Add the Ripple Conan repository
conan remote add ripple http://18.143.149.228:8081/artifactory/api/conan/conan-non-prod

# Generate dependencies and CMake toolchain
conan install .. --output-folder . --build missing

# Configure with CMake
cmake -DCMAKE_POLICY_DEFAULT_CMP0091=NEW \
    -DCMAKE_TOOLCHAIN_FILE:FILEPATH=conan_toolchain.cmake \
    -DCMAKE_BUILD_TYPE=Release \
    ..

# Build the project
cmake --build . --parallel 8

cp validator-keys /usr/local/bin/validator-keys