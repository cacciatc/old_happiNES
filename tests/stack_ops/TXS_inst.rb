#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class TXSTest < Test::Unit::TestCase
	def setup
		@temp_file = "txs_dump"
		@input_file = "txs_input"
	end

	def test_addr_mode_implied
		instr = [0xA2,0x78,0x9A]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("78",fstring[$s_line].chomp)
		assert_equal("78",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end
	
	def teardown
		system("rm #{@temp_file} #{@input_file}")
	end

	def write_input_file(instr)
		f = File.new(@input_file,"wb")
		f.write(instr.pack("C*"))
		f.close
	end
end
