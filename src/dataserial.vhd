library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dataserial is
    Port(
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        A : in SIGNED(7 downto 0);
        B : in SIGNED(7 downto 0);
        
        -- Sinais de Controle (Entradas vindas da FSM)
        ld_in       : in STD_LOGIC;
        ld_sq       : in STD_LOGIC;
        ld_a3_a4    : in STD_LOGIC;
        ld_mults    : in STD_LOGIC;
        ld_pow_init : in STD_LOGIC;
        ld_pow_step : in STD_LOGIC;
        ld_div      : in STD_LOGIC;
        ld_out1     : in STD_LOGIC;
        ld_out2     : in STD_LOGIC;
        
        -- Sinais de Status (Saídas para a FSM)
        a_less_b    : out STD_LOGIC;
        pow_done    : out STD_LOGIC;
        
        -- Saída de Dados
        Z : out SIGNED(31 downto 0)
    );
end dataserial;

architecture rtl of dataserial is
    -- Registradores internos baseados nos sinais originais
    signal reg_a, reg_b : signed(31 downto 0);
    signal reg_a2, reg_b2 : signed(31 downto 0);
    signal reg_a3, reg_a4 : signed(31 downto 0);
    signal reg_mult1, reg_mult2, reg_mult4 : signed(31 downto 0);
    signal reg_pow : signed(31 downto 0);
    signal pow_count : integer;
    signal reg_div : signed(31 downto 0);
    signal b_safe : signed(31 downto 0);
begin
    
    -- Lógica de Status Contínua
    a_less_b <= '1' when (A < B) else '0';
    pow_done <= '1' when (pow_count <= 0) else '0';
    
    -- Proteção contra divisão por zero (b_safe)
    b_safe <= to_signed(1, 32) when reg_b = 0 else reg_b;

    process(clk, rst)
    begin
        if rst = '1' then
            reg_a <= (others => '0'); reg_b <= (others => '0');
            reg_a2 <= (others => '0'); reg_b2 <= (others => '0');
            reg_a3 <= (others => '0'); reg_a4 <= (others => '0');
            reg_mult1 <= (others => '0'); reg_mult2 <= (others => '0');
            reg_mult4 <= (others => '0'); reg_pow <= (others => '0');
            pow_count <= 0; reg_div <= (others => '0'); Z <= (others => '0');
            
        elsif rising_edge(clk) then
            -- 1. Carrega as entradas
            if ld_in = '1' then
                reg_a <= resize(A, 32);
                reg_b <= resize(B, 32);
            end if;

            -- 2. Elevações (Quadrados)
            if ld_sq = '1' then
                reg_a2 <= resize(reg_a * reg_a, 32);
                reg_b2 <= resize(reg_b * reg_b, 32);
            end if;

            -- 3. Elevações (Cubos e a^4)
            if ld_a3_a4 = '1' then
                reg_a3 <= resize(reg_a2 * reg_a, 32);
                reg_a4 <= resize(reg_a2 * reg_a2, 32);
            end if;

            -- 4. Multiplicações Base
            if ld_mults = '1' then
                reg_mult1 <= resize(reg_a4 * 5, 32);
                reg_mult2 <= resize(reg_b2 * 2, 32);
                reg_mult4 <= resize(reg_b * 5, 32);
            end if;

            -- 5. Lógica Serial do Exponente 3^b
            if ld_pow_init = '1' then
                reg_pow <= to_signed(1, 32);
                if to_integer(reg_b) > 19 then
                    pow_count <= 19;
                elsif to_integer(reg_b) < 0 then
                    pow_count <= 0;
                    reg_pow <= to_signed(0, 32);
                else
                    pow_count <= to_integer(reg_b);
                end if;
            elsif ld_pow_step = '1' then
                if pow_count > 0 then
                    reg_pow <= resize(reg_pow * 3, 32);
                    pow_count <= pow_count - 1;
                end if;
            end if;

            -- 6. Divisão
            if ld_div = '1' then
                reg_div <= resize(reg_a3 / b_safe, 32);
            end if;

            -- 7. Multiplexador de Saída
            if ld_out1 = '1' then
                Z <= reg_mult1 + reg_mult2 + reg_pow;
            elsif ld_out2 = '1' then
                Z <= resize((reg_div + reg_mult4) * (-1), 32);
            end if;
        end if;
    end process;
end rtl;
