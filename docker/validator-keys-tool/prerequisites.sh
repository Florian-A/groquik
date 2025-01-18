#!/usr/bin/env bash

set -o errexit  # Exit script on any error
set -o nounset  # Treat unset variables as errors
set -o xtrace   # Trace what gets executed (for debugging)

# Update package list
apt update

# Install timezone data non-interactively
DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends tzdata

# Define common dependencies
dependencies=(
    lsb-release         # Identify Ubuntu version
    curl                # Download tools (e.g. CMake)
    libssl-dev          # Required for building CMake
    python3.10-dev      # Python headers for Boost.Python
    python3-pip         # Install Conan and Python tools
    git                 # For downloading repositories
    make ninja-build    # CMake generators
    gcc-${GCC_VERSION}  # GCC compilers
    g++-${GCC_VERSION}  # GCC compilers
    cmake               # Build system
)

# Install dependencies
apt install --yes "${dependencies[@]}"

# Set up GCC versioning aliases
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-${GCC_VERSION} 100 \
  --slave /usr/bin/g++ g++ /usr/bin/g++-${GCC_VERSION}
update-alternatives --auto gcc

# Update cpp alternative separately
update-alternatives --install /usr/bin/cpp cpp /usr/bin/cpp-${GCC_VERSION} 100
update-alternatives --auto cpp

# Clean up package cache
apt clean

# Install Conan and configure
pip3 --no-cache-dir install conan==${CONAN_VERSION}
conan profile new default --detect
conan profile update settings.compiler.cppstd=20 default
conan config set general.revisions_enabled=1
conan profile update settings.compiler.libcxx=libstdc++11 default
conan profile update 'conf.tools.build:cxxflags+=["-DBOOST_BEAST_USE_STD_STRING_VIEW"]' default
conan profile update 'env.CXXFLAGS="-DBOOST_BEAST_USE_STD_STRING_VIEW"' default
