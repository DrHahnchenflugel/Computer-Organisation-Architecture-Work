LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY data_path IS
	PORT (
			-- CLK Signals
			CLK, mCLK	: IN	STD_LOGIC;
			
			-- Memory Signals
			WEN, EN		: IN STD_LOGIC;
			
			-- Register Control SIgnals (CLR, LD)
			CLR_A, LD_A	  : IN STD_LOGIC;
			CLR_B, LD_B	  : IN STD_LOGIC;
			CLR_C, LD_C	  : IN STD_LOGIC;
			CLR_Z, LD_Z	  : IN STD_LOGIC;
			CLR_PC, LD_PC : IN STD_LOGIC;
			CLR_IR, LD_IR : IN STD_LOGIC;
			
			-- Register Outputs
			OUT_A		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			OUT_B		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			OUT_C		: OUT STD_LOGIC;
			OUT_Z		: OUT STD_LOGIC;
			OUT_PC	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			OUT_IR	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			
			-- Special Inputs to PC
			INC_PC	: IN STD_LOGIC;
			
			-- Address and Data Bus signals for debugging
			ADDR_OUT		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_IN		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_BUS,
			MEM_OUT,
			MEM_IN		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			MEM_ADDR		: OUT UNSIGNED(7 DOWNTO 0);
			
			-- Various MUX controls
			DATA_MUX			: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			REG_MUX			: IN STD_LOGIC;
			A_MUX, B_MUX	: IN STD_LOGIC;
			IM_MUX1			: IN STD_LOGIC;
			IM_MUX2			: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			
			-- ALU Operations
			ALU_OP			: IN STD_LOGIC_VECTOR(2 DOWNTO 0));
END data_path;

