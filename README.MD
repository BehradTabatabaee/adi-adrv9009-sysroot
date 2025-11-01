# ADRV9009 Sysroot

This repository contains a prebuilt **sysroot** for Analog Devices' **ADRV9009** RF transceiver platform.  
It is intended for cross-compiling user-space applications targeting embedded Linux systems running on platforms such as the **Zynq UltraScale+ MPSoC** or **Zynq UltraScale+ RFSoC** (e.g., ZCU102/ZCU111 with ADRV9009).

---

## 📦 Contents

The sysroot includes:
- Cross-compilation libraries and headers for the target ARM64 architecture  
- Prebuilt GNU toolchain compatible with the ADRV9009 Linux image  
- Standard C/C++ libraries and development files  
- ADI-related dependencies (libiio)

---

## 🧭 Usage

Clone the repository and run the sysroot generation script.
you can also find a pre-built zip file with all of the required binaries 
for adrv9009 development in the release section.
