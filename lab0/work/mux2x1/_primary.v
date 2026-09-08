library verilog;
use verilog.vl_types.all;
entity mux2x1 is
    generic(
        width           : integer := 1
    );
    port(
        a_i             : in     vl_logic_vector;
        b_i             : in     vl_logic_vector;
        sel_i           : in     vl_logic;
        out_o           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end mux2x1;
