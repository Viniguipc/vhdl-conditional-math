-- 1. Bibliotecas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Adiciona logica matematica

-- 2. Entidade
entity lancer is
	Port(
		-- 2.1 clock/reset
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
	
		-- 2.2. Entradas
		A : in SIGNED (7 downto 0);
		B : in SIGNED (7 downto 0);
		
		-- 2.3. Saidas
		Z : out SIGNED (31 downto 0)
	);
end ford;

-- 3. Arquitetura
architecture logica of lancer is

	-- 3.1 Sinais
	-- 3.1.1 Sinais de entradas para 32 bits
	signal a32 : signed (31 downto 0);
	signal b32 : signed (31 downto 0);
	
	-- 3.1.2 Sinais intermediarios
	signal a1 : signed (31 downto 0);
	signal a2 : signed (31 downto 0);
	signal a3 : signed (31 downto 0);
	
	signal b1 : signed (31 downto 0);
	
	signal mult1 :signed (31 downto 0);
	signal mult2 :signed (31 downto 0);
	signal mult3 :signed (31 downto 0);
	signal mult4 :signed (31 downto 0);
	
	signal div1 : signed (31 downto 0);
	
	signal soma1 :signed (31 downto 0);
	signal soma2 :signed (31 downto 0);
	
	-- 3.1.3 Resultado nos seletores
	signal sel1 : signed (31 downto 0);
	signal sel2 : signed (31 downto 0);
	
	-- 3.1.4 B safe para mudar de 0 para 1 e impossibilitar div por 0
	signal b_safe : signed (31 downto 0);
	
	-- 3.1.5 Maquina de estados
	signal estado : unsigned (1 downto 0);
	
begin
	-- 3.2 Codigo
	case estado is
		when 0 =>
			
		when 1 =>
			
		
		process(a, b, sel1, sel2)
		begin
			if (a < b) then
				Z <= sel1;
			else
				Z <= sel2;
			end if;
		end process;		
		
end logica;
		
