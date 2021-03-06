/*
**  happiNES - A NES emulator written in C++.
**  
**  Copyright (c) 2009 Dullahan Games
**
**  This file is part of happiNES.
**
**  MIT License
**  
**  Permission is hereby granted, free of charge, to any person obtaining a copy
**  of this software and associated documentation files (the "Software"), to deal
**  in the Software without restriction, including without limitation the rights
**  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
**  copies of the Software, and to permit persons to whom the Software is
**  furnished to do so, subject to the following conditions:
**  
**  The above copyright notice and this permission notice shall be included in
**  all copies or substantial portions of the Software.
**  
**  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
**  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
**  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
**  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
**  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
**  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
**  THE SOFTWARE.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ines.h"
#include "pAPU.h"
#include "PPU.h"

/*used in calculating cycles*/
#define PAGE_SIZE     256
/*used for stack wrap-around*/
#define MY_STACK_SIZE 256

#define RAM_SIZE     65535
/*where the stack starts in RAM*/
#define STACK_OFFSET 4096
/*prg start within the memory*/
#define ROM_START 	 0x8000

/*interrupt addresses*/
#define NMI 0xFFFA
#define RES 0xFFFC
#define IRQ 0xFFFE

/*type of NES*/
#define PAL  1
#define NTSC 2

/*motherboard clocks (MHz)*/
#define PAL_CLOCK  26.601171
#define NTSC_CLOCK 21.4772
/*dividers to produce 1.79 MHz to external interface*/
#define PAL_DIVIDER  16
#define NTSC_DIVIDER 12

/*debugging structure, provided upon request from the core*/
struct CPUCore_dump{
	/*memory*/
	unsigned char m[RAM_SIZE];
	/*registers*/
	unsigned char y_register;
	unsigned char x_register;
	unsigned char a_register;
	/*stack pointer*/
	unsigned char pstack;
	/*status flags*/
	unsigned char status;
};

/*the 2a03 board*/
class CPUCore {
	private:
		/*memory*/
		unsigned char m[RAM_SIZE];
		/*registers*/
		unsigned char y_register;
		unsigned char x_register;
		unsigned char a_register;
		/*stack pointer*/
		unsigned char pstack;
		/*status flags*/
		unsigned char status;

		/*ragel specific vars*/
		int cs;
		/*pointer to current input*/
		unsigned char *p;
		/*pointer to the end of input*/
		unsigned char *pe;

		/*argument count for opcodes*/
		int arg_count;
		/*current number of cycles*/
		int cycles;
		/*current opcode*/
		unsigned char current_op;
		/*used for timing*/
		int interrupt_period;

		/*info on interrupts*/
		/*NMI, IRQ, and RES*/
		int interrupt_type;
		bool interrupt_requested;

		/*used to perform jumps*/
		int is_jump_planned;
		unsigned char* jump_address;

		/*used to determine if debugging*/
		int is_debug;

		/*used for timing, PAL or NTSC*/
		int nes_type;

		/*holds current ROM info*/
		Ines rom;

		/*pAPU chip*/
		pAPU papu;
		/*picture processing chip*/
		PPU ppu;
	
		public:
		CPUCore();
		~CPUCore();
		/*run current ROM*/
		void run();
		/*run current ROM for so many milliseconds*/
		void run_for(int milliseconds);

		/*loads an INES rom*/
		void load_ines(char* fname);

		/*step through current opcode*/
		void step();

		/*used to load machine code to test instructions*/
		void load_debug_code(char* fname);

		/*dumps part of the zero page and registers, used for testing*/
		void dump_core(CPUCore_dump*);

		/*issues a reset IRQ*/
		void reset();

		/*used to request an interrupt*/
		void request_interrupt(int type);

		/*sets type of NES, PAL or NTSC*/
		void set_type(int type){
			nes_type = type;
		}
		int get_type(){return nes_type;}

		/*used to share memory with pAPU*/
		void get_memory(unsigned char*n){
			n = m;
		}

		/*sets debug mode*/		
		void set_debug(){
			is_debug = true;
		}

		/*clears debug*/
		void clear_debug(){
			is_debug = false;
		}

		void clean_up();

		private:
		/*memory functions*/
		int read_memory(short address){
			if(address == 0x4015)
				return papu.handle_read(address);
			else if(address == 0x2007 || address == 0x2002){
				return ppu.handle_read(address);
			}
			else
  			return m[address];
		}
		void write_memory(short address,unsigned char value){
    	m[address] = value;
			/*mirrored memory*/
			if(address >= 0x0000 && address <= 0x07FF){
				m[address+0x0800] = value;
				m[address+0x1000] = value;
				m[address+0x1800] = value;
			}
			/*PPU I/O*/
			else if(address >= 0x2000 && address <= 0x2007){
				ppu.handle_write(address);
				for(int i=0x2008;i<0x4000;i+=8){
					m[address+i] = value;
				}
			}
			/*pAPU I/O*/
			else if(address >= 0x4000 && address <= 0x4015){
				papu.handle_write(address);
			}
		}

