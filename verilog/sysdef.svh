`ifndef SYSDEF_SVH
`define SYSDEF_SVH

typedef enum logic [1:0] {
    INVALID,
    ENCRYPT,
    DECRYPT
} job_t;

typedef enum logic [1:0] {
    IDLE,
    KEY_GEN,
    PROCESS
} fsm_state_t;

typedef struct packed {
    logic          valid;
    logic [127:0]  data;
    logic          en_de;
    logic          set_key;
} in_packet_t;

typedef struct packed {
    logic          valid;
    logic [127:0]  data;
    logic          en_de;
} out_packet_t;

`endif 