ARCHITECTURE Behaviour OF data_path IS
	-- Component Instantiations
	-- Data Memory Module
	COMPONENT data_mem IS
	PORT (
		clk		: IN STD_LOGIC;								--clock
		addr		: IN UNSIGNED(7 DOWNTO 0);					--address
		data_in	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);		--data input for writing
		wen		: IN STD_LOGIC;								--write enable
		en			: IN STD_LOGIC;								--enable
		data_out	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));	--data output
	END COMPONENT;

	-- Register32
	COMPONENT register32 IS
	PORT (
		d			: IN STD_LOGIC_VECTOR(31 DOWNTO 0); --input
		ld			: IN STD_LOGIC; --load/EN
		clr		: IN STD_LOGIC; --async. CLR
		clk		: IN STD_LOGIC; --CLK
		Q			: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); --output
	END COMPONENT;
	
	-- Program Counter
	COMPONENT pc IS
	PORT (
		clr	: IN STD_LOGIC; -- async. CLR
		clk	: IN STD_LOGIC; -- CLK
		ld		: IN STD_LOGIC; -- load/EN (q is loaded w/ d at CLK rising edge)
		inc	: IN STD_LOGIC; -- increment PC by 4
		d		: IN STD_LOGIC_VECTOR(31 DOWNTO 0); 	-- input
		q		: INOUT STD_LOGIC_VECTOR(31 DOWNTO 0)); -- output
	END COMPONENT;
	
	-- LZE
	COMPONENT LZE IS
	PORT (
		LZE_in	:	IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		LZE_out	:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	
	-- UZE
	COMPONENT UZE IS
	PORT (
		UZE_in	:	IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		UZE_out	:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;
	
	-- RED
	COMPONENT RED IS
	PORT (
		RED_in	:	IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		RED_out	:	OUT	UNSIGNED(7 DOWNTO 0));
	END COMPONENT;
	
	-- Mux4to1
	COMPONENT mux4to1 IS
	PORT (
		sel		: IN STD_LOGIC_VECTOR(1 DOWNTO 0); 	-- selector (00/01/10/11)
		in1, in2, in3, in4	: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- inputs
		result	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); -- output
	END COMPONENT;
	
	-- Mux2to1
	COMPONENT mux2to1 IS
	PORT (
		sel		: IN STD_LOGIC; 			 				-- selector (0/1)
		in1, in2	: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- inputs
		result	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); 			-- output
	END COMPONENT;
	
	-- ALU
	COMPONENT alu IS
	PORT (
		a		 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		b		 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		op		 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		result :	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		cout	 : OUT STD_LOGIC;
		zero	 : OUT STD_LOGIC);
	END COMPONENT;
	
	-- Signal Instantiations
	SIGNAL IR_OUT				: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL data_bus_s			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL LZE_out_PC			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL LZE_OUT_A_Mux		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL LZE_OUT_B_Mux		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL RED_out_Data_Mem : UNSIGNED(7 DOWNTO 0);
	SIGNAL A_Mux_out			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL B_Mux_out			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL reg_A_out			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL reg_B_out			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL reg_Mux_out		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL data_mem_out		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL UZE_IM_MUX1_out  : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL IM_MUX1_out		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL LZE_IM_MUX2_out	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL IM_MUX2_out		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALU_out				: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL zero_flag			: STD_LOGIC;
	SIGNAL carry_flag			: STD_LOGIC;
	SIGNAL temp					: STD_LOGIC_VECTOR(30 DOWNTO 0) := (others => '0');
	SIGNAL out_pc_sig			: STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
	IR : 	register32 port map(
			data_bus_s,
			Ld_IR,
			Clr_IR,
			Clk,
			IR_OUT);
	
	LZE_PC : LZE port map(
		IR_OUT,
		LZE_out_PC);
		
	PC0	: pc port map (
		CLR_PC,
		Clk,
		ld_PC,
		INC_PC,
		LZE_out_PC,
		--ADDR_OUT
		out_pc_sig);
	
	LZE_A_Mux : LZE port map(
		IR_OUT,
		LZE_OUT_A_Mux);
		
	A_Mux0	: mux2to1 port map (
		A_MUX,
		data_bus_s, LZE_OUT_A_Mux,
		A_mux_out);
	
	Reg_A		: register32 port map (
		A_Mux_out,
		LD_A,
		CLR_A,
		Clk,
		REG_A_out);
	
	LZE_B_Mux : LZE port map(
		IR_OUT,
		LZE_OUT_B_Mux);
		
	B_Mux0	: mux2to1 port map (
		B_MUX,
		data_bus_s, LZE_OUT_B_Mux,
		B_mux_out);
	
	Reg_B		: register32 port map (
		B_Mux_out,
		LD_B,
		CLR_B,
		Clk,
		REG_B_out);
	
	Reg_Mux0	: mux2to1 port map (
		REG_MUX,
		Reg_A_out, Reg_B_out,
		Reg_Mux_out);
	
	RED_Data_Mem	: RED port map (
		IR_OUT,
		RED_out_Data_Mem);
	
	Data_Mem0 	: data_mem port map (
		mCLK,
		RED_out_Data_Mem,
		Reg_Mux_out,
		WEN,
		EN,
		data_mem_out);
		
	UZE_IM_MUX1	: UZE port map (
		IR_OUT,
		UZE_IM_MUX1_out);
	
	IM_MUX1a	: mux2to1 port map (
		IM_MUX1,
		reg_A_out, UZE_IM_MUX1_out,
		IM_MUX1_out);
	
	LZE_IM_MUX2	: LZE port map (
		IR_OUT,
		LZE_IM_MUX2_out);
	
	IM_MUX2a	: mux4to1 port map (
		IM_MUX2,
		reg_B_out, LZE_IM_MUX2_out, (temp & '1'), (others => '0'),
		IM_MUX2_out);
	
	ALU0	: ALU port map (
		IM_MUX1_out,
		IM_MUX2_out,
		ALU_OP,
		ALU_out,
		carry_flag,
		zero_flag);
	
	DATA_MUX0 : mux4to1 port map (
		DATA_MUX,
		DATA_IN, data_mem_out, ALU_out, (others => '0'),
		DATA_BUS_s);
	
	DATA_BUS <= datA_BUS_s;
	OUT_A <= reg_A_out;
	OUT_B <= reg_B_out;
	OUT_C <= carry_flag;
	OUT_Z <= zero_flag;
	OUT_IR <= IR_OUT;
	ADDR_OUT <= out_pc_sig;
	OUT_PC <= out_pc_sig;
	
	
	MEM_ADDR <= RED_out_Data_Mem;
	MEM_IN <= Reg_Mux_out;
	MEM_OUT <= data_mem_out;

END Behaviour;
