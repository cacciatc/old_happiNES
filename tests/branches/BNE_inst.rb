require 'test/unit'

class BNETest < Test::Unit::TestCase
	def setup
		@temp_file = "bne_dump"
		@input_file = "bne_input"
	end

	def test_addr_mode_relative
		instr = []
		(0..20).each do
			instr.push(0xE8)
		end
		instr[1] = 0xA9
		instr[2] = 0x01
		instr[3] = 0xD0
		instr[4] = 0x01
		instr[5] = 0x02
		instr[6] = 0xA9
		instr[7] = 0x09
		instr[8] = 0x02
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("09",fstring[$a_line].chomp)
	
		instr = []	
		(0..20).each do
			instr.push(0xE8)
		end
		instr[1] = 0xA9
		instr[2] = 0x00
		instr[3] = 0xD0
		instr[4] = 0x01
		instr[5] = 0x02
		instr[6] = 0xA9
		instr[7] = 0x09
		instr[8] = 0x02
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
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