		/*stack functions*/
		void push(unsigned char value){
			m[pstack + STACK_OFFSET] = value;
			pstack -= 1;
		}
		unsigned char pop(){
			pstack += 1;
			return m[pstack + STACK_OFFSET];
		}

		/*addressing modes*/
		/*each function returns an adress*/
		short zero_page(unsigned char zero_page_address){
			return (zero_page_address);
		}
		short zero_page_x(unsigned char zero_page_address){
			return ((zero_page_address + x_register));
		}
		short zero_page_y(unsigned char zero_page_address){
			return ((zero_page_address + y_register));
		}

		short absolute(unsigned char most_sig_byte, unsigned char least_sig_byte){
			return ((most_sig_byte*(256)) + least_sig_byte);
		}
		short absolute_x(unsigned char most_sig_byte, unsigned char least_sig_byte){
			return ((most_sig_byte*(256)) + least_sig_byte + x_register);
		}
		short absolute_y(unsigned char most_sig_byte, unsigned char least_sig_byte){
			return ((most_sig_byte*(256)) + least_sig_byte + y_register);
		}

		short indirect(unsigned char most_sig_byte, unsigned char least_sig_byte){
			unsigned char address_least;
			unsigned char address_most;
			/*reproduce page boundary bug for original 6502 chips*/	
			if(least_sig_byte == 0xFF){
		 		address_least = read_memory(0x00FF);
		 	 	address_most = read_memory(0x00);
			}
			else{
		 		address_least = read_memory((most_sig_byte*(256)) + least_sig_byte);
		 	 	address_most = read_memory((most_sig_byte*(256)) + least_sig_byte + 1);
			}
			return ((address_most*(256)) + address_least);
		}

		short indexed_indirect(unsigned char zero_page_address){
			unsigned char least_sig_byte = read_memory(zero_page_address + x_register);
			return (least_sig_byte);
		}

		short indirect_indexed(unsigned char zero_page_address){
			unsigned char least_sig_byte = read_memory(zero_page_address);
			return ((y_register*(256)) + least_sig_byte);
		}
		
		/*jumps are deterred until after instruction is complete (meaning the cyclic_tasks action has finished execution)*/
		void schedule_jump(short address){
			is_jump_planned = 1;
			jump_address = (m + address + ROM_START);
		}
		void schedule_relative_jump(unsigned char bytes){
			is_jump_planned = 1;
			jump_address = p + ((char)bytes)-1;
		}

		/*status functions*/
		/*first set are accessing flags, and the second are for testing if the flags should be set*/
		void set_negative_flag(){
			status |= (1 << 7);
		}
		void clear_negative_flag(){
			status &= ~(1 << 7);
		}
		int get_negative_flag(){
			return (0x80 & status) == 0x80 ? 1 : 0;
		}
		void set_overflow_flag(){
			status |= (1 << 6);
		}
		void clear_overflow_flag(){
			status &= ~(1 << 6);
		}
		int get_overflow_flag(){
			return ((1 << 6) & status);
		}
		void set_break_flag(){
			status |= (1 << 4);
		}
		void clear_break_flag(){
			status &= ~(1 << 4);
		}
		int get_break_flag(){
			return (0x10 & status) == 0x10 ? 1 : 0;
		}
		void set_decimal_mode_flag(){
			status |= (1 << 3);
		}
		void clear_decimal_mode_flag(){
			status &= ~(1 << 3);
		}
		int get_decimal_mode_flag(){
			return (0x08 & status) == 0x08 ? 1 : 0;
		}
		void set_interrupt_disable_flag(){
			status |= (1 << 2);
		}
		void clear_interrupt_disable_flag(){
			status &= ~(1 << 2);
		}
		int get_interrupt_disable_flag(){
			return (0x04 & status) == 0x04 ? 1 : 0;
		}
		void set_zero_flag(){
			status |= (1 << 1);
		}
		void clear_zero_flag(){
			status &= ~(1 << 1);
		}
		int get_zero_flag(){
			return (0x02 & status) == 0x02 ? 1 : 0;
		}
		void set_carry_flag(){
			status |= (1 << 0);
		}
		void clear_carry_flag(){
			status &= ~(1 << 0);
		}
		int get_carry_flag(){
			return (0x01 & status) == 0x01 ? 1 : 0;
		}
		void check_for_zero(unsigned char value){
			if(!value){
				set_zero_flag();
			}
			else
				clear_zero_flag();
		}
		void check_for_negative(unsigned char value){
			if((value & (1 << 7))){
				set_negative_flag();
			}
			if(!value)
				clear_negative_flag();
		}
		void check_for_overflow(unsigned char value1,unsigned char value2){
		 	if( (value1 & (1 << 7))^(value2 & (1 << 7)) ){
				set_overflow_flag();
		 	}
		}
		void check_for_carry(unsigned char value1,unsigned char value2){
			if( (value1 & (1 << 7))^(value2 & (1 << 7)) ){
				set_carry_flag();
		 	}
		}
};
