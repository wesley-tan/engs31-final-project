-- small_fifo.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity small_fifo is
  generic (
    DATA_WIDTH : natural := 19;  -- width of pattern entry
    DEPTH      : natural := 4    -- FIFO depth
  );
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;

    -- write side
    wr_en   : in  std_logic;
    wr_data : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    full    : out std_logic;

    -- read side
    rd_en   : in  std_logic;
    rd_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
    empty   : out std_logic
  );
end entity;

architecture rtl of small_fifo is
  -- pointer width = ceil(log2(DEPTH))
  constant PTR_WIDTH : natural := 4;
  type mem_t is array(0 to DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);

  signal mem       : mem_t := (others => (others => '0'));
  signal wr_ptr    : unsigned(PTR_WIDTH-1 downto 0) := (others => '0');
  signal rd_ptr    : unsigned(PTR_WIDTH-1 downto 0) := (others => '0');
  signal element_count : unsigned(PTR_WIDTH downto 0) := (others => '0');
  signal dout_reg  : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
begin

  ----------------------------------------------------------------------------
  -- Sequential write/read & count
  ----------------------------------------------------------------------------
  proc_rw: process(clk, reset_n)
  begin
    if reset_n = '0' then
      wr_ptr        <= (others => '0');
      rd_ptr        <= (others => '0');
      element_count <= (others => '0');
      mem            <= (others => (others => '0'));
      dout_reg      <= (others => '0');
    elsif rising_edge(clk) then

      -- WRITE SIDE
      if (wr_en = '1') and (element_count < DEPTH) then
        mem(to_integer(wr_ptr)) <= wr_data;
        wr_ptr        <= wr_ptr + 1;
        element_count <= element_count + 1;
      end if;

      -- READ SIDE
      if (rd_en = '1') and (element_count > 0) then
        dout_reg      <= mem(to_integer(rd_ptr));
        rd_ptr        <= rd_ptr + 1;
        element_count <= element_count - 1;
      end if;

    end if;
  end process proc_rw;

  ----------------------------------------------------------------------------
  -- Concurrent flag & data‑out assignments
  ----------------------------------------------------------------------------
  full  <= '1' when element_count = DEPTH else '0';
  empty <= '1' when element_count = 0     else '0';
  rd_data <= dout_reg;

end architecture;
