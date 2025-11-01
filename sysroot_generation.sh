#!/usr/bin/env bash
set -e
# === CONFIG ===
LIBIIO_VERSION="v0.24"
OUTPUT_DIR="$(pwd)/output_libiio_aarch64_sysroot"
IMAGE_NAME="libiio_aarch64_sysroot_builder"

mkdir -p "$OUTPUT_DIR"

# Create Dockerfile
cat > Dockerfile.libiio.aarch64 <<'EOF'
FROM debian:bullseye

# Install build dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git build-essential cmake pkg-config \
    flex bison \
    libaio-dev \
    linux-libc-dev netbase iproute2 iputils-ping \
    libpthread-stubs0-dev \
    libavahi-client-dev libavahi-common-dev \
    libusb-1.0-0-dev libxml2-dev libserialport-dev \
    linux-libc-dev netbase \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
ARG LIBIIO_VERSION

# Clone and build libiio
RUN git clone https://github.com/analogdevicesinc/libiio.git && \
    cd libiio && \
    git checkout ${LIBIIO_VERSION} && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local \
             -DBUILD_SHARED_LIBS=ON \
             -DENABLE_IPV6=ON \
             -DWITH_USB_BACKEND=ON \
             -DWITH_SERIAL_BACKEND=ON \
             -DWITH_NETWORK_BACKEND=ON \
             -DWITH_DNS_SD=ON \
             -DWITH_XML_BACKEND=ON \
             -DWITH_LOCAL_BACKEND=ON && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# Create entrypoint script to copy the entire sysroot
RUN cat > /copy_sysroot.sh <<'SCRIPT' && chmod +x /copy_sysroot.sh
#!/bin/bash
set -e
echo "Copying sysroot to /output..."

# Define sysroot directories to copy
SYSROOT_DIRS="/usr /lib /lib64 /etc"

for dir in $SYSROOT_DIRS; do
    if [ -d "$dir" ]; then
        echo "Copying $dir ..."
        cp -a "$dir" /output/
    fi
done

# List what was copied
echo ""
echo "Sysroot copied to /output:"
find /output -maxdepth 3 -type d
SCRIPT

ENTRYPOINT ["/copy_sysroot.sh"]
EOF

# Register QEMU for ARM64 emulation
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

# Build the Docker image for ARM64
docker buildx build --platform linux/arm64 \
    --build-arg LIBIIO_VERSION="$LIBIIO_VERSION" \
    -t $IMAGE_NAME -f Dockerfile.libiio.aarch64 .

# Run container, mounting host output folder
docker run --rm --platform linux/arm64 -v "$OUTPUT_DIR":/output $IMAGE_NAME

echo "✅ libiio $LIBIIO_VERSION aarch64 sysroot build complete!"
echo "Sysroot is in: $OUTPUT_DIR"
ls -la "$OUTPUT_DIR"

