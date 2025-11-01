# ADRV9009 Sysroot

This repository contains a prebuilt **sysroot** for Analog Devices' **ADRV9009** RF transceiver platform.  
It is intended for cross-compiling user-space applications targeting embedded Linux systems running on platforms such as the **Zynq UltraScale+ MPSoC** or **Zynq UltraScale+ RFSoC** (e.g., ZCU102/ZCU111 with ADRV9009).
Tested on adi-ADRV9009 running on XCZU15EG-2FFVB1156I 

---

## 📦 Contents

The sysroot includes:
- Cross-compilation libraries and headers for the target ARM64 architecture  
- Prebuilt GNU toolchain compatible with the ADRV9009 Linux image  
- Standard C/C++ libraries and development files  
- ADI-related dependencies (libiio)

---

## 🧭 Usage

Use the pre-built zip file with all of the required binaries 
for adrv9009 development in the release section.
Download the file, and use it as the sysroot path for your cross-compilation script.

---

## 📝 Script

This script automates the process of building a cross-compilation sysroot for the `libiio` library (version v0.24) targeting the ARM64 architecture. It uses Docker with QEMU and `buildx` to create an ARM64 environment and then copies the sysroot to the host machine for further use in cross-compilation. it has been tested and the output has been verified to match exactly that of the one provided in release section, so it should work as expected. still, no guarantees. if you're unsure, just download the pre-built binaries.

### Prerequisites

Before using the script, ensure that you have the following installed on your system:

1. **Docker**: Docker is required to build the image and run the container.
   - Install Docker: [Get Docker](https://docs.docker.com/get-docker/)

2. **QEMU for ARM64 emulation**: The script will automatically register QEMU for ARM64 emulation. This allows you to build ARM64 binaries on a non-ARM machine.
   - Docker's `multiarch/qemu-user-static` will be used to enable this.

3. **Docker Buildx Plugin**: Docker's `buildx` is used for building the ARM64 image. Ensure your Docker installation supports it.
   - For more information, refer to [Buildx installation](https://docs.docker.com/buildx/working-with-buildx/).

4. **Permissions**: You may need elevated permissions (e.g., `sudo`) to run Docker commands, depending on your system setup.

## Script Overview

The script performs the following steps:

1. **Creates a Dockerfile** that defines the environment for building `libiio` on ARM64.
2. **Registers QEMU** for ARM64 emulation using the `multiarch/qemu-user-static` Docker image.
3. **Builds the Docker image** for ARM64 using `docker buildx` with the appropriate `libiio` version.
4. **Runs the container**, mounts the output directory, and copies the sysroot to the host machine.
5. **Outputs the sysroot** into a directory that can be used for cross-compilation.

## How to Use the Script

### 1. Download the Script

Clone or download the repository containing the script. Save it as a `.sh` file, for example, `build_libiio.sh`.

### 2. Make the Script Executable

In your terminal, navigate to the directory containing the script and run:

```bash
chmod +x build_libiio.sh
````

### 3. Run the Script

Once the script is executable, you can run it with the following command:

```bash
./build_libiio.sh
```

This will trigger the following actions:

* Set up an output directory (`output_libiio_aarch64_sysroot` by default).
* Create a Dockerfile to build `libiio` for ARM64.
* Register QEMU for ARM64 emulation (if it's not already registered).
* Build the ARM64 Docker image.
* Run the container, mount the output directory, and copy the ARM64 sysroot to your host machine.

### 4. Customization

* **libiio version**: To change the version of `libiio` that is built, modify the `LIBIIO_VERSION` variable at the top of the script. The default version is `v0.24`.

* **Output directory**: The directory where the sysroot will be saved can be changed by modifying the `OUTPUT_DIR` variable. The default is `output_libiio_aarch64_sysroot` in the current working directory.

### 5. Completion

When the script finishes, you should see the following message:

```bash
✅ libiio v0.24 aarch64 sysroot build complete!
Sysroot is in: /path/to/your/output_libiio_aarch64_sysroot
```

### 6. Check the Output

Once the script completes, you can list the contents of the output directory to verify the sysroot:

```bash
ls -la /path/to/your/output_libiio_aarch64_sysroot
```

You should see the necessary libraries and headers from the `libiio` build, ready for cross-compilation for ARM64 platforms.

### Troubleshooting

### QEMU Setup

If QEMU doesn't register properly, ensure that Docker is configured to handle multi-platform builds. You can check Docker's logs for errors related to the `multiarch/qemu-user-static` image.

### Build Failures

If the Docker build fails, the error messages will be displayed in the terminal. Look for issues like missing dependencies or problems with the `libiio` version you're trying to build. Check the error logs for more information and resolve any issues.
