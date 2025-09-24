#!/usr/bin/env bash

# Build GCC 14.2.0 with C/C++ JSON support
[[ -d "bin" ]] && exit 0
PREFIX=$(realpath $(dirname $0))

mkdir -p build obj

cd build

# Try faster mirrors for GCC download
echo "Downloading GCC 14.2.0 (trying fastest mirror)..."
if command -v wget >/dev/null 2>&1; then
    # Use wget with continue and multiple mirrors
    wget --continue --tries=3 --timeout=30 -O gcc.tar.gz "https://mirrors.kernel.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz" || \
    wget --continue --tries=3 --timeout=30 -O gcc.tar.gz "https://mirror.checkdomain.de/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz" || \
    wget --continue --tries=3 --timeout=30 -O gcc.tar.gz "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz"
else
    # Fallback to curl with resume support
    curl -L --retry 3 --retry-delay 5 -C - -o gcc.tar.gz "https://mirrors.kernel.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz" || \
    curl -L --retry 3 --retry-delay 5 -C - -o gcc.tar.gz "https://mirror.checkdomain.de/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz" || \
    curl -L --retry 3 --retry-delay 5 -C - -o gcc.tar.gz "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.gz"
fi

tar xzf gcc.tar.gz --strip-components=1

./contrib/download_prerequisites

cd ../obj

# Configure with optimizations for JSON libraries
../build/configure --prefix "$PREFIX" --enable-languages=c,c++,d,fortran --disable-multilib --disable-bootstrap

make -j$(nproc)
make install -j$(nproc)
cd ../
rm -rf build obj
