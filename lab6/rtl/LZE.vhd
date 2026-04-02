LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LZE IS
PORT (
	LZE_in	:	IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
	LZE_out	:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0));
END LZE;

ARCHITECTURE Behaviour OF LZE IS
	SIGNAL zeros : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
BEGIN
	LZE_out <= zeros & LZE_in(15 DOWNTO 0);
END Behaviour;