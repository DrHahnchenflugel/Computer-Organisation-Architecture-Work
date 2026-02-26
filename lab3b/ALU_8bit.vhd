-----------------------------------------------------------------------------------
--8 bit ALU
-----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ALU_8bit is
    port (
        a       : in std_logic_vector(7 downto 0);
        b       : in std_logic_vector(7 downto 0);
        op      : in std_logic_vector(2 downto 0);
        result  : out std_logic_vector(7 downto 0);
        zero    : out std_logic;
        cout    : out std_logic
    );
end ALU_8bit;

architecture Behavior of ALU_8bit is
    component adder8
        port (
            Cin  : in std_logic;
            X, Y : in std_logic_vector(7 downto 0);
            S    : out std_logic_vector(7 downto 0);
            Cout : out std_logic
        );
    end component;

    signal result_s    : std_logic_vector(7 downto 0) := (others => '0');
    signal result_add  : std_logic_vector(7 downto 0) := (others => '0');
    signal result_sub  : std_logic_vector(7 downto 0) := (others => '0');
    signal cout_add    : std_logic := '0';
    signal cout_sub    : std_logic := '0';
begin
    add0: adder8 port map (op(2), a, b, result_add, cout_add);
    sub0: adder8 port map (op(2), a, not b, result_sub, cout_sub);

    process (a, b, op)
    begin
        case op is
            when "000" =>  -- a AND b
                result_s <= a and b;
                cout <= '0';
            when "001" =>  -- a OR b
                result_s <= a or b;
                cout <= '0';
            when "010" =>  -- a + b
                result_s <= result_add;
                cout <= cout_add;
            when "011" =>  -- b
                result_s <= b;
                cout <= '0';
            when "110" =>  -- a - b
                result_s <= result_sub;
                cout <= cout_sub;
            when "100" =>  -- shift left 1
                result_s <= a(6 downto 0) & '0';
                cout <= a(7);
            when "101" =>  -- shift right 1
                result_s <= '0' & a(7 downto 1);
                cout <= '0';
            when others =>
                result_s <= a;
                cout <= '0';
        end case;

        case result_s is
            when (others => '0') =>
                zero <= '1';
            when others =>
                zero <= '0';
        end case;
    end process;

    result <= result_s;
    --cout <= cout_s;
    --zero <= zero_s;
end Behavior;