#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class BITTest < Test::Unit::TestCase
	def setup
		@temp_file = "bit_dump"
		@input_file = "bit_input"
	end

	def test_addr_mode_zero_page
		instr = [0xA9,0xC0,0x85,0x55,0xA9,0xCC,0x24,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("CC",fstring[$a_line].chomp)
		assert_equal("C0",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x55,0xA9,0x00,0x24,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x11,0x85,0x55,0xA9,0x01,0x24,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute
		instr = [0xA9,0xC0,0x85,0x45,0xA9,0xCC,0x2C,0x45,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("CC",fstring[$a_line].chomp)
		assert_equal("C0",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x45,0xA9,0x00,0x2C,0x45,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x11,0x85,0x45,0xA9,0x01,0x2C,0x45,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
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
