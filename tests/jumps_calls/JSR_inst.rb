require 'test/unit'

class JSRTest < Test::Unit::TestCase
	def setup
		@temp_file = "jsr_dump"
		@input_file = "jsr_input"
	end

	def test_addr_mode_absolute
		instr = []
		(0..99).each do
			instr.push(0xE8)
		end
		instr[2] = 0x20
		instr[3] = 0x60 
		instr[4] = 0x00
		instr[5] = 0x02
		instr[98] = 0x60;
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("04",fstring[$x_line].chomp)
	
		instr = []	
		(0..255).each do
			instr.push(0xE8)
		end
		instr[2] = 0x20
		instr[3] = 0x60
		instr[4] = 0x00
		instr[5] = 0x02
		instr[98] = 0x20
		instr[99] = 0x70
		instr[100] = 0x00
 		instr[101] = 0x60 
		instr[112] = 0x60
		write_input_file(instr)
	#	system(".././2a03 #{@input_file} #{@temp_file}")
	#	f = File.new(@temp_file)
	#	fstring = f.readlines
	#	f.close
	#	assert_equal("04",fstring[$x_line].chomp)
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
