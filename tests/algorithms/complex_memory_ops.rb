require 'test/unit'

class ComplexMemoryOpsTest < Test::Unit::TestCase
	def setup
		@temp_file = "complex_memory_ops_dump"
		@input_file = "complex_memory_ops_input"
	end

	def test_move_5_bytes_forward_max_256
		instr = [0xA9,0xFF,0x85,0x00,0x85,0x01]
		instr = instr + [0xA2,0x00,0xB5,0x00,0x95,0x02,0xE8,0xE0,0x02,0xD0,0xF9,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("83",fstring[$status_line].chomp)
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
