require 'test/unit'

class AdditionAndSubtractionTest < Test::Unit::TestCase
	def setup
		@temp_file = "addition_and_subtraction_dump"
		@input_file = "addition_and_subtraction_input"
	end

	def test_16_bit_binary_addition
		#clear carry and place 0x0501 and 0x0101
		instr = [0x18,0xA9,0x01,0x85,0x00,0xA9,0x05,0x85,0x01,0xA9,0x01,0x85,0x02,0x85,0x03]
		i = [0xA5,0x00,0x65,0x02,0x85,0x04,0xA5,0x01,0x65,0x03,0x85,0x05]
		write_input_file(instr + i)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$status_line].chomp)
		assert_equal("02",fstring[$m_line].split(" ")[5])
		assert_equal("06",fstring[$m_line].split(" ")[6])
	end
	
	def test_16_bit_binary_subtraction
		#set carry and place 0x0501 and 0x0101
		instr = [0x38,0xA9,0x01,0x85,0x00,0xA9,0x05,0x85,0x01,0xA9,0x01,0x85,0x02,0x85,0x03]
		i = [0xA5,0x00,0xE5,0x02,0x85,0x04,0xA5,0x01,0xE5,0x03,0x85,0x05]
		write_input_file(instr + i)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$status_line].chomp)
		assert_equal("00",fstring[$m_line].split(" ")[5])
		assert_equal("04",fstring[$m_line].split(" ")[6])
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
