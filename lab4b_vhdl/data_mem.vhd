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
	TYPE RAM IS ARRAY (0 TO 255) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL DATAMEM : RAM;
BEGIN
	PROCESS(clk, en, wen)
	BEGIN
		IF (clk'event AND clk = '0') THEN
			IF (en = '0') THEN
				data_out <= (OTHERS => '0');
			ELSE
				IF (wen = '0') THEN
					data_out <= DATAMEM (to_integer(addr));
				END IF;
				IF (wen = '1') THEN
					DATAMEM (to_integer(addr)) <= data_in;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END behaviour;