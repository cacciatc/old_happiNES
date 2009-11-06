#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class AXATest < Test::Unit::TestCase
	def setup
		@temp_file = "axa_dump"
		@input_file = "axa_input"
	end

	def test_addr_mode_absolute_y
		instr = [0xA9,0x77,0xA2,0x07,0xA0,0x00,0x9F,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("07",fstring[$m_line].split(" ")[1])
		
		instr = [0xA9,0x00,0xA2,0x40,0xA0,0x00,0x9F,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$m_line].split(" ")[1])
	end
	
	def test_addr_mode_indirect_y
		instr = [0xA9,0x77,0xA2,0x07,0xA0,0x00,0x93,0x07]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("07",fstring[$m_line].split(" ")[8])
		
		instr = [0xA9,0x00,0xA2,0x40,0xA0,0x00,0x93,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$m_line].split(" ")[1])
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
