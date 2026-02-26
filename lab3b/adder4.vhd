-----------------------------------------------------------------------------------
--8 bit adder
-----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder4 is
	  port (
			Cin: in std_logic;
			X, Y: in std_logic_vector(3 downto 0);
			S: out std_logic_vector(3 downto 0);
			Cout: out std_logic
	  );
end adder4;

architecture Behavior of adder4 is
    signal tmp: unsigned(4 downto 0);
begin
	tmp <= unsigned("0" & X) + unsigned("0" & Y) + unsigned'("0" & Cin);
	S <= std_logic_vector(tmp(3 downto 0));
	Cout <= tmp(4);
end Behavior;
