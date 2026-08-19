# APB Protocol Verification using SystemVerilog

This project implements a complete, class-based verification environment for an **APB (Advanced Peripheral Bus) slave** using **SystemVerilog**.

Unlike a simple directed testbench, the project uses a layered, object-oriented verification environment containing a **Generator, Bus Functional Model (BFM), Agent, Monitor, Scoreboard, Functional Coverage, Assertions, and Environment**. The components communicate through mailboxes and interact with the DUT through a virtual APB interface.

The project verifies both **read and write APB transactions**, including a DUT implementation with **2-cycle wait-state support**, constrained-random stimulus, protocol assertions, functional coverage, cross coverage, scoreboard-based checking, and an automated PASS/FAIL report.

## Overview

The project implements and verifies an APB slave with:

- IDLE, SETUP, and ACCESS FSM states
- Read and write transactions
- 2-cycle wait-state behavior before `PREADY` is asserted
- Parameterized address/data widths through compile-time macros
- Internal memory/register-array based storage
- Constrained-random transaction generation
- Mailbox-based communication between verification components
- Virtual-interface based driving and monitoring
- SystemVerilog Assertions (SVA)
- Functional coverage and cross coverage
- Self-checking scoreboard
- Automated PASS/FAIL reporting

### Verification Environment

The testbench demonstrates the following SystemVerilog verification concepts:

- Class-based verification architecture
- Object-oriented programming
- Constrained-randomization
- Mailboxes
- Virtual interfaces
- Functional coverage
- Cross coverage
- Illegal bins
- SystemVerilog Assertions
- Scoreboard-based data checking
- Automated testcase evaluation

## APB Protocol Overview

A typical APB-based SoC can be represented as:

```text
                    CPU / Processor
                           |
                          AHB
                           |
                  AHB-to-APB Bridge
                       APB Master
                           |
                    ===== APB BUS =====
                       /    |     \
                      /     |      \
                   UART     I2C     SPI
                 APB Slave APB Slave APB Slave
```

In this project:

- The **DUT is the APB slave**
- The **BFM acts as the active APB-side stimulus source**
- The DUT contains an internal memory array representing the slave storage space

## Design Details

### DUT: `apb_design.v`

The DUT implements an APB slave using a three-state FSM:

```text
        ┌──────┐
        │ IDLE │
        └──┬───┘
           │ PSEL = 1
           ▼
       ┌─────────┐
       │  SETUP  │
       └────┬────┘
            │ PENABLE = 1
            ▼
       ┌──────────┐
       │  ACCESS  │
       └────┬─────┘
            │
            │ 2 wait cycles
            ▼
         PREADY = 1
            │
            ▼
       Transfer Complete
```

### APB States

#### IDLE

The slave waits for a valid APB request.

```text
PSEL    = 0
PENABLE = 0
```

When `PSEL` is asserted, the FSM moves to `SETUP`.

#### SETUP

The slave is selected and the master presents the address/control information.

```text
PSEL    = 1
PENABLE = 0
```

When `PENABLE` is asserted, the FSM moves to `ACCESS`.

#### ACCESS

The transfer is completed after the programmed wait period.

The current DUT implementation introduces **2 wait cycles** before asserting `PREADY`.

```text
PREADY = 0
PREADY = 0
PREADY = 1
```

## Key DUT Signals

| Signal | Direction | Description |
|---|---|---|
| `PCLK` | Input | APB clock |
| `PRESET_N` | Input | Active-low reset |
| `PSEL` | Input | Selects the APB slave |
| `PENABLE` | Input | Identifies the APB Access phase |
| `PWRITE` | Input | `1` = Write, `0` = Read |
| `PADDR` | Input | Address |
| `PWDATA` | Input | Write data |
| `PREADY` | Output | Indicates transfer completion |
| `PRDATA` | Output | Read data |

### Internal Storage

The DUT contains an internal memory array:

```text
mem [`DEPTH-1:0]
```

The address and data widths are controlled through compile-time macros.

## Working Principle

### ✔ Reset Phase

When `PRESET_N = 0`:

- The internal memory is cleared
- The FSM returns to `IDLE`
- `PREADY` is cleared
- `PRDATA` is cleared
- The wait counter is reset

### ✔ Write Operation

A write transaction occurs when:

```text
PSEL    = 1
PENABLE = 1
PWRITE  = 1
```

After the two wait cycles, the DUT stores:

```text
mem[PADDR] = PWDATA
```

and asserts `PREADY`.

### ✔ Read Operation

A read transaction occurs when:

```text
PSEL    = 1
PENABLE = 1
PWRITE  = 0
```

After the two wait cycles, the DUT drives:

```text
PRDATA = mem[PADDR]
```

and asserts `PREADY`.

### ✔ Wait-State Logic

The DUT intentionally inserts two wait cycles in the ACCESS phase:

```text
PSEL       ───────────────────────
PENABLE    ───────────────────────
PREADY     ─────0────0────1───────
                    ↑    ↑
                  Wait Wait
                   1    2
