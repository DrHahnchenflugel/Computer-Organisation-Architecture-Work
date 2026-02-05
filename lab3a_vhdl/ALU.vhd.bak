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
	VARIABLE carry : STD_LOGIC_VECTOR(32 DOWNTO 0);
	VARIABLE twos_comp : STD_LOGIC_VECTOR(31 DOWNTO 0);
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

	BEGIN
		IF op = '000' THEN
			result <= a AND b;
			cout <= '0';
			zero <= '0';
			IF result = all_zeros_32 THEN
				zero <= '1';
			END IF;
		ELSIF op = '001' THEN
			result <= a OR b;
			cout <= '0';
			zero <= '0';
			IF result = all_zeros_32 THEN
				zero <= '1';
			END IF;
		ELSIF op = '010' THEN
			carry(0) := '0';
			
			for i in 0 to 31 loop
				result(i) <= a(i) XOR b(i) XOR carry(i);
				carry(i+1) := (a(i) AND b(i)) OR
									(a(i) AND carry(i)) OR
									(b(i) AND carry(i));
			end loop;
			
			zero <= '0';
			if result = all_zeros_32 THEN 
				zero <= '1';
			END IF;
			
			cout <= carry(32);
		ELSIF op = '110' THEN
			twos_comp := NOT a;
			twos_comp := STD_LOGIC_VECTOR(unsigned(twos_comp) + 1);
			
			carry(0) := '0';
			
			for i in 0 to 31 loop
				result(i) <= twos_comp(i) XOR b(i) XOR carry(i);
				carry(i+1) := (twos_comp(i) AND b(i)) OR
									(twos_comp(i) AND carry(i)) OR
									(b(i) AND carry(i));
			end loop;
			
			zero <= '0';
			if result = all_zeros_32 THEN 
				zero <= '1';
			END IF;
			
			cout <= carry(32);
		ELSIF op = '100' THEN
			cout <= a(31);
			zero <= '0';
			IF a(31) = '1' THEN zero <= '1'; END IF;
			a <= a(30 DOWNTO 0) & a(31);
		ELSIF op = '101' THEN
			cout <= a(0);
			zero <= '0';
			IF a(0) = '1' THEN zero <= '1'; END IF;
			a <= a(0) & a(31 DOWNTO 1);
		END IF;
END behaviour;