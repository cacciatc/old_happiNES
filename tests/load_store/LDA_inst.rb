#NOTE: for each test, there are generally 3 assertions: normal, test for negative flag, and test for zero flag
require 'test/unit'

class LDATest < Test::Unit::TestCase
	def setup
		@temp_file = "lda_dump"
		@input_file = "lda_input"
	end

	def test_addr_mode_immediate
		instr = [0xA9,0xFF,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x2F,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("2F",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)

		instr = [0xA9,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end

	def test_addr_mode_zero_page
		#load 0x10 into accum and then store at 0x55 and then load into accum
		instr = [0xA9,0x10,0x85,0x55,0xA9,0x00,0xA5,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0xC8,0x85,0x55,0xA9,0x00,0xA5,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x55,0xA9,0x00,0xA5,0x55,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_zero_page_x
		#load 0x10 into accum and then x and then store at 0x55 and then load into accum
		instr = [0xA9,0x10,0x85,0x55,0xA9,0x00,0xA2,0x10,0xB5,0x45,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0xC8,0x85,0x55,0xA9,0x00,0xA2,0x10,0xB5,0x45,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x55,0xA9,0x00,0xA2,0x10,0xB5,0x45,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end

	def test_addr_mode_absolute
		instr = [0xA9,0x10,0x85,0x45,0xA9,0x00,0xAD,0x45,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
		
		instr = [0xA9,0xC8,0x85,0x45,0xA9,0x00,0xAD,0x45,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x45,0xA9,0x00,0xAD,0x45,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_x
		instr = [0xA9,0x10,0x85,0x45,0xA9,0x00,0xA2,0x10,0xBD,0x35,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0xC8,0x85,0x45,0xA9,0x00,0xA2,0x10,0xBD,0x35,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x45,0xA9,0x00,0xA2,0x10,0xBD,0x35,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_y
		instr = [0xA9,0x10,0x85,0x45,0xA9,0x00,0xA0,0x10,0xB9,0x35,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0xC8,0x85,0x45,0xA9,0x00,0xA0,0x10,0xB9,0x35,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x45,0xA9,0x00,0xA0,0x10,0xB9,0x35,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_indirect_x
		instr = [0xA9,0x10,0x85,0x00,0xA9,0x00,0xA2,0x0C,0xA1,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
		assert_equal("00",fstring[$status_line].chomp)
		
		instr = [0xA9,0xC8,0x85,0x00,0xA9,0x00,0xA2,0x99,0xA1,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("C8",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x00,0xA9,0x00,0xA2,0x99,0xA1,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
	end

	def test_addr_mode_indirect_y
		instr = [0xA9,0x99,0x85,0x99,0xA9,0x00,0xB1,0x99,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("99",fstring[$a_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x00,0xA9,0x00,0xB1,0x00,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$a_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = [0xA9,0x10,0x85,0x10,0xA9,0x00,0xB1,0x10,0x02]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("10",fstring[$a_line].chomp)
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
