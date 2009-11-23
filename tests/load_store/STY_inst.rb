#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class STYTest < Test::Unit::TestCase
	def setup
		@temp_file = "sty_dump"
		@input_file = "sty_input"
	end

	def test_addr_mode_zero_page
		instr = [0xA0,0x30,0x84,0xFF,0xA0,0x00,0xA4,0xFF,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("30",fstring[$y_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_zero_page_x
		instr = [0xA0,0x30,0xA2,0x11,0x94,0xEE,0xA0,0x00,0xA4,0xFF,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("30",fstring[$y_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end

	def test_addr_mode_absolute
		instr = [0xA0,0x30,0x8C,0xFF,0x00,0xA0,0x00,0xA4,0xFF,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
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