```

This allows the verification environment to exercise APB transfers with slave-side latency.

# Testbench Architecture

The verification environment is built entirely using SystemVerilog classes.

```text
                     ┌──────────────┐
                     │   Generator  │
                     └──────┬───────┘
                            │
                         gen2bfm
                            │
                            ▼
                     ┌──────────────┐
                     │     BFM      │
                     └──────┬───────┘
                            │
                            ▼
                      APB Interface
                            │
                            ▼
                     ┌──────────────┐
                     │     DUT      │
                     └──────┬───────┘
                            │
                            ▼
                     ┌──────────────┐
                     │    Monitor   │
                     └──────┬───────┘
                            │
                   ┌────────┴─────────┐
                   │                  │
                mon2scb             mon2cov
                   │                  │
                   ▼                  ▼
            ┌────────────┐     ┌────────────┐
            │ Scoreboard │     │  Coverage  │
            └────────────┘     └────────────┘
```

## ✔ Transaction — `apb_tx.sv`

The transaction class models an APB transfer.

### Randomized fields

- `PWRITE`
- `PADDR`
- `PWDATA`

### Observed field

- `PRDATA`

The class also includes a `print()` function for transaction-level logging.

## ✔ Generator — `apb_gen.sv`

The Generator creates APB transactions and sends them to the BFM through the `gen2bfm` mailbox.

Supported testcase configurations include:

- `1W` — 1 write
- `5W` — 5 writes
- `NW` — N writes
- `1WRD` — 1 write followed by 1 read
- `5WRD` — 5 writes followed by 5 reads
- `NWRD` — N writes followed by N reads

For read/write testcases, the generated read transactions use the corresponding write addresses so that stored data can be checked by the scoreboard.

## ✔ BFM — `apb_bfm.sv`

The Bus Functional Model is responsible for driving APB transactions onto the interface.

Responsibilities include:

- Receiving transactions from the Generator
- Driving `PADDR`, `PWRITE`, `PWDATA`, `PSEL`, and `PENABLE`
- Performing the APB SETUP and ACCESS phases
- Waiting for `PREADY`
- Capturing `PRDATA` for read transactions
- Counting completed transactions through `bfm_count`

## ✔ Agent — `apb_agent.sv`

The Agent groups the major active and passive verification components:

- Generator
- BFM
- Monitor
- Coverage

The components are created and run together using concurrent processes.

## ✔ Monitor — `apb_mon.sv`

The Monitor passively observes the APB interface.

A transaction is captured when:

```text
PENABLE = 1
PREADY  = 1
```

The Monitor reconstructs the transaction and sends it to:

- Scoreboard through `mon2scb`
- Coverage collector through `mon2cov`

The Monitor does not drive the DUT.

## ✔ Scoreboard — `apb_scb.sv`

The Scoreboard maintains a reference memory model.

For a write:

```text
reference_mem[PADDR] = PWDATA
```

For a read:

```text
PRDATA == reference_mem[PADDR]
```

The scoreboard updates:

- `matching`
- `mismatching`

These counters are used by the top-level self-checking logic.

## ✔ Functional Coverage — `apb_cov.sv`

The coverage model contains two covergroups.

### Transaction Coverage — `cg_tx`

#### Address Coverage

`PADDR` is covered using:

```text
option.auto_bin_max = 4
```

#### Read/Write Coverage

Explicit bins are used for:

- `HIGH` → Write
- `LOW` → Read

#### Cross Coverage

The following cross is implemented:

```text
PADDR × PWRITE
```

This ensures address and read/write combinations are exercised.

### Interface Coverage — `cg_vif`

The interface covergroup samples:

- `PSEL`
- `PENABLE`

Both signals contain HIGH and LOW bins.

A cross is also created:

```text
PSEL × PENABLE
```

The following combination is declared illegal:

```text
PSEL = 0
PENABLE = 1
```

This checks that `PENABLE` is not asserted without an active slave select.

## ✔ SystemVerilog Assertions — `apb_assert.sv`

The project includes protocol-level SVA checks.

### `NO_ENABLE_WITHOUT_SEL`

Checks that `PENABLE` is not asserted when `PSEL` is low.

```text
!PSEL |-> !PENABLE
```

### `PREADY_SIGNALS_STABLE`

During an APB ACCESS phase while the slave is waiting:

```text
PSEL && PENABLE && !PREADY
```

the address is required to remain stable in the next cycle.

### `PENABLE_LOW_B4_SETUP`

After:

```text
PENABLE && PREADY
```

the next cycle must have:

```text
PENABLE = 0
```

This prevents the transaction from remaining stuck in ACCESS.

### `PRDATA_NO_UNKNOWN`

Checks that `PRDATA` does not contain unknown values during active simulation.

Assertion failures generate `$error` messages.

# Common Configuration — `apb_common.sv`

The common configuration contains the mailboxes connecting the verification components:

```text
gen2bfm
mon2cov
mon2scb
```

It also stores shared testcase information and statistics:

- `testname`
- `N`
- `bfm_count`
- `matching`
- `mismatching`

The current default configuration uses:

```text
testname = "NWRD"
N        = 8
```

# Self-Checking PASS/FAIL — `apb_top.sv`

The top-level testbench:

- Generates `PCLK`
- Generates reset
- Instantiates the APB interface
- Instantiates the DUT
- Instantiates and runs the verification environment
- Waits for the expected number of transactions
- Produces the final PASS/FAIL result

For read/write testcases, the result is based on:

```text
matching
mismatching
bfm_count
```

The testcase is considered successful when the expected read transactions match the scoreboard prediction and no mismatches are detected.

Example:

```text
TESTCASE PASSED!
Testname: NWRD | Matching: 8 | Mismatching: 0 | Count: 16
```

# Testcases

| Testcase | Description |
|---|---|
| `1W` | Single write transaction |
| `5W` | Five write transactions |
| `NW` | N write transactions |
| `1WRD` | One write followed by one read |
| `5WRD` | Five writes followed by five reads |
| `NWRD` | N writes followed by N reads |

# Functional Coverage Results

| Testcase | Covg - tx | Covg - vif | Overall |
|---|---:|---:|---:|
| `1W` | 29.16% | 100% | 64.58% |
| `5W` | 41.66% | 100% | 70.83% |
| `NW` | 66.66% | 100% | 83.33% |
| `1WRD` | 50.00% | 100% | 75.00% |
| `5WRD` | 66.66% | 100% | 53.33% |
| `NWRD` | 100% | 100% | 100% |

### Coverage Closure

The `NWRD` testcase achieves:

```text
Transaction Coverage : 100%
Interface Coverage   : 100%
Overall Coverage     : 100%
```

# File Structure

```text
.
├── apb_design.v      # APB slave DUT with 2-cycle wait-state support
├── apb_intf.sv       # APB interface
├── apb_tx.sv         # APB transaction class
├── apb_gen.sv        # Constrained-random generator
├── apb_bfm.sv        # Bus Functional Model
├── apb_mon.sv        # Passive monitor
├── apb_scb.sv        # Scoreboard
├── apb_cov.sv        # Functional and cross coverage
├── apb_assert.sv     # SystemVerilog Assertions
├── apb_agent.sv      # Agent
├── apb_env.sv        # Verification environment
├── apb_common.sv     # Mailboxes and shared configuration
├── apb_top.sv        # Top-level testbench
└── list.svh          # Macro definitions and source-file list
```

# Tools

- **Language:** SystemVerilog
- **Simulator:** QuestaSim / ModelSim
- **Protocol:** AMBA APB
- **Verification Approach:** Class-based SystemVerilog verification

# Waveform

![APB Protocol Waveform](https://github.com/monish-sr/apb_protocol/blob/3088448ee41de752a533c350b7391adac02fcd76/apb_protocol_waveform.png)


# Key Learning Outcomes

This project demonstrates practical implementation of:

- APB protocol transaction flow
- APB IDLE, SETUP, and ACCESS phases
- Slave wait-state modeling
- Class-based SystemVerilog verification
- Constrained-random stimulus generation
- Mailbox-based communication
- Virtual interfaces
- Passive monitoring
- Scoreboard-based checking
- Functional coverage
- Cross coverage and illegal bins
- SystemVerilog Assertions
- Self-checking PASS/FAIL reporting
- Coverage-driven verification
