# Agilex 5 System On Chip (SoC) FPGA Example Design with Multi-rate Ethernet PHY Intel® FPGA IP Core
This design is based on the Agilex 5 SoC Golden Hardware Reference Design (GHRD) which is part of the Golden System Reference Design (GSRD), adds a new subsystem with Multi-rate Ethernet Phy which covers all Hardware features specific to Config-3 TSN.

## Description
This design is based on base GHRD with the following feature additions: 
- Enable the Data path between HPS <-> XGMAC <->MR PHY (Direct mode) <-> Marvell PHY running at 2.5G rate.
- This ED showcases 2.5G data rate.
- Enable the Deterministic Latency (DL) feature of MR PHY IP which precisely determines the delay between the PCS elastic FIFO (EFIFO) and the PMA pins for TSN usecases. Also enable the CSR interface with HPS Light weight bridge to convey these delays (Soft PCS, Hard PCS   and PMA delays) for both RX and TX directions.
- GMII (8-bit) interface for TSN enabled ethernet data transfers to and from XGMAC to external PHY. Tranceiever’s reference clocks are used to derive the required frequency for running this parallel interface as the expectation is to have zero ppm difference between these clocks.  

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
- **Quartus Version**: 24.3.0 Pro Edition
- **Development Kit**: Agilex 5 FPGA E-Series 065B Premium Development Kit DK-A5E065BB32AES1
- **Device Part**: A5ED065BB32AE6SR0

## Getting Started
Follow the steps below to build the design
- [HW Build Readme](src/hw/README.md)
- [SW Build Readme](src/sw/README.md)
