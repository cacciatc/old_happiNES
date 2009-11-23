#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class LDYTest < Test::Unit::TestCase
	def setup
		@temp_file = "ldy_dump"
		@input_file = "ldy_input"
	end

	def test_addr_mode_immediate
		instr = [0xA0,0xFF,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$y_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA0,0x2F,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("2F",fstring[$y_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)

		instr = [0xA0,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$y_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end

	def test_addr_mode_zero_page
		instr = [0xA0,0x10,0x84,0x55,0xA0,0x00,0xA4,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$y_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA0,0xC8,0x84,0x55,0xA0,0x00,0xA4,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$y_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA0,0x00,0x84,0x55,0xA0,0x00,0xA4,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$y_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_zero_page_x
		instr = [0xA0,0x10,0x84,0x55,0xA0,0x00,0xA2,0x10,0xB4,0x45,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$y_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA0,0xC8,0x84,0x55,0xA0,0x00,0xA2,0x45,0xB4,0x10,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$y_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA0,0x00,0x84,0x55,0xA0,0x00,0xA2,0x55,0xB4,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$y_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute
		instr = [0xA0,0x10,0x84,0x45,0xA0,0x00,0xAC,0x45,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$y_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA0,0xC8,0x84,0x45,0xA0,0x00,0xAC,0x45,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$y_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA0,0x00,0x84,0x45,0xA0,0x00,0xAC,0x45,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$y_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_x
		instr = [0xA0,0x10,0x84,0x45,0xA0,0x00,0xA2,0x10,0xBC,0x35,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$y_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA0,0xC8,0x84,0x45,0xA0,0x00,0xA2,0x10,0xBC,0x35,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$y_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA0,0x00,0x84,0x45,0xA0,0x00,0xA2,0x10,0xBC,0x35,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$y_line].chomp)
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
