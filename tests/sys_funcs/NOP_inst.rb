#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class NOPTest < Test::Unit::TestCase
	def setup
		@temp_file = "nop_dump"
		@input_file = "nop_input"
	end

	def test_addr_mode_general
		instr = [0x1A,0xA2,0x01,0x02,0xA2,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$x_line].chomp)
		
		instr = [0x3A,0xA2,0x01,0x12,0xA2,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$x_line].chomp)
		
		instr = [0x5A,0xA2,0x01,0x22,0xA2,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$x_line].chomp)
		
		instr = [0x7A,0xA2,0x01,0x32,0xA2,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$x_line].chomp)
		
		instr = [0xDA,0xA2,0x01,0x42,0xA2,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$x_line].chomp)
		
		instr = [0xFA,0xA2,0x01,0x52,0xA2,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$x_line].chomp)
		
		instr = [0xEA,0xA2,0x01,0x62,0xA2,0x02]
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
