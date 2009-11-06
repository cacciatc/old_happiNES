#add with carry
require 'test/unit'

class ADCTest < Test::Unit::TestCase
	def setup
		@temp_file = "adc_dump"
		@input_file = "adc_input"
	end

	def test_addr_mode_immediate
		instr = [0xA9,0x01,0x69,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x69,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)

		instr = [0xA9,0x00,0x69,0x80]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
	end

	def test_addr_mode_zero_page
		instr = [0xA9,0x02,0x85,0x05,0xA9,0x01,0x65,0x05]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x05,0xA9,0x00,0x65,0x05]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x05,0xA9,0x01,0x65,0x05]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("81",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_zero_page_x
		instr = [0xA9,0x02,0x85,0x05,0xA9,0x01,0xA2,0x01,0x75,0x04]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x05,0xA9,0x00,0xA2,0x02,0x75,0x03]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x05,0xA9,0x01,0xA2,0x03,0x75,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("81",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute
		instr = [0xA9,0x02,0x85,0x05,0xA9,0x01,0x6D,0x00,0x05]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x05,0xA9,0x00,0x6D,0x00,0x05]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x05,0xA9,0x01,0x6D,0x00,0x05]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("81",fstring[$a_line].chomp)
		assert_equal("81",fstring[$status_line].chomp)
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
