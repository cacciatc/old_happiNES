#compare
require 'test/unit'

class CMPTest < Test::Unit::TestCase
	def setup
		@temp_file = "cmp_dump"
		@input_file = "cmp_input"
	end

	def test_addr_mode_immediate
		instr = [0xA9,0x03,0xC9,0x01]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x03,0xC9,0x03]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$status_line].chomp)

		instr = [0xA9,0x80,0xC9,0x90]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$status_line].chomp)
	end

	def test_addr_mode_zero_page
		instr = [0xA9,0x01,0x85,0x01,0xA9,0x01,0xC5,0x03]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x03,0x85,0x01,0xC5,0x01]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x01,0xA9,0x90,0xC5,0x01]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("81",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_zero_page_x
		instr = [0xA9,0x01,0x85,0x01,0xA9,0x03,0xA2,0x01,0xD5,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x03,0x85,0x01,0xA2,0x01,0xD5,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x01,0xA9,0x90,0xA2,0x01,0xD5,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("81",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute
		instr = [0xA9,0x01,0x85,0x01,0xA9,0x03,0xCD,0x01,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x03,0x85,0x01,0xCD,0x01,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x01,0xA9,0x90,0xCD,0x01,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("81",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_x
		instr = [0xA9,0x01,0x85,0x01,0xA9,0x03,0xA2,0x01,0xDD,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x03,0x85,0x01,0xA2,0x01,0xDD,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x01,0xA9,0x90,0xA2,0x01,0xDD,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("81",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_absolute_y
		instr = [0xA9,0x01,0x85,0x01,0xA9,0x03,0xA0,0x01,0xD9,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x03,0x85,0x01,0xA0,0x01,0xD9,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x01,0xA9,0x90,0xA0,0x01,0xD9,0x00,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("81",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_indirect_x
		instr = [0xA9,0x01,0x85,0x05,0xA9,0x05,0x85,0x06,0xA9,0x03,0xA2,0x02,0xC1,0x04]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x05,0xA9,0x05,0x85,0x06,0xA9,0x00,0xA2,0x03,0xC1,0x03]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x05,0xA9,0x05,0x85,0x06,0xA9,0x90,0xA2,0x06,0xC1,0x00]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("81",fstring[$status_line].chomp)
	end
	
	def test_addr_mode_indirect_y
		instr = [0xA9,0x01,0x85,0x00,0xA9,0x05,0x85,0x06,0xA9,0x03,0xA0,0x00,0xD1,0x05]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("01",fstring[$status_line].chomp)
		
		instr = [0xA9,0x00,0x85,0x00,0xA9,0x05,0x85,0x06,0xA9,0x00,0xA0,0x00,0xD1,0x05]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("03",fstring[$status_line].chomp)
		
		instr = [0xA9,0x80,0x85,0x00,0xA9,0x05,0x85,0x06,0xA9,0x90,0xA0,0x00,0xF1,0x06]
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("80",fstring[$status_line].chomp)
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
