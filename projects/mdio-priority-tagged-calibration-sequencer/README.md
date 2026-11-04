# MDIO Priority-Tagged Calibration Sequencer

## Submission outcome

- **Category:** vlsi
- **Verdict:** AC
- **Score:** 100
- **Evidence:** Native verified

## Full task specification

### Acceptance Criteria

1. Observed behavior must satisfy B1: High-priority requests (req_prio=1) must be serviced before any pending low-priority requests.
2. Observed behavior must satisfy B2: mdio_start must remain high for exactly one cycle when mdio_done is low and stall_in is low.
3. Observed behavior must satisfy B3: If stall_in is high when a transaction completes (mdio_done=1), the sequencer must hold the current mdio_addr/wdata and not accept new requests.

### Architecture

The design consists of a 2-slot priority buffer, an MDIO transaction FSM, and a stall-aware output register. High-priority requests bypass the buffer if the FSM is IDLE.

### Arithmetic Models


### Behavior Rules

- **B1**
  - **Rule:** High-priority requests (req_prio=1) must be serviced before any pending low-priority requests.

  - **Type:** priority

- **B2**
  - **Rule:** mdio_start must remain high for exactly one cycle when mdio_done is low and stall_in is low.

  - **Type:** protocol

- **B3**
  - **Rule:** If stall_in is high when a transaction completes (mdio_done=1), the sequencer must hold the current mdio_addr/wdata and not accept new requests.

  - **Type:** stall


### Behavior Tables

- **Item 1**
  - **Columns:**
    1. State
    2. req_valid
    3. req_prio
    4. stall_in
    5. mdio_done
    6. Next State
    7. req_ready


  - **Rows:**
    - **Item 1:**
      1. IDLE
      2. 1
      3. 0
      4. 0
      5. X
      6. BUSY
      7. 1

    - **Item 2:**
      1. IDLE
      2. 1
      3. 1
      4. 0
      5. X
      6. BUSY
      7. 1

    - **Item 3:**
      1. BUSY
      2. X
      3. X
      4. 0
      5. 1
      6. IDLE
      7. 0

    - **Item 4:**
      1. BUSY
      2. X
      3. X
      4. 1
      5. 1
      6. STALLED
      7. 0

    - **Item 5:**
      1. STALLED
      2. X
      3. X
      4. 0
      5. X
      6. IDLE
      7. 0



  - **Title:** Priority and Stall Resolution


### Category

rtl_design

### Clock

- **Edge:** posedge
- **Signal:** clk

### Contract Compiler Version

canonical-contract-v1

### Contract Hash

1nxemm6

### Control Fsm

- **Initial State:** IDLE
- **States:**
  - **IDLE**
    - **Description:** Waiting for request

  - **BUSY**
    - **Description:** MDIO transaction in progress

  - **STALLED**
    - **Description:** Transaction done but downstream stalled


- **Transitions:**
  - **F1**
    - **Effect Refs:**
      1. U1


    - **Event:** req_valid

    - **From:** IDLE

    - **Guard:** req_valid && !stall_in

    - **Priority:** 1

    - **Rule Ids:**
      1. B1


    - **To:** BUSY

  - **F2**
    - **Effect Refs:**


    - **Event:** mdio_done_stall

    - **From:** BUSY

    - **Guard:** mdio_done && stall_in

    - **Priority:** 1

    - **Rule Ids:**
      1. B3


    - **To:** STALLED

  - **F3**
    - **Effect Refs:**
      1. U2


    - **Event:** mdio_done_no_stall

    - **From:** BUSY

    - **Guard:** mdio_done && !stall_in

    - **Priority:** 2

    - **Rule Ids:**
      1. B2


    - **To:** IDLE

  - **F4**
    - **Effect Refs:**


    - **Event:** stall_clear

    - **From:** STALLED

    - **Guard:** !stall_in

    - **Priority:** 1

    - **Rule Ids:**
      1. B3


    - **To:** IDLE



### Control Model Kind

fsm_datapath

### Corner Cases

1. Simultaneous req_valid and mdio_done while stall_in is high.
2. High-priority request arriving exactly when a low-priority transaction finishes.
3. Stall_in asserting on the same cycle as mdio_done.

