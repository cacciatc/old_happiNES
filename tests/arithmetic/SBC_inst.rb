#subtract with carry
require 'test/unit'

class SBCTest < Test::Unit::TestCase
	def setup
		@temp_file = "sbc_dump"
		@input_file = "sbc_input"
	end

	def test_addr_mode_immediate
		instr = [0xA9,0x01,0xE9,0x03]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$a_line].chomp)
		assert_equal("C0",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0xE9,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)

		instr = [0xA9,0x90,0xE9,0x80]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("11",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
	end

	def test_addr_mode_zero_page
		instr = [0xA9,0x03,0x85,0x01,0xA9,0x01,0xE5,0x01]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$a_line].chomp)
		assert_equal("C0",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0xE5,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x01,0xA9,0x90,0xE5,0x01]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("11",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_zero_page_x
		instr = [0xA9,0x03,0x85,0x01,0xA9,0x01,0xA2,0x01,0xF5,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$a_line].chomp)
		assert_equal("C0",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0xA2,0x00,0xF5,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x01,0xA9,0x90,0xA2,0x01,0xF5,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("11",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute
		instr = [0xA9,0x03,0x85,0x01,0xA9,0x01,0xED,0x01,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$a_line].chomp)
		assert_equal("C0",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x01,0xED,0x01,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x01,0xA9,0x90,0xED,0x01,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("11",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_x
		instr = [0xA9,0x03,0x85,0x01,0xA9,0x01,0xA2,0x01,0xFD,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$a_line].chomp)
		assert_equal("C0",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x01,0xA2,0x01,0xFD,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x01,0xA9,0x90,0xA2,0x01,0xFD,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("11",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_y
		instr = [0xA9,0x03,0x85,0x01,0xA9,0x01,0xA0,0x01,0xF9,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$a_line].chomp)
		assert_equal("C0",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x01,0xA0,0x01,0xF9,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x01,0xA9,0x90,0xA0,0x01,0xF9,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("11",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_indirect_x
		instr = [0xA9,0x02,0x85,0x05,0xA9,0x05,0x85,0x06,0xA9,0x01,0xA2,0x02,0xE1,0x04]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x05,0xA9,0x05,0x85,0x06,0xA9,0x00,0xA2,0x03,0xE1,0x03]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x05,0xA9,0x05,0x85,0x06,0xA9,0x01,0xA2,0x06,0xE1,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("82",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_indirect_y
		instr = [0xA9,0x02,0x85,0x00,0xA9,0x05,0x85,0x06,0xA9,0x01,0xA0,0x00,0xF1,0x05]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x00,0xA9,0x05,0x85,0x06,0xA9,0x00,0xA0,0x00,0xF1,0x05]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$a_line].chomp)
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x00,0xA9,0x05,0x85,0x06,0xA9,0x01,0xA0,0x00,0xF1,0x05]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("82",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
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
