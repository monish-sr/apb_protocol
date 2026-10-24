# APB Protocol Verification using SystemVerilog

## Overview

This project implements a class-based verification environment for an APB (Advanced Peripheral Bus) slave using SystemVerilog. The testbench verifies APB read and write operations by generating random transactions, monitoring DUT responses, and checking data correctness and protocol behaviour.

The verification environment consists of a Generator, Bus Functional Model (BFM), Agent, Monitor, Scoreboard, Functional Coverage, SystemVerilog Assertions (SVA), and Environment. It also supports two wait cycles during the ACCESS phase, mailbox-based communication between components, and automatic PASS/FAIL reporting.

---

## Key Features

- Class-based SystemVerilog verification environment for an APB slave
- Support for APB read and write operations
- Three-state FSM: IDLE, SETUP, and ACCESS
- Two wait cycles before asserting PREADY
- Constrained-random transaction generation
- Mailbox-based communication between verification components
- Virtual interface for driving and monitoring APB signals
- Monitor to capture completed transactions
- Scoreboard with reference memory to check read data
- Functional coverage for addresses and read/write operations
- Cross coverage for PADDR × PWRITE and PSEL × PENABLE
- Illegal bins to identify invalid APB signal combinations
- SystemVerilog Assertions to check protocol rules and signal stability
- Automated PASS/FAIL reporting based on scoreboard results and transaction counts

---

## Verification Architecture

The verification environment follows a class-based architecture with separate components for generating, driving, monitoring, and checking APB transactions.

- APB Interface
- Generator
- Bus Functional Model (BFM)
- Agent
- Monitor
- Scoreboard
- Functional Coverage
- SystemVerilog Assertions
- Environment
- Top-Level Testbench

The Generator creates APB transactions and sends them to the BFM through a mailbox. The BFM drives the APB signals and communicates with the DUT.

The Monitor observes completed transactions and sends the transaction details to the Scoreboard and Coverage collector. The Scoreboard checks read data using a reference memory model, while functional coverage tracks the scenarios exercised during simulation. Assertions check protocol rules, and the top-level testbench generates the final PASS/FAIL result.

---

## Verification Scope

The verification environment checks:

- APB read and write operations
- Correct transitions between IDLE, SETUP, and ACCESS states
- Two wait cycles before PREADY is asserted
- Correct address and write-data handling
- Write operations to the DUT's internal memory
- Read-data correctness using the scoreboard
- Address and read/write operation coverage
- APB signal combinations using cross coverage and illegal bins
- Protocol rules using SystemVerilog Assertions
- Address stability during ACCESS wait cycles
- Correct relationship between PSEL and PENABLE
- Automatic testcase evaluation using transaction counts and scoreboard results

---

## Tools and Technologies

- Language: SystemVerilog
- Verification Method: Class-based verification
- Assertions: SystemVerilog Assertions (SVA)
- Coverage: Functional coverage and cross coverage
- Communication: SystemVerilog mailboxes
- Interface Access: Virtual interfaces
- Simulator: QuestaSim / ModelSim
- Protocol: AMBA APB
- Reporting: Automatic PASS/FAIL checking

---

## Results

- Achieved 100% transaction coverage, 100% interface coverage, and 100% overall coverage for the NWRD testcase.
- Verified APB read and write operations with two wait cycles in the ACCESS phase.
- Checked read-data correctness using a scoreboard and reference memory.
- Implemented assertions to check APB protocol rules and signal stability.
- Tested multiple scenarios, including single writes, multiple writes, and write-followed-by-read operations.
- Implemented automatic PASS/FAIL reporting using transaction counts and matching/mismatching results.