### Coverage Obligations

- **Nominal:** true
- **Priority:** true
- **Reset:** true
- **Stall:** true

### Datapath Rules

- **D1**
  - **Kind:** compare

  - **Rule:** req_ready = (state == IDLE) && !stall_in

  - **Rule Ids:**
    1. B2


  - **State Variable Ids:**


  - **Verification Required:** true


### Derived Fields

1. functionalConstraints
2. stateBehavior
3. protocolRules
4. expectedBehaviour
5. acceptanceCriteria

### Description

A DDR memory training controller that manages MDIO register access. It implements a 2-level priority scheme where high-priority requests bypass the standard queue, and handles downstream stalls by freezing the MDIO dispatch state.

### Design Invariants

1. req_ready and mdio_start are never high in the same cycle.
2. mdio_addr remains stable while mdio_start is high.

### Difficulty

intermediate

### Error Handling

Requests received while req_ready is low are ignored. The system does not implement a timeout for mdio_done; it relies on the external PHY.

### Executable Contract

- **Behavior:**
  - **Architecture:** The design consists of a 2-slot priority buffer, an MDIO transaction FSM, and a stall-aware output register. High-priority requests bypass the buffer if the FSM is IDLE.
  - **Behavior Tables:**
    - **Item 1**
      - **Columns:**
        1. State
        2. req_valid
        3. req_prio
        4. stall_in
        5. mdio_done
        6. Next State
        7. req_ready


      - **Rows:**
        - **Item 1:**
          1. IDLE
          2. 1
          3. 0
          4. 0
          5. X
          6. BUSY
          7. 1

        - **Item 2:**
          1. IDLE
          2. 1
          3. 1
          4. 0
          5. X
          6. BUSY
          7. 1

        - **Item 3:**
          1. BUSY
          2. X
          3. X
          4. 0
          5. 1
          6. IDLE
          7. 0

        - **Item 4:**
          1. BUSY
          2. X
          3. X
          4. 1
          5. 1
          6. STALLED
          7. 0

        - **Item 5:**
          1. STALLED
          2. X
          3. X
          4. 0
          5. X
          6. IDLE
          7. 0



      - **Title:** Priority and Stall Resolution


  - **Corner Cases:**
    1. Simultaneous req_valid and mdio_done while stall_in is high.
    2. High-priority request arriving exactly when a low-priority transaction finishes.
    3. Stall_in asserting on the same cycle as mdio_done.

  - **Design Invariants:**
    1. req_ready and mdio_start are never high in the same cycle.
    2. mdio_addr remains stable while mdio_start is high.

  - **Expected Behaviour:**
    1. B1: High-priority requests (req_prio=1) must be serviced before any pending low-priority requests.
    2. B2: mdio_start must remain high for exactly one cycle when mdio_done is low and stall_in is low.
    3. B3: If stall_in is high when a transaction completes (mdio_done=1), the sequencer must hold the current mdio_addr/wdata and not accept new requests.

  - **Functional Constraints:**
    1. High-priority requests (req_prio=1) must be serviced before any pending low-priority requests.
    2. mdio_start must remain high for exactly one cycle when mdio_done is low and stall_in is low.
    3. If stall_in is high when a transaction completes (mdio_done=1), the sequencer must hold the current mdio_addr/wdata and not accept new requests.

  - **Functional Overview:** The sequencer accepts 16-bit MDIO write requests. High-priority requests (req_prio=1) jump to the head of the dispatch logic, while low-priority requests are buffered. If the MDIO interface is busy or the downstream pipeline is stalled (stall_in=1), the sequencer holds the current command.
  - **Microarchitecture:** The FSM transitions from IDLE to BUSY upon receiving a request. It remains in BUSY until mdio_done is asserted. If stall_in is high during mdio_done, the FSM enters a STALLED state to hold the output valid until the stall clears.
  - **Output Contracts:**
    - **Mdio addr:**
      - **Active:** req_addr
      - **Idle:** 0
      - **Invalid:** hold
      - **Reset:** 0
      - **Source Refs:**
        1. SV2

      - **Stall:** hold

    - **Mdio start:**
      - **Active:** 1
      - **Idle:** 0
      - **Invalid:** 0
      - **Reset:** 0
      - **Source Refs:**
        1. F1
        2. F3

      - **Stall:** hold

    - **Mdio wdata:**
      - **Active:** req_data
      - **Idle:** 0
      - **Invalid:** hold
      - **Reset:** 0
      - **Source Refs:**
        1. SV2

      - **Stall:** hold

    - **Req ready:**
      - **Active:** 0
      - **Idle:** 1
      - **Invalid:** 0
      - **Reset:** 0
      - **Source Refs:**
        1. D1

      - **Stall:** 0


  - **Protocol Rules:**
    1. High-priority requests (req_prio=1) must be serviced before any pending low-priority requests.
    2. mdio_start must remain high for exactly one cycle when mdio_done is low and stall_in is low.

  - **State Behavior:**

  - **Timing Requirements:**
    1. T1: All inputs sampled on posedge clk.
    2. T2: mdio_start assertion latency is 1 cycle from req_valid.


