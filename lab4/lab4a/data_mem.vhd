LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY data_mem IS
PORT(
	clk		: IN STD_LOGIC;								--clock
	addr		: IN UNSIGNED(7 DOWNTO 0);					--address
	data_in	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);		--data input for writing
	wen		: IN STD_LOGIC;								--write enable
	en			: IN STD_LOGIC;								--enable
	data_out	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));	--data output
END data_mem;

ARCHITECTURE behaviour OF data_mem IS
	TYPE mem_t IS ARRAY(0 to 127) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL mem :mem_t;
BEGIN
	PROCESS(clk)
	BEGIN
		IF clk'EVENT AND clk = '0' AND en = '1' THEN --on falling edge of clock and EN is active high
			IF wen = '1' THEN 	-- if write enabled
				data_out <= (others => '0');
				mem(to_integer(addr)) <= data_in;
			ELSE						-- if write disabled
				data_out <= mem(to_integer(addr));
			END IF; -- end write if
		ELSIF clk'EVENT AND clk = '0' THEN
			data_out <= (others => '0');	
		END IF; -- end falling edge + EN if
	END PROCESS;
END behaviour;