#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class ARRTest < Test::Unit::TestCase
	def setup
		@temp_file = "arr_dump"
		@input_file = "arr_input"
	end

	def test_addr_mode_immediate
		instr = [0xA9,0xFF,0x6B,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("7F",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x6B,0x40]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x11,0x6B,0x10]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("08",fstring[$a_line].chomp)
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
