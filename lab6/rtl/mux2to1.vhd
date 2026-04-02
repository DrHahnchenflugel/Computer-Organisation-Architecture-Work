LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY mux2to1 IS
PORT (
	sel		: IN STD_LOGIC; 			 				-- selector (0/1)
	in1, in2	: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- inputs
	result	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); 			-- output
END mux2to1;

ARCHITECTURE Behaviour OF mux2to1 IS
BEGIN
    PROCESS(in1, in2, sel)
    BEGIN
        IF sel = '0' THEN
            result <= in1;
        ELSIF sel = '1' THEN
            result <= in2;
        END IF;
    END PROCESS;
END Behaviour;