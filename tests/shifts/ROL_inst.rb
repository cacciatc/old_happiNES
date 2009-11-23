require 'test/unit'

class ROLTest < Test::Unit::TestCase
	def setup
		@temp_file = "rol_dump"
		@input_file = "rol_input"
	end

	def test_addr_mode_accumulator
		instr = [0xA9,0xFF,0x2A]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FE",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0x38,0xA9,0xFF,0x2A]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0xA9,0x04,0x2A]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("08",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)

		instr = [0xA9,0x00,0x2A]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end

	def test_addr_mode_zero_page
		instr = [0xA9,0xFF,0x85,0x55,0xA9,0x00,0x26,0x55,0xA5,0x55]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FE",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0x38,0xA9,0xFF,0x85,0x55,0xA9,0x00,0x26,0x55,0xA5,0x55]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0xA9,0x04,0x85,0x55,0xA9,0x00,0x26,0x55,0xA5,0x55]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("08",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x55,0xA9,0x00,0x26,0x55,0xA5,0x55]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_zero_page_x
		instr = [0xA9,0xFF,0x85,0x55,0xA9,0x00,0xA2,0x10,0x36,0x45,0xA5,0x55]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FE",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0x38,0xA9,0xFF,0x85,0x55,0xA9,0x00,0xA2,0x10,0x36,0x45,0xA5,0x55]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0xA9,0x04,0x85,0x55,0xA9,0x00,0xA2,0x10,0x36,0x45,0xA5,0x55]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("08",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x55,0xA9,0x00,0xA2,0x10,0x36,0x45,0xA5,0x55]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end

	def test_addr_mode_absolute
		instr = [0xA9,0xFF,0x85,0x45,0xA9,0x00,0x2E,0x45,0x00,0xA5,0x45]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FE",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0x38,0xA9,0xFF,0x85,0x45,0xA9,0x00,0x2E,0x45,0x00,0xA5,0x45]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0xA9,0x04,0x85,0x45,0xA9,0x00,0x2E,0x45,0x00,0xA5,0x45]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("08",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x45,0xA9,0x00,0x2E,0x45,0x00,0xA5,0x45]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_x
		instr = [0xA9,0xFF,0x85,0x45,0xA9,0x00,0xA2,0x10,0x3E,0x35,0x00,0xA5,0x45]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FE",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0x38,0xA9,0xFF,0x85,0x45,0xA9,0x00,0xA2,0x10,0x3E,0x35,0x00,0xA5,0x45]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0xA9,0x04,0x85,0x45,0xA9,0x00,0xA2,0x10,0x3E,0x35,0x00,0xA5,0x45]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("08",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x45,0xA9,0x00,0xA2,0x10,0x3E,0x35,0x00,0xA5,0X45]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
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
