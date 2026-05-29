-- 1. Bibliotecas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Adiciona logica matematica

-- 2. Entidade
entity ford is
	Port(
		-- 2.1 clock/reset
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
	
		-- 2.2. Entradas
		A : in UNSIGNED (3 downto 0);
		B : in UNSIGNED (3 downto 0);
		
		-- 2.3. Saidas
		Z : out UNSIGNED (5 downto 0)
	);
end ford;

-- 3. Arquitetura
architecture soma of ford is
begin
	Z <= resize(A + B, 6);
end soma;
		
