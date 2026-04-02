LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY mux4to1 IS
PORT (
	sel		: IN STD_LOGIC_VECTOR(1 DOWNTO 0); 	-- selector (00/01/10/11)
	in1, in2, in3, in4	: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- inputs
	result	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); -- output
END mux4to1;

ARCHITECTURE Behaviour OF mux4to1 IS
BEGIN
    PROCESS(in1, in2, in3, in4, sel)
    BEGIN
        IF sel = "00" THEN
            result <= in1;
        ELSIF sel = "01" THEN
            result <= in2;
        ELSIF sel = "10" THEN
            result <= in3;
        ELSE
            result <= in4;
        END IF;
    END PROCESS;
END Behaviour;