-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"

-- DATE "08/27/2026 19:24:05"

-- 
-- Device: Altera EP3C16F484C6 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEIII;
LIBRARY IEEE;
USE CYCLONEIII.CYCLONEIII_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	mux2x1 IS
    PORT (
	a_i : IN std_logic_vector(0 DOWNTO 0);
	b_i : IN std_logic_vector(0 DOWNTO 0);
	sel_i : IN std_logic;
	out_o : BUFFER std_logic_vector(0 DOWNTO 0)
	);
END mux2x1;

-- Design Ports Information
-- out_o[0]	=>  Location: PIN_J1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- a_i[0]	=>  Location: PIN_J6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- b_i[0]	=>  Location: PIN_H5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- sel_i	=>  Location: PIN_D2,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF mux2x1 IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_a_i : std_logic_vector(0 DOWNTO 0);
SIGNAL ww_b_i : std_logic_vector(0 DOWNTO 0);
SIGNAL ww_sel_i : std_logic;
SIGNAL ww_out_o : std_logic_vector(0 DOWNTO 0);
SIGNAL \out_o[0]~output_o\ : std_logic;
SIGNAL \a_i[0]~input_o\ : std_logic;
SIGNAL \sel_i~input_o\ : std_logic;
SIGNAL \b_i[0]~input_o\ : std_logic;
SIGNAL \out_o~0_combout\ : std_logic;

BEGIN

ww_a_i <= a_i;
ww_b_i <= b_i;
ww_sel_i <= sel_i;
out_o <= ww_out_o;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

-- Location: IOOBUF_X0_Y20_N9
\out_o[0]~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \out_o~0_combout\,
	devoe => ww_devoe,
	o => \out_o[0]~output_o\);

-- Location: IOIBUF_X0_Y24_N1
\a_i[0]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_a_i(0),
	o => \a_i[0]~input_o\);

-- Location: IOIBUF_X0_Y25_N1
\sel_i~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_sel_i,
	o => \sel_i~input_o\);

-- Location: IOIBUF_X0_Y27_N1
\b_i[0]~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_b_i(0),
	o => \b_i[0]~input_o\);

-- Location: LCCOMB_X6_Y24_N8
\out_o~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \out_o~0_combout\ = (\sel_i~input_o\ & (\a_i[0]~input_o\)) # (!\sel_i~input_o\ & ((\b_i[0]~input_o\)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1010111110100000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \a_i[0]~input_o\,
	datac => \sel_i~input_o\,
	datad => \b_i[0]~input_o\,
	combout => \out_o~0_combout\);

ww_out_o(0) <= \out_o[0]~output_o\;
END structure;


