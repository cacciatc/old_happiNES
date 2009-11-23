require 'test/unit'

class PLPTest < Test::Unit::TestCase
	def setup
		@temp_file = "plp_dump"
		@input_file = "plp_input"
	end

	def test_addr_mode_implied
		instr = [0xA9,0xC8,0x08,0xA9,0x01,0x28,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$s_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x08,0xA9,0x01,0x28,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$s_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x01,0x08,0xA9,0xC8,0x28,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$s_line].chomp)
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
