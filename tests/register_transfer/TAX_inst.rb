#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class TAXTest < Test::Unit::TestCase
	def setup
		@temp_file = "tax_dump"
		@input_file = "tax_input"
	end

	def test_addr_mode_implied
		instr = [0xA9,0x00,0xAA]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("00",fstring[$x_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0xC8,0xAA]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("C8",fstring[$x_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x30,0xAA]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("30",fstring[$a_line].chomp)
		assert_equal("30",fstring[$x_line].chomp)
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
