# FPGA-Based Real-Time Cable Harness Test Bench

Real-time FPGA-based cable harness testing and fault-detection system using fixed-point digital signal processing, MATLAB/Simulink modeling, VHDL and AMD/Xilinx Vivado.

## Project Overview

This project focuses on the design and FPGA implementation of a real-time cable harness signal-processing and fault-detection system for industrial embedded systems.

The development flow combines:

* MATLAB/Simulink reference modeling
* Fixed-point digital signal processing
* HDL Coder
* VHDL
* RTL simulation
* FPGA synthesis and implementation
* Timing analysis
* Resource utilization analysis
* Power estimation

The target FPGA is an **AMD/Xilinx Artix-7 XC7A100T**.

---

## System Architecture

The proposed system is designed to monitor individual wires of a multi-wire cable harness through a switching/MUX stage.

```text
DC / Excitation Source
        │
        ▼
   Cable Harness
  ┌────┬────┬────┐
  │ W1 │ W2 │ W3 │ ... WN
  └────┴────┴────┘
        │
        ▼
 Switching / MUX
   Matrix
        │
        ▼
Signal Conditioning
        │
        ▼
    16-bit ADC
     1 MSPS
        │
        ▼
      FPGA
        │
        ▼
  Real-Time DSP
        │
        ▼
      Detect
        │
        ▼
 Fault / Event
  Monitoring
```

The MUX selects the wire to be tested. The selected signal is then conditioned and digitized before being processed by the FPGA.

> The analog front-end and multi-wire switching architecture represent the proposed system-level realization. The current FPGA implementation focuses on the digital signal-processing and detection subsystem.

---

## Digital Signal-Processing Architecture

The FPGA processing chain is based on the following architecture:

```text
In1[15:0]
    │
    ▼
 FIR Filter
    │
    ▼
 Difference
    │
    ▼
Absolute Value
    │
    ▼
 Gain × 50
    │
    ▼
Threshold > 9.5
    │
    ▼
Event Validation
    │
    ▼
 Detect
```

The FPGA has one externally observable functional output:

```text
Out3 = Detect
```

---

## MATLAB/Simulink Reference Model

MATLAB/Simulink is used as the reference environment for algorithm development and verification.

The model is used to:

* Generate test signals
* Model fault scenarios
* Develop the signal-processing algorithm
* Verify fixed-point behavior
* Establish expected detection behavior
* Provide a reference for the FPGA implementation

The reference processing chain is:

```text
Input
  ↓
FIR
  ↓
Difference
  ↓
Absolute Value
  ↓
Gain × 50
  ↓
Threshold > 9.5
  ↓
Event Validation
  ↓
Detect
```

### Fixed-Point Representation

The main processing signal uses:

```text
fixdt(1,16,12)
```

This corresponds to a signed 16-bit representation with 12 fractional bits.

The scaling factor is:

```text
2^12 = 4096
```

Therefore:

```text
Real Value = Fixed-Point Value / 4096
```

The detection criterion is:

```text
|diff| × 50 > 9.5
```

or equivalently:

```text
|diff| > 0.19
```

The event-validation stage is designed around two consecutive qualifying samples.

---

## FPGA Implementation

The implementation flow is:

```text
MATLAB / Simulink
        │
        ▼
     HDL Coder
        │
        ▼
       VHDL
        │
        ▼
 Vivado RTL Simulation
        │
        ▼
 Synthesis & Implementation
        │
        ▼
    Artix-7 FPGA
```

### Target Device

| Parameter   | Value              |
| ----------- | ------------------ |
| FPGA        | AMD/Xilinx Artix-7 |
| Device      | XC7A100T           |
| Package     | CSG324             |
| Speed Grade | -1                 |
| HDL         | VHDL               |

### Clock Configuration

| Clock              | Frequency |
| ------------------ | --------: |
| System/Input Clock |   100 MHz |
| Processing Clock   |    40 MHz |
| Processing Period  |     25 ns |

The processing clock is generated using the FPGA clock-management resources.

---

## RTL Functional Verification

The generated VHDL design is verified using Vivado RTL simulation.

The main observable signals are:

```text
In1[15:0]
clk
reset
clk_enable
ce_out
Out3
```

The verification focuses on the externally observable behavior:

```text
Input → Detect
```

### Demonstrated Behavior

The RTL simulation demonstrates:

* Stable input conditions with `Detect = 0`
* Detection of the demonstrated fault-like signal excursion
* Repeatable detection behavior for similar events
* Return of `Detect` to its inactive state
* No detection pulse during reset
* No permanent/stuck-high detection in the tested sequences

