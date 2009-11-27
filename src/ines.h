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
#ifndef _STDIO_H
	#include <stdio.h>
#endif
#ifndef _STDLIB_H
	#include <stdlib.h>
#endif
#ifndef _STRING_H
	#include <string.h>
#endif


class Ines {
	private:
		/*size of program memory*/		
		int sz_prg;
		/*size of character memory*/
		int sz_chr;
		/*type of mapper used by ROM*/
		int map_type;
		/**/
		int vs_system;
		/*size of RAM*/
		int sz_ram;

		/*used to count read chars from file*/
		int c_prg;
		int c_chr;

		/*ragel specific vars*/
		int cs;
		/*pointer to current input*/
		unsigned char *p;
		/*pointer to the end of input*/
		unsigned char *pe;

		/*prg and chr memory*/
		unsigned char *prg;
		unsigned char *chr;		

		/*ROM use vertical mirroring?*/
		bool vertical_mirroring;
		/*use horizontal mirroring?*/
		bool horizontal_mirroring;
		/*contains battery back RAM?*/
		bool battery_ram;
		/*has a trainer?*/
		bool trainer;
		bool four_chr;
		/*pal or ntsc?*/
		bool pal;

	public:
		Ines();

		/*loads a nes file*/
		void load_rom(char* fname);

		/*release memory, etc*/
		void clean_up();

		/*returns a pointer to prg*/
		void get_prg(unsigned char* m){
			memcpy(m,prg,get_prg_size());
		}

		/*returns a pointer to chr*/
		void get_chr(unsigned char* m){
			m = chr;
		}

		/*return the prg size in kb*/
		int get_prg_size(void){
			return sz_prg*16*1024;
		}

		/*returns the chr size in kb*/
		int get_chr_size(void){
			return sz_chr*8*1024;
		}

		/*returns the mapper type*/
		int get_map_type(void){
			return map_type;
		}

		/*does this rom support vs*/
		int get_vs_system(void){
			return vs_system;
		}

		/*vertical mirroring enabled?*/
		bool is_vertical_mirroring(void){
			return vertical_mirroring;
		}

		/*horizontal mirroring enabled?*/
		bool is_horizontal_mirroring(void){
			return !vertical_mirroring;
		}
	
		/*does this ROM have battery RAM?*/
		bool has_battery_ram(void){
			return battery_ram;
		}

		/*does this ROM have a trainer*/
		bool has_a_trainer(void){
			return trainer;
		}

		/*does this ROM support 4 screen display?*/
		bool has_four_chr(void){
			return four_chr;
		}

		/*is this a pal ROM?*/
		bool is_pal(void){
			return pal;
		}

		/*is this a NTSC ROM?*/
		bool is_ntsc(void){
			return !pal;
		}
};
