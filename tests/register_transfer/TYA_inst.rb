#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class TYATest < Test::Unit::TestCase
	def setup
		@temp_file = "tya_dump"
		@input_file = "tya_input"
	end

	def test_addr_mode_implied
		instr = [0xA0,0x00,0x98,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("00",fstring[$y_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA0,0xC8,0x98,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("C8",fstring[$y_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA0,0x30,0x98,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("30",fstring[$a_line].chomp)
		assert_equal("30",fstring[$y_line].chomp)
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
