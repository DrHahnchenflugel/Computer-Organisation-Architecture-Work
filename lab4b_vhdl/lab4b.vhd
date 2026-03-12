LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY lab4b IS
    PORT (
        CLK     : IN  STD_LOGIC;
        RESET   : IN  STD_LOGIC;
        LEDR    : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
END lab4b;

ARCHITECTURE Behaviour OF lab4b IS

    COMPONENT data_path IS
        PORT (
            CLK, mCLK      : IN  STD_LOGIC;

            WEN, EN        : IN  STD_LOGIC;

            CLR_A, LD_A    : IN  STD_LOGIC;
            CLR_B, LD_B    : IN  STD_LOGIC;
            CLR_C, LD_C    : IN  STD_LOGIC;
            CLR_Z, LD_Z    : IN  STD_LOGIC;
            CLR_PC, LD_PC  : IN  STD_LOGIC;
            CLR_IR, LD_IR  : IN  STD_LOGIC;

            OUT_A          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            OUT_B          : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            OUT_C          : OUT STD_LOGIC;
            OUT_Z          : OUT STD_LOGIC;
            OUT_PC         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            OUT_IR         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

            INC_PC         : IN  STD_LOGIC;

            ADDR_OUT       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            DATA_IN        : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            DATA_BUS       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            MEM_OUT        : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            MEM_IN         : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            MEM_ADDR       : OUT UNSIGNED(7 DOWNTO 0);

            DATA_MUX       : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
            REG_MUX        : IN  STD_LOGIC;
            A_MUX          : IN  STD_LOGIC;
            B_MUX          : IN  STD_LOGIC;
            IM_MUX1        : IN  STD_LOGIC;
            IM_MUX2        : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);

            ALU_OP         : IN  STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    signal out_a_s      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal out_b_s      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal out_pc_s     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal out_ir_s     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal addr_out_s   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal data_bus_s   : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal mem_out_s    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal mem_in_s     : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal mem_addr_s   : UNSIGNED(7 DOWNTO 0);
    signal out_c_s      : STD_LOGIC;
    signal out_z_s      : STD_LOGIC;

    signal data_in_s    : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    data_in_s <= (OTHERS => '0');

    DP0 : data_path
    PORT MAP (
        CLK         => CLK,
        mCLK        => CLK,

        WEN         => '0',
        EN          => '1',

        CLR_A       => RESET,
        LD_A        => '0',
        CLR_B       => RESET,
        LD_B        => '0',
        CLR_C       => RESET,
        LD_C        => '0',
        CLR_Z       => RESET,
        LD_Z        => '0',
        CLR_PC      => RESET,
        LD_PC       => '0',
        CLR_IR      => RESET,
        LD_IR       => '0',

        OUT_A       => out_a_s,
        OUT_B       => out_b_s,
        OUT_C       => out_c_s,
        OUT_Z       => out_z_s,
        OUT_PC      => out_pc_s,
        OUT_IR      => out_ir_s,

        INC_PC      => '1',

        ADDR_OUT    => addr_out_s,
        DATA_IN     => data_in_s,
        DATA_BUS    => data_bus_s,
        MEM_OUT     => mem_out_s,
        MEM_IN      => mem_in_s,
        MEM_ADDR    => mem_addr_s,

        DATA_MUX    => "00",
        REG_MUX     => '0',
        A_MUX       => '0',
        B_MUX       => '0',
        IM_MUX1     => '0',
        IM_MUX2     => "00",

        ALU_OP      => "010"
    );

    LEDR(7 DOWNTO 0) <= out_pc_s(7 DOWNTO 0);
    LEDR(8) <= out_c_s;
    LEDR(9) <= out_z_s;

END Behaviour;