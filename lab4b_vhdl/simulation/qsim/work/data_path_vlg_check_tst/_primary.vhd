library verilog;
use verilog.vl_types.all;
entity data_path_vlg_check_tst is
    port(
        ADDR_OUT        : in     vl_logic_vector(31 downto 0);
        DATA_BUS        : in     vl_logic_vector(31 downto 0);
        MEM_ADDR        : in     vl_logic_vector(7 downto 0);
        MEM_IN          : in     vl_logic_vector(31 downto 0);
        MEM_OUT         : in     vl_logic_vector(31 downto 0);
        OUT_A           : in     vl_logic_vector(31 downto 0);
        OUT_B           : in     vl_logic_vector(31 downto 0);
        OUT_C           : in     vl_logic;
        OUT_IR          : in     vl_logic_vector(31 downto 0);
        OUT_PC          : in     vl_logic_vector(31 downto 0);
        OUT_Z           : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end data_path_vlg_check_tst;
