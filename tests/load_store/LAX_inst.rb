#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class LAXTest < Test::Unit::TestCase
	def setup
		@temp_file = "lax_dump"
		@input_file = "lax_input"
	end

	def test_addr_mode_zero_page
		instr = [0xA9,0x10,0x85,0x55,0xA9,0x00,0xA7,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
		assert_equal("10",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0xC8,0x85,0x55,0xA9,0x00,0xA7,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("C8",fstring[$x_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x55,0xA9,0x00,0xA7,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("00",fstring[$x_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_zero_page_y
		instr = [0xA9,0x10,0x85,0x55,0xA9,0x00,0xA0,0x10,0xB7,0x45,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
		assert_equal("10",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0xC8,0x85,0x55,0xA9,0x00,0xA0,0x45,0xB7,0x10,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("C8",fstring[$x_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x55,0xA9,0x00,0xA0,0x55,0xB7,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("00",fstring[$x_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute
		instr = [0xA9,0x10,0x85,0x45,0xA9,0x00,0xAF,0x45,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
		assert_equal("10",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0xC8,0x85,0x45,0xA9,0x00,0xAF,0x45,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("C8",fstring[$x_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x45,0xA9,0x00,0xAF,0x45,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("00",fstring[$x_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_y
		instr = [0xA9,0x10,0x85,0x45,0xA9,0x00,0xA0,0x10,0xBF,0x35,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
		assert_equal("10",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0xC8,0x85,0x45,0xA9,0x00,0xA0,0x10,0xBF,0x35,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("C8",fstring[$x_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x45,0xA9,0x00,0xA0,0x10,0xBF,0x35,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("00",fstring[$x_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_indirect_x
		instr = [0xA9,0x10,0x85,0x10,0xA9,0x00,0xA2,0x10,0xA3,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
		assert_equal("10",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0xC8,0x85,0xC8,0xA9,0x00,0xA2,0xC8,0xA3,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("C8",fstring[$x_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x00,0xA9,0x00,0xA2,0x00,0xA3,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("00",fstring[$x_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
		
	def test_addr_mode_indirect_y
		instr = [0xA9,0x10,0x85,0x10,0xA9,0x00,0xA0,0x00,0xB3,0x10,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
		assert_equal("10",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0xC8,0x85,0xC8,0xA9,0x00,0xA0,0x00,0xB3,0xC8,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("C8",fstring[$x_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x00,0xA9,0x00,0xA0,0x00,0xB3,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
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
