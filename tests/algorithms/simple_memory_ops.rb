require 'test/unit'

class SimpleMemoryOpsTest < Test::Unit::TestCase
	def setup
		@temp_file = "simple_memory_ops_dump"
		@input_file = "simple_memory_ops_input"
	end

	def test_clear_16_bits_of_memory
		instr = [0xA9,0x00,0x85,0x00,0x85,0x001]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("02",fstring[$status_line].chomp)
		assert_equal("00",fstring[$m_line].split(" ")[1])
		assert_equal("00",fstring[$m_line].split(" ")[2])
	end
	
	def test_clear_32_bits_of_memory
		instr = [0xA9,0x00,0x85,0x00,0x85,0x01,0x85,0x02,0x85,0x03]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("02",fstring[$status_line].chomp)
		assert_equal("00",fstring[$m_line].split(" ")[1])
		assert_equal("00",fstring[$m_line].split(" ")[2])
		assert_equal("00",fstring[$m_line].split(" ")[3])
		assert_equal("00",fstring[$m_line].split(" ")[4])
	end
	
	def test_move_16_bits_of_memory
		instr = [0xA9,0x01,0x85,0x00,0x85,0x001]
		instr2 = [0xA5,0x00,0x85,0x02,0xA5,0x01,0x85,0x03]
		write_input_file(instr + instr2)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$status_line].chomp)
		assert_equal("01",fstring[$m_line].split(" ")[3])
		assert_equal("01",fstring[$m_line].split(" ")[4])
	end
	
	def test_move_32_bits_of_memory
		instr = [0xA9,0x01,0x85,0x00,0x85,0x01,0x85,0x02,0x85,0x03]
		instr2 = [0xA5,0x00,0x85,0x04,0xA5,0x01,0x85,0x05,0xA5,0x02,0x85,0x06,0xA5,0x03,0x85,0x07]
		write_input_file(instr + instr2)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$status_line].chomp)
		assert_equal("01",fstring[$m_line].split(" ")[5])
		assert_equal("01",fstring[$m_line].split(" ")[6])
		assert_equal("01",fstring[$m_line].split(" ")[7])
		assert_equal("01",fstring[$m_line].split(" ")[8])
	end
	
	def test_clear_32_bits_of_memory_iteratively
		i = [0xA9,0x02,0x85,0x1,0x85,0x02,0x85,0x03,0x85,0x04]
		instr = [0xA2,0x03,0xA9,0x00,0x95,0x00,0xCA,0x10,0xFB]
		write_input_file(i + instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$status_line].chomp)
		assert_equal("00",fstring[$m_line].split(" ")[1])
		assert_equal("00",fstring[$m_line].split(" ")[2])
		assert_equal("00",fstring[$m_line].split(" ")[3])
		assert_equal("00",fstring[$m_line].split(" ")[4])
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