- **Category:** rtl_design
- **Compiler Version:** canonical-contract-v1
- **Contract Hash:** 1nxemm6
- **Difficulty:** intermediate
- **Interface:**
  - **Clock:**
    - **Edge:** posedge
    - **Signal:** clk

  - **Fixed Constants:**
    - **MAX_ADDR**
      - **Description:** Maximum MDIO register address

      - **Value:** 31

      - **Width:** 5

    - **CMD_WIDTH**
      - **Description:** Total width of stored command (addr+data+prio)

      - **Value:** 22

      - **Width:** 6


  - **Parameters:**
    - **FIFO_DEPTH**
      - **Description:** Depth of the priority-bypass buffer

      - **Max:** 8

      - **Min:** 2

      - **Value:** 4


  - **Ports:**
    - **clk**
      - **Description:** System clock

      - **Direction:** input

      - **Width:** 1

    - **rst_n**
      - **Description:** Synchronous active-low reset

      - **Direction:** input

      - **Width:** 1

    - **req_valid**
      - **Description:** Request valid strobe

      - **Direction:** input

      - **Width:** 1

    - **req_prio**
      - **Description:** Priority bit (1=High, 0=Low)

      - **Direction:** input

      - **Width:** 1

    - **req_addr**
      - **Description:** MDIO Register Address

      - **Direction:** input

      - **Width:** 5

    - **req_data**
      - **Description:** MDIO Write Data

      - **Direction:** input

      - **Width:** 16

    - **req_ready**
      - **Description:** Sequencer ready for new request

      - **Direction:** output

      - **Width:** 1

    - **mdio_done**
      - **Description:** External MDIO PHY completion pulse

      - **Direction:** input

      - **Width:** 1

    - **mdio_start**
      - **Description:** Start MDIO transaction

      - **Direction:** output

      - **Width:** 1

    - **mdio_addr**
      - **Description:** Target MDIO address

      - **Direction:** output

      - **Width:** 5

    - **mdio_wdata**
      - **Description:** Target MDIO data

      - **Direction:** output

      - **Width:** 16

    - **stall_in**
      - **Description:** Downstream pipeline stall

      - **Direction:** input

      - **Width:** 1


  - **Reset:**
    - **Active:** 0
    - **Kind:** synchronous
    - **Signal:** rst_n

  - **Reset Behavior:**


- **Module Name:** mdio_calib_sequencer
- **Scenarios:**
  1. S1: Basic low-priority write transaction.
  2. S2: High-priority bypass during pending low-priority state.
  3. S3: Stall propagation during MDIO completion.

