# Agilex 5 System On Chip (SoC) FPGA Example Design with Multi-rate Ethernet PHY Intel® FPGA IP Core
This design is based on the Agilex 5 SoC Golden Hardware Reference Design (GHRD) which is part of the Golden System Reference Design (GSRD), adds a new subsystem with Multi-rate Ethernet Phy which covers all Hardware features specific to Config-3 TSN.

## Description
This design demonstrate 3x2.5G ports to HPS
- Enable the Data path between HPS <-> XGMAC <->MR PHY (Direct mode) <-> Marvell PHY running at 2.5G rate.
- This ED showcases 2.5G data rate.
- Enable the Deterministic Latency (DL) feature of MR PHY IP which precisely determines the delay between the PCS elastic FIFO (EFIFO) and the PMA pins for TSN usecases. Also enable the CSR interface with HPS Light weight bridge to convey these delays (Soft PCS, Hard PCS   and PMA delays) for both RX and TX directions.
- GMII (8-bit) interface for TSN enabled ethernet data transfers to and from XGMAC to external PHY. Tranceiever’s reference clocks are used to derive the required frequency for running this parallel interface as the expectation is to have zero ppm difference between these clocks.  

![Agilex™ 5 3xMulti-rate Ethernet PHY block diagram](https://github.com/altera-fpga/agilex5-ed-tsn-sgmii/blob/rel/25.1.1/images/SM_TSN.png)

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
- **Quartus Version**: 25.1.1
- **Development Kit**: Agilex 5 FPGA E-Series 065B Modular Development Kit MK-A5E065BB32AES1
- **Device Part**: A5ED065BB32AE6SR0
- **Category**: HPS, Ethernet
- **Source**: GitHub
- **Design Support**: Simulation, Compile/Timing, Hardware
- **URL**: https://github.com/altera-fpga/agilex5-ed-tsn-sgmii
- **Design Package**: source_code.zip
  
## Getting Started
Follow the steps below to build the design
- [HW Build Readme](src/hw/a5e065bb32aes1_mdk_3x2.5G/README.md)
- [SW Build Readme](src/sw/README.md)

