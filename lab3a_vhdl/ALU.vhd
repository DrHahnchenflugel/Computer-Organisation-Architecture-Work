LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY alu IS 
PORT (
	a		 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	b		 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	op		 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	result :	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	cout	 : OUT STD_LOGIC;
	zero	 : OUT STD_LOGIC);
END alu;

ARCHITECTURE behaviour OF alu IS
	CONSTANT all_zeros_32 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN

-- ALU OP CODES and BEHAVIOUR
-- 000 - a AND b 
--		cout = 0 
--		zero = 1 IF a AND b = 0x32
-- 001 - a OR b
--		cout = 0 
--		zero = 1 IF a OR b = 0x32
-- 010 - a + b 
--		cout calculated 
--		zero = 1 IF a+b = 0x32
-- 110 - a - b 
--		cout calculated (bout) 
--		zero = 1 IF a-b = 0x32
-- 100 - ROL (a << 1) 
--		cout = a(31) 
--		zero = 1 IF cout = 0
-- 101 - ROR (a >> 1) 
--		cout = a(0)
--		zero = 1 IF cout = 0
	PROCESS (a, b, op)
		VARIABLE carry : STD_LOGIC_VECTOR(32 DOWNTO 0);			-- Store carry for addition
		VARIABLE twos_comp : STD_LOGIC_VECTOR(31 DOWNTO 0);	-- Store twos comp for subtraction
		VARIABLE result_var : STD_LOGIC_VECTOR(31 DOWNTO 0);  -- Store result as a variable. This is done so result can be checked in the process.
	BEGIN
		-- SET DEFAULTS
		zero <= '0';
		cout <= '0';
		result_var := (OTHERS => '0');
		carry := (OTHERS => '0');
		twos_comp := (OTHERS => '0');
		
		-- OPCODE 000; A AND B
		IF op = "000" THEN
			result_var := a AND b;
			cout <= '0';
		-- OPCODE 001; A OR B
		ELSIF op = "001" THEN
			result_var := a OR b;
			cout <= '0';
		-- OPCODE 010; A + B
		ELSIF op = "010" THEN
			carry(0) := '0';
			
			for i in 0 to 31 loop
				result_var(i) := a(i) XOR b(i) XOR carry(i);
				carry(i+1) := (a(i) AND b(i)) OR
									(a(i) AND carry(i)) OR
									(b(i) AND carry(i));
			end loop;
			
			cout <= carry(32);
		-- OPCODE 110; A - B
		ELSIF op = "110" THEN
			-- find 2s comp of B [(NOT B) + 1]
 			twos_comp := NOT b;
			-- Add 1
			carry(0) := '1';
			
			-- add a with 2s comp of B
			for i in 0 to 31 loop
				result_var(i) := a(i) XOR twos_comp(i) XOR carry(i);
				carry(i+1) := (twos_comp(i) AND a(i)) OR
									(twos_comp(i) AND carry(i)) OR
									(a(i) AND carry(i));
			end loop;
			
			cout <= carry(32);
		-- OPCODE 100; ROL (a << 1)
		ELSIF op = "100" THEN
			cout <= a(31);
			result_var := a(30 DOWNTO 0) & a(31);
		-- OPCODE 101; ROR (a >> 1)
		ELSIF op = "101" THEN
			cout <= a(0);
			result_var := a(0) & a(31 DOWNTO 1);
		-- ILLEGAL OPCODE; SET RESULT TO 0x32
		ELSE
			result_var := (others => '0');
		END IF;
		
		-- Update result and zero signal
		result <= result_var;
		IF result_var = all_zeros_32 THEN zero <= '1'; END IF; -- Zero if result = 0x32
	END PROCESS;
END behaviour;