- **Schema Version:** 1
- **Timing Semantics:** explicit-edge-v2
- **Timing Semantics Version:** 2
- **Verification Checks:**
  - **check_reset**
    - **Antecedent:**
      - **Req valid:** 0
      - **Rst n:** 0
      - **Stall in:** 0


    - **Delay Cycles:** 0

    - **Expected:**
      - **Mdio start:** 0
      - **Req ready:** 0


    - **Expected Phases:**


    - **Expected Timings:**
      - **Mdio start:**
        - **Delay Cycles:** 0
        - **Hold Cycles:** 1
        - **Sample Phase:** post_edge

      - **Req ready:**
        - **Delay Cycles:** 0
        - **Hold Cycles:** 1
        - **Sample Phase:** post_edge



    - **Hold Cycles:** 1

    - **Observations:**
      - **Item 1**
        - **Delay Cycles:** 0

        - **Expected:**
          - **Mdio start:** 0
          - **Req ready:** 0


        - **Expected Phases:**
          - **Mdio start:** post_edge
          - **Req ready:** post_edge


        - **Explicit Timing:** true

        - **Hold Cycles:** 1



    - **Repeat Cycles:** 1

    - **Sample Phase:** post_edge

    - **Timing Semantics:** explicit-edge-v2

    - **Timing Semantics Version:** 2

  - **check_idle_ready**
    - **Antecedent:**
      - **Req valid:** 0
      - **Rst n:** 1
      - **Stall in:** 0


    - **Delay Cycles:** 1

    - **Expected:**
      - **Req ready:** 1


    - **Expected Phases:**


    - **Expected Timings:**
      - **Req ready:**
        - **Delay Cycles:** 1
        - **Hold Cycles:** 1
        - **Sample Phase:** post_edge



    - **Hold Cycles:** 1

    - **Observations:**
      - **Item 1**
        - **Delay Cycles:** 1

        - **Expected:**
          - **Req ready:** 1


        - **Expected Phases:**
          - **Req ready:** post_edge


        - **Explicit Timing:** true

        - **Hold Cycles:** 1



    - **Repeat Cycles:** 1

    - **Sample Phase:** post_edge

    - **Timing Semantics:** explicit-edge-v2

    - **Timing Semantics Version:** 2

  - **check_start_pulse**
    - **Antecedent:**
      - **Req addr:** 10
      - **Req data:** 43690
      - **Req prio:** 0
      - **Req valid:** 1
      - **Rst n:** 1


    - **Delay Cycles:** 0

    - **Expected:**
      - **Mdio addr:** 10
      - **Mdio start:** 1
      - **Mdio wdata:** 43690
      - **Req ready:** 1


    - **Expected Phases:**


    - **Expected Timings:**
      - **Mdio addr:**
        - **Delay Cycles:** 0
        - **Hold Cycles:** 1
        - **Sample Phase:** post_edge

      - **Mdio start:**
        - **Delay Cycles:** 0
        - **Hold Cycles:** 1
        - **Sample Phase:** post_edge

      - **Mdio wdata:**
        - **Delay Cycles:** 0
        - **Hold Cycles:** 1
        - **Sample Phase:** post_edge

      - **Req ready:**
        - **Delay Cycles:** 0
        - **Hold Cycles:** 1
        - **Sample Phase:** post_edge



    - **Hold Cycles:** 1

    - **Observations:**
      - **Item 1**
        - **Delay Cycles:** 0

        - **Expected:**
          - **Mdio addr:** 10
          - **Mdio start:** 1
          - **Mdio wdata:** 43690
          - **Req ready:** 1


        - **Expected Phases:**
          - **Mdio addr:** post_edge
          - **Mdio start:** post_edge
          - **Mdio wdata:** post_edge
          - **Req ready:** post_edge


        - **Explicit Timing:** true

        - **Hold Cycles:** 1



    - **Repeat Cycles:** 1

    - **Sample Phase:** post_edge

    - **Timing Semantics:** explicit-edge-v2

    - **Timing Semantics Version:** 2

  - **check_busy_stall**
    - **Antecedent:**
      - **Mdio done:** 1
      - **Req valid:** 0
      - **Rst n:** 1
      - **Stall in:** 1


    - **Delay Cycles:** 1

    - **Expected:**
      - **Mdio start:** 0
      - **Req ready:** 0


    - **Expected Phases:**


    - **Expected Timings:**
      - **Mdio start:**
        - **Delay Cycles:** 1
        - **Hold Cycles:** 1
        - **Sample Phase:** post_edge

      - **Req ready:**
        - **Delay Cycles:** 1
        - **Hold Cycles:** 1
        - **Sample Phase:** post_edge



    - **Hold Cycles:** 1

    - **Observations:**
      - **Item 1**
        - **Delay Cycles:** 1

        - **Expected:**
          - **Mdio start:** 0
          - **Req ready:** 0


        - **Expected Phases:**
          - **Mdio start:** post_edge
          - **Req ready:** post_edge


        - **Explicit Timing:** true

        - **Hold Cycles:** 1



    - **Repeat Cycles:** 1

    - **Sample Phase:** post_edge

    - **Timing Semantics:** explicit-edge-v2

    - **Timing Semantics Version:** 2



