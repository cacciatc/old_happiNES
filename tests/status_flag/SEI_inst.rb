require 'test/unit'

class SEITest < Test::Unit::TestCase
	def setup
		@temp_file = "sei_dump"
		@input_file = "sei_input"
	end

	def test_addr_mode_implied
		instr = [0x58,0x78]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("04",fstring[$status_line].chomp)
	
		instr = [0x78,0x58,0x78,0x78]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("04",fstring[$status_line].chomp)
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