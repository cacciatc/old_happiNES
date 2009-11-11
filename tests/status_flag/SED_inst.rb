require 'test/unit'

class SEDTest < Test::Unit::TestCase
	def setup
		@temp_file = "sed_dump"
		@input_file = "sed_input"
	end

	def test_addr_mode_implied
		instr = [0xD8,0xF8]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("08",fstring[$status_line].chomp)
	
		instr = [0xF8,0xD8,0xF8,0xF8]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("08",fstring[$status_line].chomp)
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
