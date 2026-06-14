library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity unitcontrol is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        start : in STD_LOGIC;
        
        -- Sinais de Status (Entradas vindas do datapath)
        a_less_b : in STD_LOGIC;
        pow_done : in STD_LOGIC;
        
        -- Sinais de Controle (Saídas para o datapath)
        ld_in       : out STD_LOGIC;
        ld_sq       : out STD_LOGIC;
        ld_a3_a4    : out STD_LOGIC;
        ld_mults    : out STD_LOGIC;
        ld_pow_init : out STD_LOGIC;
        ld_pow_step : out STD_LOGIC;
        ld_div      : out STD_LOGIC;
        ld_out1     : out STD_LOGIC;
        ld_out2     : out STD_LOGIC;
        
        done        : out STD_LOGIC
    );
end unitcontrol;

architecture fsm of unitcontrol is
    type state_type is (IDLE, S_LOAD, S_SQ, S_A3_A4, S_MULTS_DIV, S_POW_INIT, S_POW_LOOP, S_OUT1, S_OUT2, S_DONE);
    signal state, next_state : state_type;
begin
    -- Processo sequencial de atualização de estado
    process(clk, rst)
    begin
        if rst = '1' then
            state <= IDLE;
        elsif rising_edge(clk) then
            state <= next_state;
        end if;
    end process;

    -- Processo combinacional da máquina de estados
    process(state, start, a_less_b, pow_done)
    begin
        -- Zerando todos os controles por padrão para evitar latches
        ld_in <= '0'; ld_sq <= '0'; ld_a3_a4 <= '0'; ld_mults <= '0';
        ld_pow_init <= '0'; ld_pow_step <= '0'; ld_div <= '0';
        ld_out1 <= '0'; ld_out2 <= '0'; done <= '0';
        next_state <= state;

        case state is
            when IDLE =>
                if start = '1' then
                    next_state <= S_LOAD;
                end if;
                
            when S_LOAD =>
                ld_in <= '1';
                next_state <= S_SQ;
                
            when S_SQ =>
                ld_sq <= '1';
                next_state <= S_A3_A4;
                
            when S_A3_A4 =>
                ld_a3_a4 <= '1';
                next_state <= S_MULTS_DIV;
                
            when S_MULTS_DIV =>
                ld_mults <= '1';
                ld_div <= '1';
                -- A FSM decide aqui qual caminho calcular
                if a_less_b = '1' then
                    next_state <= S_POW_INIT;
                else
                    next_state <= S_OUT2;
                end if;
                
            when S_POW_INIT =>
                ld_pow_init <= '1';
                next_state <= S_POW_LOOP;
                
            when S_POW_LOOP =>
                if pow_done = '1' then
                    next_state <= S_OUT1;
                else
                    ld_pow_step <= '1';
                end if;
                
            when S_OUT1 =>
                ld_out1 <= '1';
                next_state <= S_DONE;
                
            when S_OUT2 =>
                ld_out2 <= '1';
                next_state <= S_DONE;
                
            when S_DONE =>
                done <= '1';
                if start = '0' then
                    next_state <= IDLE;
                end if;
                
        end case;
    end process;
end fsm;