### Expected Behaviour

1. B1: High-priority requests (req_prio=1) must be serviced before any pending low-priority requests.
2. B2: mdio_start must remain high for exactly one cycle when mdio_done is low and stall_in is low.
3. B3: If stall_in is high when a transaction completes (mdio_done=1), the sequencer must hold the current mdio_addr/wdata and not accept new requests.

### Fixed Constants

- **MAX_ADDR**
  - **Description:** Maximum MDIO register address

  - **Value:** 31

  - **Width:** 5

- **CMD_WIDTH**
  - **Description:** Total width of stored command (addr+data+prio)

  - **Value:** 22

  - **Width:** 6


### Functional Constraints

1. High-priority requests (req_prio=1) must be serviced before any pending low-priority requests.
2. mdio_start must remain high for exactly one cycle when mdio_done is low and stall_in is low.
3. If stall_in is high when a transaction completes (mdio_done=1), the sequencer must hold the current mdio_addr/wdata and not accept new requests.

### Functional Overview

The sequencer accepts 16-bit MDIO write requests. High-priority requests (req_prio=1) jump to the head of the dispatch logic, while low-priority requests are buffered. If the MDIO interface is busy or the downstream pipeline is stalled (stall_in=1), the sequencer holds the current command.

### Microarchitecture

The FSM transitions from IDLE to BUSY upon receiving a request. It remains in BUSY until mdio_done is asserted. If stall_in is high during mdio_done, the FSM enters a STALLED state to hold the output valid until the stall clears.

### Module Name

mdio_calib_sequencer

### Output Contracts

- **Mdio addr:**
  - **Active:** req_addr
  - **Idle:** 0
  - **Invalid:** hold
  - **Reset:** 0
  - **Source Refs:**
    1. SV2

  - **Stall:** hold

- **Mdio start:**
  - **Active:** 1
  - **Idle:** 0
  - **Invalid:** 0
  - **Reset:** 0
  - **Source Refs:**
    1. F1
    2. F3

  - **Stall:** hold

- **Mdio wdata:**
  - **Active:** req_data
  - **Idle:** 0
  - **Invalid:** hold
  - **Reset:** 0
  - **Source Refs:**
    1. SV2

  - **Stall:** hold

- **Req ready:**
  - **Active:** 0
  - **Idle:** 1
  - **Invalid:** 0
  - **Reset:** 0
  - **Source Refs:**
    1. D1

  - **Stall:** 0


### Parameters

- **FIFO_DEPTH**
  - **Description:** Depth of the priority-bypass buffer

  - **Max:** 8

  - **Min:** 2

  - **Value:** 4


### Protocol Rules

1. High-priority requests (req_prio=1) must be serviced before any pending low-priority requests.
2. mdio_start must remain high for exactly one cycle when mdio_done is low and stall_in is low.

### Required Ports

- **clk**
  - **Description:** System clock

  - **Dir:** input

  - **Polarity:** posedge

  - **Sampling:** posedge

  - **Timing:** T1

  - **Width:** 1

- **rst_n**
  - **Description:** Synchronous active-low reset

  - **Dir:** input

  - **Polarity:** low

  - **Sampling:** posedge

  - **Timing:** T1

  - **Width:** 1

- **req_valid**
  - **Description:** Request valid strobe

  - **Dir:** input

  - **Polarity:** high

  - **Sampling:** posedge

  - **Timing:** T1

  - **Width:** 1

