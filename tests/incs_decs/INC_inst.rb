require 'test/unit'

class INCTest < Test::Unit::TestCase
	def setup
		@temp_file = "inc_dump"
		@input_file = "inc_input"
	end

	def test_addr_mode_zero_page
		instr = []
		(0..254).each do
			instr.push(0xE6,0x01)
		end
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$m_line].split(" ")[2])
		assert_equal("80",fstring[$status_line].chomp)
	
		instr = []	
		(0..255).each do
			instr.push(0xE6,0x01)
		end
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("02",fstring[$status_line].chomp)
		assert_equal("00",fstring[$m_line].split(" ")[2])
		
		instr = []
		(0..10).each do
			instr.push(0xE6,0x01)
		end
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$status_line].chomp)
		assert_equal("0B",fstring[$m_line].split(" ")[2])
	end
	
	def test_addr_mode_zero_page_x
		instr = [0xA2,0x01]
		(0..254).each do
			instr.push(0xF6,0x00)
		end
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$m_line].split(" ")[2])
		assert_equal("80",fstring[$status_line].chomp)
	
		instr = [0xA2,0x01]	
		(0..255).each do
			instr.push(0xF6,0x00)
		end
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("02",fstring[$status_line].chomp)
		assert_equal("00",fstring[$m_line].split(" ")[2])
		
		instr = [0xA2,0x01]
		(0..10).each do
			instr.push(0xF6,0x00)
		end
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$status_line].chomp)
		assert_equal("0B",fstring[$m_line].split(" ")[2])
	end
	
	def test_addr_mode_absolute
		instr = []
		(0..254).each do
			instr.push(0xEE,0x01,0x00)
		end
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$m_line].split(" ")[2])
		assert_equal("80",fstring[$status_line].chomp)
	
		instr = []	
		(0..255).each do
			instr.push(0xEE,0x01,0x00)
		end
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("02",fstring[$status_line].chomp)
		assert_equal("00",fstring[$m_line].split(" ")[2])
		
		instr = []
		(0..10).each do
			instr.push(0xEE,0x01,0x00)
		end
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$status_line].chomp)
		assert_equal("0B",fstring[$m_line].split(" ")[2])
	end
	
	def test_addr_mode_absolute_x
		instr = [0xA2,0x01]
		(0..254).each do
			instr.push(0xFE,0x00,0x00)
		end
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$m_line].split(" ")[2])
		assert_equal("80",fstring[$status_line].chomp)
	
		instr = [0xA2,0x01]	
		(0..255).each do
			instr.push(0xFE,0x00,0x00)
		end
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("02",fstring[$status_line].chomp)
		assert_equal("00",fstring[$m_line].split(" ")[2])
		
		instr = [0xA2,0x01]
		(0..10).each do
			instr.push(0xFE,0x00,0x00)
		end
		instr.push(0x02)
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("00",fstring[$status_line].chomp)
		assert_equal("0B",fstring[$m_line].split(" ")[2])
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
