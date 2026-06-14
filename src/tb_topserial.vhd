library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_topserial is
-- Testbench não possui portas
end tb_topserial;

architecture sim of tb_topserial is

    -- Declaração do componente que vamos testar (Device Under Test - DUT)
    component topserial is
        Port (
            clk   : in STD_LOGIC;
            rst   : in STD_LOGIC;
            start : in STD_LOGIC;
            A     : in SIGNED(7 downto 0);
            B     : in SIGNED(7 downto 0);
            Z     : out SIGNED(31 downto 0);
            done  : out STD_LOGIC
        );
    end component;

    -- Sinais internos para conectar ao DUT
    signal clk   : STD_LOGIC := '0';
    signal rst   : STD_LOGIC := '0';
    signal start : STD_LOGIC := '0';
    signal A     : SIGNED(7 downto 0) := (others => '0');
    signal B     : SIGNED(7 downto 0) := (others => '0');
    signal Z     : SIGNED(31 downto 0);
    signal done  : STD_LOGIC;

    -- Constante para o período do clock
    constant clk_period : time := 10 ns;

begin

    -- Instanciação do DUT
    DUT: topserial
    port map (
        clk   => clk,
        rst   => rst,
        start => start,
        A     => A,
        B     => B,
        Z     => Z,
        done  => done
    );

    -- Processo gerador de Clock
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Processo de estímulos (Injeção de sinais)
    stim_proc: process
    begin
        -- 1. Aplicar Reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        -- ==========================================
        -- TESTE 1: A < B (Ex: A = 2, B = 3)
        -- ==========================================
        A <= to_signed(2, 8);
        B <= to_signed(3, 8);
        
        -- Pulso de Start
        start <= '1';
        wait for clk_period;
        start <= '0';

        -- Aguarda o sinal 'done' subir para indicar que terminou
        wait until done = '1';
        wait for clk_period * 2; -- Espera uns clocks a mais para ver o resultado na onda

        -- ==========================================
        -- TESTE 2: A > B (Ex: A = 4, B = 2)
        -- ==========================================
        A <= to_signed(4, 8);
        B <= to_signed(2, 8);
        
        -- Pulso de Start
        start <= '1';
        wait for clk_period;
        start <= '0';

        -- Aguarda o sinal 'done' subir
        wait until done = '1';
        wait for clk_period * 2;

        -- Fim da simulação
        wait;
    end process;

end sim;
