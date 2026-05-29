-- 1. Bibliotecas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- 2. Entidade do Testbench (Sempre vazia)
entity tb_ford is
end tb_ford;

-- 3. Arquitetura
architecture behavior of tb_ford is

    -- Sinais internos para conectar à entidade (DUT - Device Under Test)
    signal clk_tb : STD_LOGIC := '0';
    signal rst_tb : STD_LOGIC := '0';
    signal A_tb   : UNSIGNED(3 downto 0) := (others => '0');
    signal B_tb   : UNSIGNED(3 downto 0) := (others => '0');
    signal Z_tb   : UNSIGNED(5 downto 0);

    -- Constante para o período do clock
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instanciação da entidade a ser testada (DUT)
    uut: entity work.ford
        port map (
            clk => clk_tb,
            rst => rst_tb,
            A   => A_tb,
            B   => B_tb,
            Z   => Z_tb
        );

    -- Processo de geração do Clock
    clk_process : process
    begin
        clk_tb <= '0';
        wait for CLK_PERIOD / 2;
        clk_tb <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Processo de estímulos (Aplicando os testes)
    stim_process : process
    begin
        -- 1. Aplicando o Reset
        rst_tb <= '1';
        wait for 20 ns;
        rst_tb <= '0';
        wait for 10 ns;

        -- 2. Casos de Teste
        
        -- Teste 1: 0 + 0
        A_tb <= to_unsigned(0, 4);
        B_tb <= to_unsigned(0, 4);
        wait for 20 ns;

        -- Teste 2: 5 + 3 = 8
        A_tb <= to_unsigned(5, 4);
        B_tb <= to_unsigned(3, 4);
        wait for 20 ns;

        -- Teste 3: 15 + 1 = 16 (Testando transporte de bit / overflow de 4 bits)
        A_tb <= to_unsigned(15, 4); -- 1111 em binário
        B_tb <= to_unsigned(1, 4);  -- 0001 em binário
        wait for 20 ns;

        -- Teste 4: Valor máximo (15 + 15 = 30)
        A_tb <= to_unsigned(15, 4);
        B_tb <= to_unsigned(15, 4);
        wait for 20 ns;

        -- Fim da simulação (Pausa infinita para não repetir)
        wait;
    end process;

end behavior;
