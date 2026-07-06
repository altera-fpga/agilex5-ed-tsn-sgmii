# HPS with Multi-rate Ethernet PHY System Example Design for Agilex 5 Modular Development Kit

This design, which is based on the Agilex 5 SoC Golden Hardware Reference Design (GHRD), is part of the Golden System Reference Design (GSRD). It adds a new subsystem with a Multi-rate Ethernet PHY that covers all Hardware features specific to the TSN-SGMII XCVR.

## Description

This design demonstrates 3x2.5G ports connected to the HPS:

* Enables the data path between **HPS <-> XGMAC <-> MR PHY (Direct mode) <-> Marvell PHY** running at a 2.5G rate.
* Showcases dynamic reconfiguration, allowing runtime switching between Ethernet rates without system downtime.
  * **Port 0:** Demonstrates Precision Time Protocol (PTP) functionality (Supports 2.5G/1G).
  * **Port 1:** Configured as a non-PTP port with expanded multi-rate support (**Supports 2.5G/1G/100M/10M**).
  * **Port 2:** Configured for Small Form-factor Pluggable (SFP) operation with PTP enabled.  
    *Note: Port 2 (SFP) does not support dynamic reconfiguration.*
* Enables the **Deterministic Latency (DL)** feature of the MR PHY IP, which precisely determines the delay between the PCS elastic FIFO (EFIFO) and the PMA pins for TSN use cases. It also enables the CSR interface with the HPS Lightweight Bridge to convey these delays (Soft PCS, Hard PCS, and PMA delays) for both RX and TX directions.
* Utilizes a **GMII (8-bit) interface** for TSN-enabled Ethernet data transfers to and from the XGMAC to the external PHY. Transceiver reference clocks are used to derive the required frequency for running this parallel interface, ensuring a zero-ppm difference between these clocks.

### Block Diagram (Text Representation)

```text
+----------------------------------------------------------------------+
|                    Agilex 5 SoC System                               |
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
|   | Marvell PHY|       | Marvell PHY|         | SFP Cage  |          |
|   | Port 0     |       | Port 1     |         | Port 2    |          |
|   | 2.5G/1G    |       | 2.5G/1G/   |         | 2.5G      |          |
|   | PTP        |       | 100M/10M   |         | SFP+PTP   |          |
|   |            |       | Non-PTP    |         |           |          |
|   +------------+       +-------------+        +-----------+          |
|                                                                      |
+----------------------------------------------------------------------+

```

**Note:**  
- Ports 0 and 1 support dynamic reconfiguration between 2.5G and 1G rates.  
- Port 2 (SFP) does **not** support dynamic reconfiguration.

The system block diagram is shown below:

![Agilex™ 5 3xMulti-rate Ethernet PHY block diagram](https://github.com/intel-innersource/applications.fpga.system-example-designs.agilex5e-ed-tsn-config3/blob/main/images/SM_TSN.png)

## Repository Structure

- Directory Structure used in this example design
 ```bash
    |--- doc  
    |--- src
    |   |--- hw 
    |   |--- sw 
 ```

## Project Details 
- **Family**: Agilex 5
- **Quartus Version**: 26.1
- **Development Kit**: Agilex 5 FPGA E-Series 065B Modular Development Kit MK-A5E065BB32AEA
- **Device Part**:A5ED065BB32AE4S
- **Category**: HPS, Ethernet
- **Source**: GitHub
- **Design Support**: Simulation, Compile/Timing, Hardware
- **URL**: https://github.com/altera-fpga/agilex5-ed-tsn-sgmii
- **Design Package**: source_code.zip
  
## Getting Started
Follow the steps below to build the design
- [HW Build Readme](src/hw/a5e065bb32aea_mdk_3x2.5G/README.md)
- [SW Build Readme](src/sw/README.md)