- **req_prio**
  - **Description:** Priority bit (1=High, 0=Low)

  - **Dir:** input

  - **Polarity:** high

  - **Sampling:** posedge

  - **Timing:** T1

  - **Width:** 1

- **req_addr**
  - **Description:** MDIO Register Address

  - **Dir:** input

  - **Polarity:** high

  - **Sampling:** posedge

  - **Timing:** T1

  - **Width:** 5

- **req_data**
  - **Description:** MDIO Write Data

  - **Dir:** input

  - **Polarity:** high

  - **Sampling:** posedge

  - **Timing:** T1

  - **Width:** 16

- **req_ready**
  - **Description:** Sequencer ready for new request

  - **Dir:** output

  - **Polarity:** high

  - **Sampling:** posedge

  - **Timing:** T1

  - **Width:** 1

- **mdio_done**
  - **Description:** External MDIO PHY completion pulse

  - **Dir:** input

  - **Polarity:** high

  - **Sampling:** posedge

  - **Timing:** T1

  - **Width:** 1

- **mdio_start**
  - **Description:** Start MDIO transaction

  - **Dir:** output

  - **Polarity:** high

  - **Sampling:** posedge

  - **Timing:** T1

  - **Width:** 1

- **mdio_addr**
  - **Description:** Target MDIO address

  - **Dir:** output

  - **Polarity:** high

  - **Sampling:** posedge

  - **Timing:** T1

  - **Width:** 5

- **mdio_wdata**
  - **Description:** Target MDIO data

  - **Dir:** output

  - **Polarity:** high

  - **Sampling:** posedge

  - **Timing:** T1

  - **Width:** 16

- **stall_in**
  - **Description:** Downstream pipeline stall

  - **Dir:** input

  - **Polarity:** high

  - **Sampling:** posedge

  - **Timing:** T1

  - **Width:** 1


### Reset

- **Active:** 0
- **Kind:** synchronous
- **Signal:** rst_n

### Reset Behavior

On rst_n=0, all internal counters, FSM state, and req_ready are cleared to 0. mdio_start is deasserted.

### Scenario Contract

- **S1**
  - **Coverage Tags:**
    1. priority
    2. stall


  - **Rationale:** Verify that a high priority request is handled and that stall_in correctly holds the FSM state.

  - **Requirement Ids:**
    1. B1
    2. B3


  - **Steps:**
    - **Item 1**
      - **Delay Cycles:** 0

      - **Drive:**
        - **Req addr:** 5
        - **Req data:** 511
        - **Req prio:** 1
        - **Req valid:** 1
        - **Rst n:** 1
        - **Stall in:** 0


      - **Expected:**
        - **Mdio addr:** 5
        - **Mdio start:** 1
        - **Req ready:** 1


      - **Hold Cycles:** 1

      - **Repeat Cycles:** 1

      - **Sample Phase:** post_edge

    - **Item 2**
      - **Delay Cycles:** 0

      - **Drive:**
        - **Mdio done:** 1
        - **Req valid:** 0
        - **Stall in:** 1


      - **Expected:**
        - **Mdio start:** 0
        - **Req ready:** 0


      - **Hold Cycles:** 1

      - **Repeat Cycles:** 1

      - **Sample Phase:** post_edge

    - **Item 3**
      - **Delay Cycles:** 0

      - **Drive:**
        - **Stall in:** 0


      - **Expected:**
        - **Req ready:** 1


      - **Hold Cycles:** 1

      - **Repeat Cycles:** 1

      - **Sample Phase:** post_edge



  - **Visibility:** publicGraded


### State Behavior


### State Variables

- **SV1**
  - **Range:**
    1. 0
    2. 4


  - **Reset:** 0

  - **Signed:** false

  - **Updates:**
    - **U1**
      - **Operation:** increment

      - **Transition Ids:**
        1. F1


      - **Value:** 1



  - **Width:** 3

- **SV2**
  - **Range:**
    1. 0
    2. 1


  - **Reset:** 0

  - **Signed:** false

  - **Updates:**
    - **U2**
      - **Operation:** set

      - **Transition Ids:**
        1. F3


      - **Value:** req_prio



  - **Width:** 1


### Task Kind

