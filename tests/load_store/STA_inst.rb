#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class STATest < Test::Unit::TestCase
	def setup
		@temp_file = "sta_dump"
		@input_file = "sta_input"
	end

	def test_addr_mode_zero_page
		instr = [0xA9,0x30,0x85,0xFF,0xA9,0x00,0xA5,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("30",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_zero_page_x
		instr = [0xA9,0x30,0xA2,0x11,0x95,0xEE,0xA9,0x00,0xA5,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("30",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end

	def test_addr_mode_absolute
		instr = [0xA9,0x30,0x8D,0xFF,0x00,0xA9,0x00,0xA5,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("30",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_x
		instr = [0xA9,0x30,0xA2,0x11,0x9D,0xEE,0x00,0xA9,0x00,0xA5,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("30",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_y
		instr = [0xA9,0x30,0xA0,0x11,0x99,0xEE,0x00,0xA9,0x00,0xA5,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("30",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_indirect_x
		instr = [0xA9,0x30,0xA2,0xFF,0x81,0x00,0xA9,0x00,0xA5,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("30",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
	end

	def test_addr_mode_indirect_y
		instr = [0xA9,0xFF,0x85,0xFF,0xA9,0x30,0xA0,0x00,0x91,0xFF,0xA9,0x00,0xA5,0xFF]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("30",fstring[$a_line].chomp)
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
