#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class LDXTest < Test::Unit::TestCase
	def setup
		@temp_file = "ldx_dump"
		@input_file = "ldx_input"
	end

	def test_addr_mode_immediate
		instr = [0xA2,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$x_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA2,0x2F]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("2F",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)

		instr = [0xA2,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$x_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end

	def test_addr_mode_zero_page
		instr = [0xA2,0x10,0x86,0x55,0xA2,0x00,0xA6,0x55]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA2,0xC8,0x86,0x55,0xA2,0x00,0xA6,0x55]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$x_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA2,0x00,0x86,0x55,0xA2,0x00,0xA6,0x55]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$x_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_zero_page_y
		instr = [0xA2,0x10,0x86,0x55,0xA2,0x00,0xA0,0x10,0xB6,0x45]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA2,0xC8,0x86,0x55,0xA2,0x00,0xA0,0x45,0xB6,0x10]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$x_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA2,0x00,0x86,0x55,0xA2,0x00,0xA0,0x55,0xB6,0x55]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$x_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute
		instr = [0xA2,0x10,0x86,0x45,0xA2,0x00,0xAE,0x45,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA2,0xC8,0x86,0x45,0xA2,0x00,0xAE,0x45,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$x_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA2,0x00,0x86,0x45,0xA2,0x00,0xAE,0x45,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$x_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_y
		instr = [0xA2,0x10,0x86,0x45,0xA2,0x00,0xA0,0x10,0xBE,0x35,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA2,0xC8,0x86,0x45,0xA2,0x00,0xA0,0x10,0xBE,0x35,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$x_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA2,0x00,0x86,0x45,0xA2,0x00,0xA0,0x10,0xBE,0x35,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$x_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
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
