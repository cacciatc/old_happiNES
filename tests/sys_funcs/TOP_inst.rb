#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class TOPTest < Test::Unit::TestCase
	def setup
		@temp_file = "top_dump"
		@input_file = "top_input"
	end

	def test_addr_mode_general
		instr = [0x0C,0x00,0x00,0xA2,0x01,0x12,0xA2,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$x_line].chomp)
		
		instr = [0x1C,0x00,0x00,0xA2,0x01,0x12,0xA2,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$x_line].chomp)
		
		instr = [0x3C,0x00,0x00,0xA2,0x01,0x22,0xA2,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$x_line].chomp)
		
		instr = [0x5C,0x00,0x00,0xA2,0x01,0x32,0xA2,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$x_line].chomp)
		
		instr = [0x7C,0x00,0x00,0xA2,0x01,0x42,0xA2,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$x_line].chomp)
		
		instr = [0xDC,0x00,0x00,0xA2,0x01,0x52,0xA2,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$x_line].chomp)
		
		instr = [0xFC,0x00,0x00,0xA2,0x01,0x62,0xA2,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$x_line].chomp)
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
