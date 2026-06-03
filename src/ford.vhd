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
		A : in SIGNED (7 downto 0);
		B : in SIGNED (7 downto 0);
		
		-- 2.3. Saidas
		Z : out SIGNED (31 downto 0)
	);
end ford;

-- 3. Arquitetura
architecture logica of ford is

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
	
begin
		-- 3.2 Codigo
		-- 3.2.1 Ajustando tamnho das entradas para 32 bits
		a32 <= resize(a, 32);
		b32 <= resize(b, 32);
		
		-- Evitando div por 0
		b_safe <= to_signed(1, 32) when b32 = 0 else b32;
		
		-- 3.2.2 elevações
		a1 <= resize(a32 * a32, 32); -- a²
		a2 <= resize(a1 * a1, 32); -- a⁴
		a3 <= resize(a1 * a32, 32); -- a³
		
		b1 <= resize(b32 * b32, 32); -- b²
		
		-- 3^b
		process(b32)
			variable temp : signed(31 downto 0);
			variable ib : integer;
		begin
			ib := to_integer(b32);
			temp := to_signed(1, 32);
			
			if ib > 0 and ib <= 19 then
				for i in 1 to 19 loop
					if i <= ib then
						temp := resize(temp * 3, 32);
					end if;
				end loop;
			elsif ib < 0 then
				temp := to_signed(0, 32);
			elsif ib > 19 then
				temp := to_signed(2147483647, 32);
			end if;
			
			mult3 <= temp;
			
		end process;
		
		-- 3.2.3 Multiplicações
		mult1 <= resize(a2 * 5, 32); -- 5a²
		mult2 <= resize(b1 * 2, 32); -- 2b²
		-- mult3 <= resize(b32 * 3, 32); -- 3b
		mult4 <= resize(b32 * 5, 32); -- 5b
		
		-- 3.2.5 Divisões
		div1 <= resize(a3 / b_safe, 32); -- a³ / b
		
		-- 3.2.4 Somas
		soma1 <= (mult1 + mult2); -- 5a⁴ + 2b²
		soma2 <= (div1 + mult4); -- (a³ / b) + 5b
		
		-- 3.2.
		sel1 <= (soma1 + mult3); -- 5a⁴ + 2b² + 3b
		sel2 <= resize(soma2 * (-1), 32); -- -((a³ / b) + 5b)
		
		
		-- Mux
		process(a, b, sel1, sel2)
		begin
			if (a < b) then
				Z <= sel1;
			else
				Z <= sel2;
			end if;
		end process;		
		
end logica;
		
