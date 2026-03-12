LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RED IS
PORT (
	RED_in	:	IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
	RED_out	:	OUT	UNSIGNED(7 DOWNTO 0));
END RED;

ARCHITECTURE Behaviour OF RED IS
BEGIN
	RED_out <= unsigned (RED_in(7 DOWNTO 0));
END Behaviour;