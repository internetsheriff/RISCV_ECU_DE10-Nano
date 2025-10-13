	component sys is
		port (
			clk_clk                            : in  std_logic                     := 'X';             -- clk
			master_0_master_reset_reset        : out std_logic;                                        -- reset
			pin_out_external_connection_export : out std_logic_vector(31 downto 0);                    -- export
			pulpino_0_config_testmode_i        : in  std_logic                     := 'X';             -- testmode_i
			pulpino_0_config_fetch_enable_i    : in  std_logic                     := 'X';             -- fetch_enable_i
			pulpino_0_config_clock_gating_i    : in  std_logic                     := 'X';             -- clock_gating_i
			pulpino_0_config_boot_addr_i       : in  std_logic_vector(31 downto 0) := (others => 'X'); -- boot_addr_i
			reset_reset_n                      : in  std_logic                     := 'X';             -- reset_n
			pio_in_external_connection_export  : in  std_logic_vector(31 downto 0) := (others => 'X')  -- export
		);
	end component sys;

	u0 : component sys
		port map (
			clk_clk                            => CONNECTED_TO_clk_clk,                            --                         clk.clk
			master_0_master_reset_reset        => CONNECTED_TO_master_0_master_reset_reset,        --       master_0_master_reset.reset
			pin_out_external_connection_export => CONNECTED_TO_pin_out_external_connection_export, -- pin_out_external_connection.export
			pulpino_0_config_testmode_i        => CONNECTED_TO_pulpino_0_config_testmode_i,        --            pulpino_0_config.testmode_i
			pulpino_0_config_fetch_enable_i    => CONNECTED_TO_pulpino_0_config_fetch_enable_i,    --                            .fetch_enable_i
			pulpino_0_config_clock_gating_i    => CONNECTED_TO_pulpino_0_config_clock_gating_i,    --                            .clock_gating_i
			pulpino_0_config_boot_addr_i       => CONNECTED_TO_pulpino_0_config_boot_addr_i,       --                            .boot_addr_i
			reset_reset_n                      => CONNECTED_TO_reset_reset_n,                      --                       reset.reset_n
			pio_in_external_connection_export  => CONNECTED_TO_pio_in_external_connection_export   --  pio_in_external_connection.export
		);

