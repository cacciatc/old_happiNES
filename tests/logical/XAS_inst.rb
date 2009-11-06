#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class XASTest < Test::Unit::TestCase
	def setup
		@temp_file = "xas_dump"
		@input_file = "xas_input"
	end

	def test_addr_mode_absolute_y
		instr = [0xA2,0xFF,0xA9,0xFF,0x9B,0x00,0xFF,0xAD,0x00,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$s_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA2,0xF0,0xA9,0xF0,0x9B,0x00,0xFF,0xAD,0x00,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("F0",fstring[$s_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA2,0x0F,0xA9,0x0F,0x9B,0x00,0xFF,0xAD,0x00,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("0F",fstring[$s_line].chomp)
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
