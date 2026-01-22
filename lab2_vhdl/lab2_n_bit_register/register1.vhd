LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY register1 IS
PORT(
	d			: IN STD_LOGIC; --input
	ld			: IN STD_LOGIC; --load/EN
	clr		: IN STD_LOGIC; --async. CLR
	clk		: IN STD_LOGIC; --CLK
	Q			: OUT STD_LOGIC); --output
END register1;

ARCHITECTURE Behaviour OF register1 IS
BEGIN
	PROCESS (clr, clk)
	BEGIN
		IF clr = '1' THEN
			Q <= '0' ;
		ELSIF clk'EVENT AND clk = '1' AND ld = '1' THEN
			Q <= D ;
		END IF;
	END PROCESS;
END Behaviour;