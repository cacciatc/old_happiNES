#test wrap around for both status and accumulator stack ops
require 'test/unit'

class StackSpecificTest < Test::Unit::TestCase
	def setup
		@temp_file = "stack_specific_dump"
		@input_file = "stack_specific_input"
	end

	def test_PLA_PHA
		instr = []
		#place a value in acc and push it
		(0..255).each do |i|
			instr.push(0xA9)
			instr.push(i)
			instr.push(0x48)
		end
		instr.push(0xA9)
		instr.push(0x02)
		instr.push(0x48)
		
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FE",fstring[$s_line].chomp)
		assert_equal("02",fstring[$stop_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
		
		instr = []
		#place a value in acc and push it
		(0..255).each do |i|
			instr.push(0xA9)
			instr.push(i)
			instr.push(0x48)
		end
		instr.push(0xA9)
		instr.push(0xC8)
		instr.push(0x48)
		(0..256).each do |i|
			instr.push(0x68)
		end
		
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$s_line].chomp)
		assert_equal("00",fstring[$stop_line].chomp)
		assert_equal("80",fstring[$status_line].chomp)
	end
	
	def test_PLP_PHP
		instr = []
		#place a value in acc and push it
		(0..255).each do |i|
			instr.push(0xA9)
			instr.push(0xC8)
			instr.push(0x08)
		end
		instr.push(0xA9)
		instr.push(0x00)
		instr.push(0x08)
		
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FE",fstring[$s_line].chomp)
		assert_equal("02",fstring[$stop_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
		
		instr = []
		#place a value in acc and push it
		(0..255).each do |i|
			instr.push(0xA9)
			instr.push(0xC8)
			instr.push(0x08)
		end
		instr.push(0xA9)
		instr.push(0x00)
		instr.push(0x08)
		(0..256).each do |i|
			instr.push(0x28)
		end
		
		write_input_file(instr)
		system(".././2a03 #{@input_file} #{@temp_file}")
		f = File.new(@temp_file)
		fstring = f.readlines
		f.close
		assert_equal("FF",fstring[$s_line].chomp)
		assert_equal("00",fstring[$stop_line].chomp)
		assert_equal("02",fstring[$status_line].chomp)
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
