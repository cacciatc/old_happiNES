require 'test/unit'

class BRKTest < Test::Unit::TestCase
	def setup
		@temp_file = "brk_dump"
		@input_file = "brk_input"
	end

	def test_addr_mode_implied
		instr = [0xA9,0x07,0x8D,0xFE,0xFF,0x00,0x02,0x40,0xE8,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$x_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
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
