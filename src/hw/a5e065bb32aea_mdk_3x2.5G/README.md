# Agilex 5 TSN Config3 System Reference Design

This directory contains the Quartus Project for the Agilex 5 TSN System Design with Multirate Ethernet Phy IP 3x2.5G ports.

---

## New Features

- **Dynamic Reconfiguration:**  
  The design now supports dynamic reconfiguration, allowing you to switch seamlessly between various Ethernet rates without system downtime.

- **Multi-Rate Operation:**  
  Supports flexible line rates (up to 2.5G/1G, and down to 100M/10M where applicable) with runtime dynamic switching.

- **TSN+PTP and Non-TSN+PTP Support:**  
  The design operates in both TSN+PTP (Time-Sensitive Networking with Precision Time Protocol) and non-TSN+PTP scenarios, providing flexibility for a wide range of applications.

  - **Port 0:** Demonstrates Precision Time Protocol (PTP) functionality (Supports 2.5G/1G).
  - **Port 1:** Configured as a non-PTP port with expanded multi-rate support (**Supports 2.5G/1G/100M/10M**).
  - **Port 2:** Configured for Small Form-factor Pluggable (SFP) operation with PTP enabled.  
    *Note: Port 2 (SFP) does not support dynamic reconfiguration.*

  ## Block Diagram (Text Representation)

```text
+----------------------------------------------------------------------+
|                     Agilex 5 SoC System                              |
|                                                                      |
|   +----------------------------------------------------+             |
|   |                        HPS                         |             |
|   +----------------------------------------------------+             |
|            |                      |                |                 |
|            |                      |                |                 |
|   +------------------+  +------------------+  +------------------+   |
|   |   MR PHY 0       |  |   MR PHY 1       |  |   MR PHY 2       |   |
|   |   (PTP)          |  |   (Non-PTP)      |  |   (SFP + PTP)    |   |
|   +------------------+  +------------------+  +------------------+   |
|         |                    |                     |                 |
|   +-----------+        +------------+         +-----------+          |
|   | Marvell PHY|        | Marvell PHY|        | SFP Cage  |          |
|   | Port 0     |        | Port 1     |        | Port 2    |          |
|   | 2.5G/1G    |        | 2.5G/1G/   |        | 2.5G      |          |
|   | PTP        |        | 100M/10M   |        | SFP+PTP   |          |
|   |            |        | Non-PTP    |        |           |          |
|   +------------+        +-------------+       +-----------+          |
|                                                                      |
+----------------------------------------------------------------------+

```

## Dependency

- Quartus® Prime 26.1
- Supported Board:
  - [Agilex™ 5 FPGA E-Series 065B Modular Development Kit](https://www.intel.com/content/www/us/en/products/details/fpga/development-kits/agilex/a5e065b-modular.html)

---

## Build Steps

1. Compile design and generate configuration file:

    
```bash
    quartus_sh --flow compile top.qpf -c top
    ```

## Programming Files Generation Steps

1. Get your boot loader .hex file
2. Generate binary file including boot loader files using following commands:

    
```bash
    quartus_pfg -c -o hps_path=../../sw/artifacts/u-boot-spl-dtb.hex ./output_files/top.sof ./output_files/top.sof
    quartus_pfg -c -o hps=on ./output_files/top.sof ./output_files/top.rbf
    ```

---

**Note:**  
This reference design supports dynamic reconfiguration and runtime rate switching. Port 1 features comprehensive multi-rate capabilities supporting 2.5G, 1G, 100M, and 10M links. It is compatible with both TSN+PTP and non-TSN+PTP operating modes for maximum flexibility.