A demonstrated large signed transition is:

```text
7FFF → 8000
```

With the selected fixed-point representation, this corresponds to a large negative excursion.

### Verification Status

| Test / Behavior              | Status                |
| ---------------------------- | --------------------- |
| Stable/normal behavior       | Demonstrated          |
| Demonstrated fault detection | Demonstrated          |
| Reset behavior               | Demonstrated          |
| Repeatability                | Demonstrated          |
| Exact two-sample validation  | Not directly proven   |
| Noise/transient rejection    | Not fully verified    |
| Single-sample rejection      | Not directly verified |
| Exact cycle-level latency    | Approximate           |

---

## FPGA Implementation Results

### Timing

| Metric             |        Result |
| ------------------ | ------------: |
| Processing Clock   |        40 MHz |
| Clock Period       |         25 ns |
| WNS                | **+0.093 ns** |
| TNS                |      **0 ns** |
| WHS                | **+0.043 ns** |
| THS                |      **0 ns** |
| Failing Endpoints  |         **0** |
| Timing Constraints |       **Met** |

The implemented design satisfies the specified 40 MHz timing requirement.

An equivalent estimated maximum frequency is approximately:

```text
40.15 MHz
```

This is an estimated equivalent Fmax derived from the reported timing margin.

---

## Resource Utilization

| Resource   |  Used | Available | Utilization |
| ---------- | ----: | --------: | ----------: |
| LUT        |   744 |    63,400 |   **1.17%** |
| Flip-Flops | 1,039 |   126,800 |   **0.82%** |
| DSP48      |     2 |       240 |   **0.83%** |
| I/O        |    20 |       210 |   **9.52%** |
| MMCM       |     1 |         6 |  **16.67%** |

The implementation uses a small fraction of the available FPGA logic resources.

---

## Power Estimation

Vivado power analysis reports:

| Metric               |      Result |
| -------------------- | ----------: |
| Total Power          | **0.208 W** |
| Dynamic Power        | **0.110 W** |
| Static Power         | **0.097 W** |
| Junction Temperature | **25.9 °C** |

These values correspond to the current implemented design and Vivado power-analysis configuration.

---

## Design Rule Check

| DRC Result        | Count |
| ----------------- | ----: |
| Errors            | **0** |
| Critical Warnings | **0** |
| Warnings          | **6** |

The reported warnings concern DSP pipelining recommendations and do not correspond to timing or functional failures.

They can be considered optimization opportunities for future higher-frequency or more computationally demanding implementations.

---

## Current Limitations

The current project primarily validates the digital FPGA processing subsystem.

The following elements remain system-level or future-development work:

* Physical cable-harness test bench
* ADC hardware integration
* MUX/switching hardware
* Analog signal-conditioning hardware
* Automatic multi-wire channel selection
* Physical fault injection
* Hardware validation with a real cable harness
* More exhaustive fault-rejection testing
* Hardware timestamping

The current FPGA implementation does **not** include a timestamp output.

---

## Future Work

Future development can extend the project toward an industrial monitoring platform including:

* Physical ADC integration
* Multi-wire switching control
* Embedded monitoring
* Edge AI
* Industrial IoT
* Digital Twin
* Real-time telemetry
* Automated fault classification

A self-checking HDL testbench can also be added to automatically compare the FPGA `Detect` output against expected detection sequences generated from the MATLAB/Simulink reference model.

---

## Repository Structure

```text
fpga-cable-harness-testbench/
│
├── README.md
│
├── docs/
│   ├── architecture/
│   ├── simulink/
│   └── vivado/
│
├── simulink/
│
├── hdl/
│   ├── generated/
│   └── testbench/
│
├── vivado/
│   ├── project/
│   └── reports/
│
└── verification/
    ├── test_vectors/
    └── results/
```

---

## Technologies

* **FPGA:** AMD/Xilinx Artix-7
* **HDL:** VHDL
* **MATLAB/Simulink**
* **HDL Coder**
* **AMD/Xilinx Vivado**
* **Fixed-Point DSP**
* **RTL Simulation**
* **Digital Signal Processing**
* **Embedded Systems**
* **Industrial Fault Detection**

---

## Project Status

**FPGA digital processing and implementation:** Completed

**RTL simulation:** Completed for the demonstrated test cases

**Synthesis and implementation:** Completed

**Timing analysis:** Completed

**Resource utilization analysis:** Completed

**Power estimation:** Completed

**Physical cable-harness test bench:** Future work
