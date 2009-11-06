#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class ANDTest < Test::Unit::TestCase
	def setup
		@temp_file = "and_dump"
		@input_file = "and_input"
	end

	def test_addr_mode_immediate
		instr = [0xA9,0x80,0x29,0x80]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x29,0x08]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)

		instr = [0xA9,0x11,0x29,0x01]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end

	def test_addr_mode_zero_page
		instr = [0xA9,0x80,0x85,0x55,0x25,0x55]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x08,0x85,0x55,0xA9,0x80,0x25,0x55]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x11,0x85,0x55,0xA9,0x01,0x25,0x55]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_zero_page_x
		#load 0x10 into accum and then x and then store at 0x55 and then load into accum
		instr = [0xA9,0x80,0x85,0x55,0xA2,0x10,0x35,0x45]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x08,0x85,0x55,0xA9,0x80,0xA2,0x10,0x35,0x45]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x11,0x85,0x55,0xA9,0x01,0xA2,0x10,0x35,0x45]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end

	def test_addr_mode_absolute
		instr = [0xA9,0x80,0x85,0x45,0x2D,0x45,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x08,0x85,0x45,0xA9,0x80,0x2D,0x45,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x11,0x85,0x45,0xA9,0x01,0x2D,0x45,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_x
		instr = [0xA9,0x80,0x85,0x45,0xA2,0x10,0x3D,0x35,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x08,0x85,0x45,0xA9,0x80,0xA2,0x10,0x3D,0x35,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x11,0x85,0x45,0xA9,0x01,0xA2,0x10,0x3D,0x35,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_y
		instr = [0xA9,0x80,0x85,0x45,0xA0,0x10,0x39,0x35,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x08,0x85,0x45,0xA9,0x80,0xA0,0x10,0x39,0x35,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x11,0x85,0x45,0xA9,0x01,0xA0,0x10,0x39,0x35,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_indirect_x
		instr = [0xA9,0x80,0x85,0x80,0xA2,0x00,0x21,0x80]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x08,0x85,0x08,0xA9,0x80,0xA2,0x00,0x21,0x08]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x11,0x85,0x11,0xA9,0x01,0xA2,0x00,0x21,0x11]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end

	def test_addr_mode_indirect_y
		instr = [0xA9,0x80,0x85,0x80,0xA0,0x00,0x31,0x80]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x08,0x85,0x00,0xA9,0x00,0x31,0x08]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x11,0x85,0x11,0xA9,0x01,0x31,0x11]
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
