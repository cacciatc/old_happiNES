#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class AXSTest < Test::Unit::TestCase
	def setup
		@temp_file = "axs_dump"
		@input_file = "axs_input"
	end

	def test_addr_mode_immediate
		instr = [0xA9,0x77,0xA2,0x07,0xCB,0x01]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("06",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0xA2,0x40,0xCB,0x01]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$x_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0xA2,0x00,0xCB,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$x_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def teardown
		system("rm #{@input_file} #{@temp_file}")
	end

	def write_input_file(instr)
		f = File.new(@input_file,"wb")
		f.write(instr.pack("C*"))
		f.close
	end
end
