require 'test/unit'

class NegationTest < Test::Unit::TestCase
	def setup
		@temp_file = "negation_dump"
		@input_file = "negation_input"
	end

	def test_8_bit_negation
		instr = [0x18,0xA9,0x01,0x49,0xFF,0x69,0x01,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("81",fstring[$status_line].chomp)
		assert_equal("FF",fstring[$a_line].chomp)
	end
	
	def test_16_bit_negation
		instr = [0xA9,0x01,0x85,0x00,0x85,0x01]
		i = [0x38,0xA9,0x00,0xE5,0x00,0x85,0x02,0xA9,0x00,0xE5,0x01,0x85,0x03,0x02]
		write_input_file(instr + i)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C1",fstring[$status_line].chomp)
		assert_equal("FF",fstring[$m_line].split(" ")[3])
		assert_equal("FF",fstring[$m_line].split(" ")[4])
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
