#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class SXATest < Test::Unit::TestCase
	def setup
		@temp_file = "sxa_dump"
		@input_file = "sxa_input"
	end

	def test_addr_mode_absolute_y
		instr = [0xA2,0x1F,0x9E,0x00,0x1F,0xAD,0x00,0x1F,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("20",fstring[$a_line].chomp)
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
