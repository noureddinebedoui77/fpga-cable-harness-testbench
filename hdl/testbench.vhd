LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FPGA_Core_tb_complete IS
END FPGA_Core_tb_complete;

ARCHITECTURE behavior OF FPGA_Core_tb_complete IS

  SIGNAL clk        : std_logic := '0';
  SIGNAL reset      : std_logic := '1';
  SIGNAL clk_enable : std_logic := '0';
  SIGNAL In1        : std_logic_vector(15 DOWNTO 0) := (others => '0');
  SIGNAL ce_out     : std_logic;
  SIGNAL Out3       : std_logic;

  CONSTANT CLK_PERIOD : time := 25 ns;

BEGIN

  uut : ENTITY work.FPGA_Core
    PORT MAP (
      clk        => clk,
      reset      => reset,
      clk_enable => clk_enable,
      In1        => In1,
      ce_out     => ce_out,
      Out3       => Out3
    );

  clk_process : PROCESS
  BEGIN
    WHILE TRUE LOOP
      clk <= '0'; WAIT FOR CLK_PERIOD / 2;
      clk <= '1'; WAIT FOR CLK_PERIOD / 2;
    END LOOP;
  END PROCESS;

  stim_proc : PROCESS
  BEGIN

    -------------------------------------------------------------------------
    -- PHASE 1 : RESET (50 cycles = 1250 ns)
    -------------------------------------------------------------------------
    reset      <= '1';
    clk_enable <= '0';
    In1        <= std_logic_vector(to_signed(16#0000#, 16));
    WAIT FOR CLK_PERIOD * 50;

    -------------------------------------------------------------------------
    -- PHASE 2 : FIN RESET + ENABLE ACTIF
    -------------------------------------------------------------------------
    reset <= '0';
    WAIT FOR CLK_PERIOD * 5;
    clk_enable <= '1';
    WAIT FOR CLK_PERIOD * 20;

    -------------------------------------------------------------------------
    -- PHASE 3 : SAUT 1 (0 -> +32767)  MAXIMUM POSITIF
    -------------------------------------------------------------------------
    In1 <= std_logic_vector(to_signed(16#7FFF#, 16));
    WAIT FOR CLK_PERIOD * 10;

    -------------------------------------------------------------------------
    -- PHASE 4 : STABLE à +32767
    -------------------------------------------------------------------------
    In1 <= std_logic_vector(to_signed(16#7FFF#, 16));
    WAIT FOR CLK_PERIOD * 30;

    -------------------------------------------------------------------------
    -- PHASE 5 : SAUT 2 (+32767 -> -32768)  CHANGEMENT BRUTAL
    -------------------------------------------------------------------------
    In1 <= std_logic_vector(to_signed(16#8000#, 16));
    WAIT FOR CLK_PERIOD * 10;

    -------------------------------------------------------------------------
    -- PHASE 6 : STABLE à -32768
    -------------------------------------------------------------------------
    In1 <= std_logic_vector(to_signed(16#8000#, 16));
    WAIT FOR CLK_PERIOD * 30;

    -------------------------------------------------------------------------
    -- PHASE 7 : RETOUR à 0
    -------------------------------------------------------------------------
    In1 <= std_logic_vector(to_signed(16#0000#, 16));
    WAIT FOR CLK_PERIOD * 10;

    -------------------------------------------------------------------------
    -- PHASE 8 : STABLE FINAL
    -------------------------------------------------------------------------
    In1 <= std_logic_vector(to_signed(16#0000#, 16));
    WAIT FOR CLK_PERIOD * 50;

    -------------------------------------------------------------------------
    -- FIN
    -------------------------------------------------------------------------
    WAIT FOR CLK_PERIOD * 20;
    std.env.stop;

  END PROCESS;

END behavior;