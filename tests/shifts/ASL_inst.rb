require 'test/unit'

class ASLTest < Test::Unit::TestCase
	def setup
		@temp_file = "asl_dump"
		@input_file = "asl_input"
	end

	def test_addr_mode_accumulator
		instr = [0xA9,0xFF,0x0A]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FE",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0xA9,0x2F,0x0A]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("5E",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)

		instr = [0xA9,0x00,0x0A]
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
		instr = [0xA9,0xFF,0x85,0x55,0xA9,0x00,0x06,0x55,0xA5,0x55]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FE",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0xA9,0x2F,0x85,0x55,0xA9,0x00,0x06,0x55,0xA5,0x55]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("5E",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x55,0xA9,0x00,0x06,0x55,0xA5,0x55]
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
		instr = [0xA9,0xFF,0x85,0x55,0xA9,0x00,0xA2,0x10,0x16,0x45,0xA5,0x55]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FE",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0xA9,0x2F,0x85,0x55,0xA9,0x00,0xA2,0x10,0x16,0x45,0xA5,0x55]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("5E",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x55,0xA9,0x00,0xA2,0x10,0x16,0x45,0xA5,0x55]
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
		instr = [0xA9,0xFF,0x85,0x45,0xA9,0x00,0x0E,0x45,0x00,0xA5,0x45]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FE",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0xA9,0x2F,0x85,0x45,0xA9,0x00,0x0E,0x45,0x00,0xA5,0x45]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("5E",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x45,0xA9,0x00,0x0E,0x45,0x00,0xA5,0x45]
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
		instr = [0xA9,0xFF,0x85,0x45,0xA9,0x00,0xA2,0x10,0x1E,0x35,0x00,0xA5,0x45]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FE",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
		
		instr = [0xA9,0x2F,0x85,0x45,0xA9,0x00,0xA2,0x10,0x1E,0x35,0x00,0xA5,0x45]
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("5E",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x45,0xA9,0x00,0xA2,0x10,0x1E,0x35,0x00,0xA5,0x45]
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
