LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY UZE IS
PORT (
	UZE_in	:	IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
	UZE_out	:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0));
END UZE;

ARCHITECTURE Behaviour OF UZE IS
	SIGNAL zeros : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
BEGIN
	UZE_out <= UZE_in(15 DOWNTO 0) & zeros;
END Behaviour;