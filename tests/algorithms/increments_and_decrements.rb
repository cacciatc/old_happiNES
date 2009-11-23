require 'test/unit'

class IncrementsAndDecrementsTest < Test::Unit::TestCase
	def setup
		@temp_file = "increments_and_decrements_dump"
		@input_file = "increments_and_decrements_input"
	end

	def test_16_bit_increment
		instr = [0xA9,0xFF,0x85,0x00]
		instr = instr + [0xE6,0x00,0xD0,0x02,0xE6,0x01,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$status_line].chomp)
		assert_equal("00",fstring[$m_line].split(" ")[1])
		assert_equal("01",fstring[$m_line].split(" ")[2])
	end
	
	def test_16_bit_decrement
		instr = [0xA9,0x00,0x85,0x00]
		instr = instr + [0xC6,0x00,0xD0,0x00,0xC6,0x01,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$status_line].chomp)
		assert_equal("FF",fstring[$m_line].split(" ")[1])
		assert_equal("FF",fstring[$m_line].split(" ")[2])
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
