require 'test/unit'

class JMPTest < Test::Unit::TestCase
	def setup
		@temp_file = "jmp_dump"
		@input_file = "jmp_input"
	end

	def test_addr_mode_absolute
		instr = []
		(0..99).each do
			instr.push(0xE8)
		end
		instr[2] = 0x4C
		instr[3] = 0x60 
		instr[4] = 0x00
		instr[100] = 0x02; 
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("06",fstring[$x_line].chomp)
	
		instr = []	
		(0..255).each do
			instr.push(0xE8)
		end
		instr[2] = 0x4C
		instr[3] = 0xFF 
		instr[4] = 0x00 
		instr[256] = 0x02
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$x_line].chomp)
	end
	
	def test_addr_mode_indirect
		instr = [0xA9,0x0B,0x85,0x09]
		(0..10).each do
			instr.push(0xE8)
		end
		instr[2+3] = 0x6C
		instr[3+3] = 0x09
		instr[4+3] = 0x00
		instr[15] = 0x02
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("05",fstring[$x_line].chomp)
		
		instr = [0xA9,0x0B,0x85,0x09]
		(0..300).each do
			instr.push(0xE8)
		end
		instr[2+3] = 0x6C
		instr[3+3] = 0x09
		instr[4+3] = 0x00
		instr[15] = 0xA9
		instr[16] = 0x09
		instr[17] = 0x4C
		instr[18] = 0x01
		instr[19] = 0x01
		instr[257] = 0xA0
		instr[258] = 0x05 
		instr[259] = 0x02
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("09",fstring[$a_line].chomp)
		assert_equal("05",fstring[$y_line].chomp)
		assert_equal("05",fstring[$x_line].chomp)
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
