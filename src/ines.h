/*
**  This class represents a ROM with an associated INES header.  
**  author: cacciatc
**  Note: A lot of the smaller methods are coded here in this header file to keep clutter out of the .rl file.
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
