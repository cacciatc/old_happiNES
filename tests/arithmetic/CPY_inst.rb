#compare
require 'test/unit'

class CPYTest < Test::Unit::TestCase
	def setup
		@temp_file = "cpy_dump"
		@input_file = "cpy_input"
	end

	def test_addr_mode_immediate
		instr = [0xA0,0x03,0xC0,0x01]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA0,0x03,0xC0,0x03]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$status_line].chomp)

		instr = [0xA0,0x80,0xC0,0x90]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$status_line].chomp)
	end

	def test_addr_mode_zero_page
		instr = [0xA0,0x01,0x84,0x01,0xA9,0x01,0xC4,0x03]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA0,0x03,0x84,0x01,0xC4,0x01]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$status_line].chomp)
		
		instr = [0xA0,0x80,0x84,0x01,0xA0,0x90,0xC4,0x01]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("81",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute
		instr = [0xA0,0x01,0x84,0x01,0xA0,0x03,0xCC,0x01,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA0,0x03,0x84,0x01,0xCC,0x01,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$status_line].chomp)
		
		instr = [0xA0,0x80,0x84,0x01,0xA0,0x90,0xCC,0x01,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("81",fstring[$status_line].chomp)
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
