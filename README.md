# APB Protocol Verification using SystemVerilog

## Overview

This project presents a class-based APB (Advanced Peripheral Bus) slave verification environment developed using SystemVerilog. The testbench verifies APB read and write transactions by generating constrained-random stimulus, monitoring DUT responses, and validating data integrity and protocol compliance.

The verification environment uses a layered, object-oriented architecture with a Generator, Bus Functional Model (BFM), Agent, Monitor, Scoreboard, Functional Coverage, SystemVerilog Assertions (SVA), and Environment. It supports APB transfers with two wait cycles in the ACCESS phase, mailbox-based communication between verification components, and automated PASS/FAIL reporting.

---

## Key Features

- Class-based SystemVerilog verification environment for an APB slave
- Support for APB read and write transactions
- Three-state APB slave FSM: IDLE, SETUP, and ACCESS
- Two-cycle wait-state support before asserting PREADY
- Constrained-random transaction generation with configurable testcase execution
- Mailbox-based communication between Generator, BFM, Monitor, Scoreboard, and Coverage
- Virtual-interface-based stimulus driving and passive monitoring
- Self-checking scoreboard with reference memory and matching/mismatching counters
- Functional coverage for transaction addresses and read/write operations
- Cross coverage for PADDR × PWRITE and PSEL × PENABLE
- Illegal-bin coverage to identify invalid APB interface signal combinations
- SystemVerilog Assertions (SVA) for protocol compliance and signal stability checks
- Automated PASS/FAIL reporting based on transaction counts and scoreboard results

---

## Testbench Architecture

The verification environment follows a layered, class-based architecture with separate components for stimulus generation, bus driving, monitoring, checking, and coverage collection:

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

The Generator creates transactions and sends them to the BFM through a mailbox. The BFM drives the APB interface and communicates with the DUT. The Monitor observes completed transfers and distributes transaction information to the Scoreboard and Coverage collector through separate mailboxes.

The Scoreboard maintains a reference memory model to check read data, while functional coverage measures exercised transaction and interface scenarios. Assertions check protocol rules, and the top-level testbench evaluates the results to produce an automated PASS/FAIL report.

---

## Verification Scope

The verification environment validates:

- APB read and write transactions
- Correct IDLE, SETUP, and ACCESS phase transitions
- Two-cycle wait-state behavior before PREADY assertion
- Correct address and write-data handling
- Write operations to the DUT's internal memory array
- Read-data integrity using scoreboard-based reference checking
- Address and read/write transaction coverage
- APB interface signal combinations using cross coverage and illegal bins
- Protocol rules through assertion-based verification
- Address stability during ACCESS wait states
- Valid PSEL and PENABLE relationships
- Automated testcase evaluation using transaction counts and scoreboard results

---

## Tools and Technologies I used

- Language: SystemVerilog
- Verification Approach: Class-based, object-oriented verification
- Assertions: SystemVerilog Assertions (SVA)
- Functional Verification: Functional and cross coverage
- Communication: SystemVerilog mailboxes
- Interface Access: Virtual interfaces
- Simulator: QuestaSim / ModelSim
- Protocol: AMBA APB
- Reporting: Automated PASS/FAIL evaluation

---

## Results

- Achieved **100% transaction coverage, 100% interface coverage, and 100% overall coverage** for the NWRD testcase.
- Verified APB read and write transactions with two-cycle slave wait-state support.
- Implemented scoreboard-based data integrity checking using a reference memory model.
- Added assertion-based checks for APB protocol rules, signal stability, and read-data validity.
- Evaluated multiple testcases, including single writes, multiple writes, and write-followed-by-read scenarios.
- Successfully implemented automated PASS/FAIL reporting using transaction counts and matching/mismatching statistics.

