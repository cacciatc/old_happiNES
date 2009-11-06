#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class SYATest < Test::Unit::TestCase
	def setup
		@temp_file = "sya_dump"
		@input_file = "sya_input"
	end

	def test_addr_mode_absolute_x
		instr = [0xA0,0xFF,0x9C,0x00,0xFF,0xAD,0x00,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA0,0xF0,0x9C,0x00,0xFF,0xAD,0x00,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("F1",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA0,0x0F,0x9C,0x00,0xFF,0xAD,0x00,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
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
