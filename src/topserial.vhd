library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity topserial is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        start : in STD_LOGIC;
        A : in SIGNED(7 downto 0);
        B : in SIGNED(7 downto 0);
        Z : out SIGNED(31 downto 0);
        done : out STD_LOGIC
    );
end topserial;

architecture struct of topserial is
    
    -- Instanciando Unidade de Controle
    component unitcontrol is
        Port (
            clk : in STD_LOGIC; rst : in STD_LOGIC; start : in STD_LOGIC;
            a_less_b : in STD_LOGIC; pow_done : in STD_LOGIC;
            ld_in : out STD_LOGIC; ld_sq : out STD_LOGIC; ld_a3_a4 : out STD_LOGIC;
            ld_mults : out STD_LOGIC; ld_pow_init : out STD_LOGIC;
            ld_pow_step : out STD_LOGIC; ld_div : out STD_LOGIC;
            ld_out1 : out STD_LOGIC; ld_out2 : out STD_LOGIC;
            done : out STD_LOGIC
        );
    end component;

    -- Instanciando Datapath
    component dataserial is
        Port(
            clk : in STD_LOGIC; rst : in STD_LOGIC;
            A : in SIGNED(7 downto 0); B : in SIGNED(7 downto 0);
            ld_in : in STD_LOGIC; ld_sq : in STD_LOGIC; ld_a3_a4 : in STD_LOGIC;
            ld_mults : in STD_LOGIC; ld_pow_init : in STD_LOGIC;
            ld_pow_step : in STD_LOGIC; ld_div : in STD_LOGIC;
            ld_out1 : in STD_LOGIC; ld_out2 : in STD_LOGIC;
            a_less_b : out STD_LOGIC; pow_done : out STD_LOGIC;
            Z : out SIGNED(31 downto 0)
        );
    end component;

    -- Sinais de interconexão
    signal w_ld_in, w_ld_sq, w_ld_a3_a4, w_ld_mults : STD_LOGIC;
    signal w_ld_pow_init, w_ld_pow_step, w_ld_div : STD_LOGIC;
    signal w_ld_out1, w_ld_out2 : STD_LOGIC;
    signal w_a_less_b, w_pow_done : STD_LOGIC;

begin
    
    -- Mapeamento da FSM
    U_CTRL : unitcontrol
    port map (
        clk => clk, rst => rst, start => start,
        a_less_b => w_a_less_b, pow_done => w_pow_done,
        ld_in => w_ld_in, ld_sq => w_ld_sq, ld_a3_a4 => w_ld_a3_a4,
        ld_mults => w_ld_mults, ld_pow_init => w_ld_pow_init,
        ld_pow_step => w_ld_pow_step, ld_div => w_ld_div,
        ld_out1 => w_ld_out1, ld_out2 => w_ld_out2,
        done => done
    );

    -- Mapeamento do Datapath
    U_DATA : dataserial
    port map (
        clk => clk, rst => rst, A => A, B => B,
        ld_in => w_ld_in, ld_sq => w_ld_sq, ld_a3_a4 => w_ld_a3_a4,
        ld_mults => w_ld_mults, ld_pow_init => w_ld_pow_init,
        ld_pow_step => w_ld_pow_step, ld_div => w_ld_div,
        ld_out1 => w_ld_out1, ld_out2 => w_ld_out2,
        a_less_b => w_a_less_b, pow_done => w_pow_done,
        Z => Z
    );

end struct;
