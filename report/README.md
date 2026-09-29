# FPGA-Based Real-Time Signal Processing and Fault Detection

## Project Overview

This project presents the design and FPGA implementation of a **real-time digital signal-processing architecture for electrical fault detection**.

The system was developed from a **MATLAB/Simulink reference model**, converted into synthesizable **VHDL using HDL Coder**, and implemented on an **AMD/Xilinx Artix-7 XC7A100T FPGA** using AMD Vivado.

The main objective was to transform an electrical signal into a reliable detection decision through a **deterministic, fixed-point FPGA datapath**.

### Processing Architecture

```text
Input
  ↓
FIR Filtering
  ↓
Difference Computation
  ↓
Absolute Value
  ↓
Gain
  ↓
Threshold Comparison
  ↓
Event Validation
  ↓
Detect
```

The processing architecture operates at a **40 MHz processing clock (25 ns period)** using signed **16-bit fixed-point arithmetic (`fixdt(1,16,12)`)**.

---

# Implementation Results

The design was taken through RTL simulation, synthesis and FPGA implementation, with timing, resource and power characteristics evaluated in Vivado.

### Key Results

| Metric                     |             Result |
| -------------------------- | -----------------: |
| FPGA                       |   Artix-7 XC7A100T |
| Processing Clock           |             40 MHz |
| Processing Period          |              25 ns |
| Worst Negative Slack (WNS) |      **+0.093 ns** |
| LUT Utilization            |          **1.17%** |
| Estimated Power            |        **0.208 W** |
| Arithmetic                 | 16-bit Fixed-Point |
| HDL                        |               VHDL |

The positive WNS indicates that the implemented design satisfies the analyzed timing requirement, while the low LUT utilization demonstrates that the implemented processing pipeline occupies only a small portion of the target FPGA resources.

The project therefore demonstrates not only algorithmic functionality, but also a complete transition from **model-based signal processing to a timing-validated FPGA implementation**.

---

# Development Flow

```text
MATLAB / Simulink
        ↓
Fixed-Point Model
        ↓
HDL Coder
        ↓
Generated VHDL
        ↓
Vivado RTL Simulation
        ↓
Synthesis
        ↓
Implementation
        ↓
Timing / Resource / Power Analysis
        ↓
FPGA Hardware Architecture
```

This workflow provides a traceable path between the original algorithm and its hardware implementation.

---

# Why This Architecture Is Transferable

Although the demonstrated application is **cable-harness fault detection**, the underlying architecture is more general.

The core idea is:

> **Acquire an electrical signal → process it deterministically in hardware → extract signal variations → detect abnormal events → generate a real-time decision.**

This type of hardware pipeline can be adapted to other systems where electrical measurements must be processed with predictable latency.

The cable-harness application therefore serves as a practical demonstration of a broader **FPGA-based real-time signal-processing and event-detection architecture**.

---

# Potential Applications in Energy and Power Systems

The same architecture can potentially be adapted to electrical-energy applications in which voltage or current measurements need to be processed in real time.

Possible directions include:

* electrical fault and event detection
* transient detection
* voltage/current anomaly monitoring
* power-quality event detection
* microgrid monitoring and protection
* renewable-energy system monitoring
* energy-storage system monitoring

A possible implementation would follow the same general structure:

```text
Voltage / Current Measurement
            ↓
           ADC
            ↓
      FPGA Signal Processing
            ↓
    Filtering / Feature Extraction
            ↓
      Fault / Event Detection
            ↓
        Decision Output
```

The specific detection and feature-extraction algorithms would need to be adapted to the electrical system under investigation.

---

# Potential Applications in Power Electronics and Real-Time Systems

The architecture is also transferable to **power-electronic converters and real-time hardware systems**, where fast processing of electrical measurements can support monitoring, protection or control.

Potential applications include:

* converter fault detection
* overcurrent / overvoltage event detection
* DC-link monitoring
* inverter monitoring
* motor-drive monitoring
* converter protection
* real-time Hardware-in-the-Loop monitoring

A possible extension is:

```text
Power Converter
      ↓
Voltage / Current Measurement
      ↓
ADC
      ↓
FPGA
      ↓
Digital Signal Processing
      ↓
Event / Fault Detection
      ↓
Protection or Control Interface
```

For real-time and HIL applications, the FPGA processing stage could also operate as a deterministic hardware component connected to a real-time electrical-system model.

---

# Technical Characteristics

### FPGA

* AMD/Xilinx Artix-7
* XC7A100T
* VHDL implementation
* Vivado synthesis and implementation

### Signal Processing

* MATLAB/Simulink reference model
* Fixed-point arithmetic
* FIR filtering
* Difference computation
* Absolute-value processing
* Gain stage
* Threshold comparison
* Consecutive-event validation

### Real-Time Design

* 100 MHz system clock
* 40 MHz processing clock
* 25 ns processing period
* Deterministic processing pipeline
* RTL functional verification
* Timing analysis
* Resource utilization analysis
* Power estimation

---

# Research Extension

The implemented design establishes a hardware foundation that can be extended from the demonstrated fault-detection application toward:

**FPGA → Real-Time DSP → Electrical Monitoring → Fault/Event Detection → Protection or Control**

The next step would be to adapt the existing signal-processing and decision architecture to measurements generated by **power converters, energy systems, microgrids, renewable-energy interfaces or other electrical platforms**, while preserving the same emphasis on deterministic FPGA execution and implementation-level validation.

---

## Keywords

`FPGA` `VHDL` `MATLAB` `Simulink` `HDL Coder` `Vivado` `Fixed-Point DSP` `Real-Time Processing` `Fault Detection` `Signal Processing` `Power Electronics` `Energy Systems` `Power Converters` `Microgrids` `HIL` `Embedded Systems`

