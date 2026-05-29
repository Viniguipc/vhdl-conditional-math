-- 1. Bibliotecas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- 2. Entidade Vazia
entity tb_ford is
end tb_ford;

-- 3. Arquitetura
architecture behavior of tb_ford is

    -- Sinais de conexão com o DUT (Device Under Test)
    signal clk_tb : STD_LOGIC := '0';
    signal rst_tb : STD_LOGIC := '0';
    signal A_tb   : SIGNED(7 downto 0) := (others => '0');
    signal B_tb   : SIGNED(7 downto 0) := (others => '0');
    signal Z_tb   : SIGNED(31 downto 0);

    -- Período do Clock
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instanciação do seu circuito
    uut: entity work.ford
        port map (
            clk => clk_tb,
            rst => rst_tb,
            A   => A_tb,
            B   => B_tb,
            Z   => Z_tb
        );

    -- Processo gerador de Clock
    clk_process : process
    begin
        clk_tb <= '0';
        wait for CLK_PERIOD / 2;
        clk_tb <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Processo de Estímulos
    stim_process : process
    begin
        -- 1. Reset inicial
        rst_tb <= '1';
        wait for 20 ns;
        rst_tb <= '0';
        wait for 10 ns;

        -- 2. Teste 1: A < B (Deve ativar o caminho sel1)
        A_tb <= to_signed(1, 8);
        B_tb <= to_signed(2, 8);
        wait for 20 ns;

        -- 3. Teste 2: A > B (Deve ativar o caminho sel2)
        A_tb <= to_signed(3, 8);
        B_tb <= to_signed(2, 8);
        wait for 20 ns;

        -- 4. Teste 3: Com números negativos e A < B
        A_tb <= to_signed(-2, 8);
        B_tb <= to_signed(4, 8);
        wait for 20 ns;
        
        -- 5. Teste 4: Valores iguais (A = B) -> Cai no 'else' (sel2)
        A_tb <= to_signed(2, 8);
        B_tb <= to_signed(2, 8);
        wait for 20 ns;

        wait; -- Fim da simulação
    end process;

end behavior;