rtl_design

### Timing Requirements

1. T1: All inputs sampled on posedge clk.
2. T2: mdio_start assertion latency is 1 cycle from req_valid.

### Timing Semantics

explicit-edge-v2

### Timing Semantics Version

2

### Title

MDIO Priority-Tagged Calibration Sequencer

### Topic Concept

MDIO Management Interface

### Verification Checks

- **check_reset**
  - **Antecedent:**
    - **Req valid:** 0
    - **Rst n:** 0
    - **Stall in:** 0


  - **Delay Cycles:** 0

  - **Expected:**
    - **Mdio start:** 0
    - **Req ready:** 0


  - **Expected Timings:**
    - **Mdio start:**
      - **Delay Cycles:** 0
      - **Hold Cycles:** 1
      - **Sample Phase:** post_edge

    - **Req ready:**
      - **Delay Cycles:** 0
      - **Hold Cycles:** 1
      - **Sample Phase:** post_edge



  - **Hold Cycles:** 1

  - **Timing Semantics:** explicit-edge-v2

  - **Timing Semantics Version:** 2

- **check_idle_ready**
  - **Antecedent:**
    - **Req valid:** 0
    - **Rst n:** 1
    - **Stall in:** 0


  - **Delay Cycles:** 1

  - **Expected:**
    - **Req ready:** 1


  - **Expected Timings:**
    - **Req ready:**
      - **Delay Cycles:** 1
      - **Hold Cycles:** 1
      - **Sample Phase:** post_edge



  - **Hold Cycles:** 1

  - **Timing Semantics:** explicit-edge-v2

  - **Timing Semantics Version:** 2

- **check_start_pulse**
  - **Antecedent:**
    - **Req addr:** 10
    - **Req data:** 43690
    - **Req prio:** 0
    - **Req valid:** 1
    - **Rst n:** 1


  - **Delay Cycles:** 0

  - **Expected:**
    - **Mdio addr:** 10
    - **Mdio start:** 1
    - **Mdio wdata:** 43690
    - **Req ready:** 1


  - **Expected Timings:**
    - **Mdio addr:**
      - **Delay Cycles:** 0
      - **Hold Cycles:** 1
      - **Sample Phase:** post_edge

    - **Mdio start:**
      - **Delay Cycles:** 0
      - **Hold Cycles:** 1
      - **Sample Phase:** post_edge

    - **Mdio wdata:**
      - **Delay Cycles:** 0
      - **Hold Cycles:** 1
      - **Sample Phase:** post_edge

    - **Req ready:**
      - **Delay Cycles:** 0
      - **Hold Cycles:** 1
      - **Sample Phase:** post_edge



  - **Hold Cycles:** 1

  - **Timing Semantics:** explicit-edge-v2

  - **Timing Semantics Version:** 2

- **check_busy_stall**
  - **Antecedent:**
    - **Mdio done:** 1
    - **Req valid:** 0
    - **Rst n:** 1
    - **Stall in:** 1


  - **Delay Cycles:** 1

  - **Expected:**
    - **Mdio start:** 0
    - **Req ready:** 0


  - **Expected Timings:**
    - **Mdio start:**
      - **Delay Cycles:** 1
      - **Hold Cycles:** 1
      - **Sample Phase:** post_edge

    - **Req ready:**
      - **Delay Cycles:** 1
      - **Hold Cycles:** 1
      - **Sample Phase:** post_edge



  - **Hold Cycles:** 1

  - **Timing Semantics:** explicit-edge-v2

  - **Timing Semantics Version:** 2


### Verification Scenarios

1. S1: Basic low-priority write transaction.
2. S2: High-priority bypass during pending low-priority state.
3. S3: Stall propagation during MDIO completion.


## Recorded test outcomes

5/5 recorded tests passed

- Priority Bypass and Stall: passed
- check_reset: passed
- check_idle_ready: passed
- check_start_pulse: passed
- check_busy_stall: passed

## Repository contents

- `design.sv` — saved student source
- `testbench.sv` — saved student source
- Waveform was not saved in this historical record

> Private graders, reference solutions, hidden vectors and credentials are never published.
