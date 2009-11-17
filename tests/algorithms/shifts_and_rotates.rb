require 'test/unit'

class ShiftsAndRotatesTest < Test::Unit::TestCase
	def setup
		@temp_file = "shifts_and_rotates_dump"
		@input_file = "shifts_and_rotates_input"
	end

	def test_16_bit_multiplied_by_2
		instr = [0xA9,0x01,0x85,0x00,0x85,0x01,0x06,0x00,0x26,0x01]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$status_line].chomp)
		assert_equal("02",fstring[$m_line].split(" ")[1])
		assert_equal("02",fstring[$m_line].split(" ")[2])
	end
	
	def test_16_bit_divided_by_2
		instr = [0xA9,0x02,0x85,0x00,0x85,0x01,0x46,0x01,0x66,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$status_line].chomp)
		assert_equal("01",fstring[$m_line].split(" ")[1])
		assert_equal("01",fstring[$m_line].split(" ")[2])
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
