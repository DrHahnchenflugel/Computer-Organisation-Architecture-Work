library verilog;
use verilog.vl_types.all;
entity data_path_vlg_sample_tst is
    port(
        A_MUX           : in     vl_logic;
        ALU_OP          : in     vl_logic_vector(2 downto 0);
        B_MUX           : in     vl_logic;
        CLK             : in     vl_logic;
        CLR_A           : in     vl_logic;
        CLR_B           : in     vl_logic;
        CLR_C           : in     vl_logic;
        CLR_IR          : in     vl_logic;
        CLR_PC          : in     vl_logic;
        CLR_Z           : in     vl_logic;
        DATA_IN         : in     vl_logic_vector(31 downto 0);
        DATA_MUX        : in     vl_logic_vector(1 downto 0);
        EN              : in     vl_logic;
        IM_MUX1         : in     vl_logic;
        IM_MUX2         : in     vl_logic_vector(1 downto 0);
        INC_PC          : in     vl_logic;
        LD_A            : in     vl_logic;
        LD_B            : in     vl_logic;
        LD_C            : in     vl_logic;
        LD_IR           : in     vl_logic;
        LD_PC           : in     vl_logic;
        LD_Z            : in     vl_logic;
        mCLK            : in     vl_logic;
        REG_MUX         : in     vl_logic;
        WEN             : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end data_path_vlg_sample_tst;
