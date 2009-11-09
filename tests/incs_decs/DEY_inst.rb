require 'test/unit'

class DEYTest < Test::Unit::TestCase
	def setup
		@temp_file = "dey_dump"
		@input_file = "dey_input"
	end

	def test_addr_mode_implied
		instr = []
		(0..255).each do
			instr.push(0x88)
		end
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$y_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	
		instr = []	
		(0..129).each do
			instr.push(0x88)
		end
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$status_line].chomp)
		assert_equal("7E",fstring[$y_line].chomp)
		
		instr = []
		(0..10).each do
			instr.push(0x88)
		end
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$status_line].chomp)
		assert_equal("F5",fstring[$y_line].chomp)
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
