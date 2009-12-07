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

/*This machine currently does not support trainers!*/
/*This machine currently only checks for the mappers 0-15.*/
#ifndef _INES_H
	#include "ines.h"
#endif

%%{
  machine ines;
  
  #actions
  action get_prg_size { 
    sz_prg = *p;
    prg = (unsigned char*)malloc(sz_prg*16*1024*sizeof(unsigned char));
  }
  action get_chr_size { 
    sz_chr = *p;
		if(sz_chr == 0)
			sz_chr = 1;
    chr = (unsigned char*)malloc(sz_chr*8*1024*sizeof(unsigned char));  
  }
  action get_options  { 
    vertical_mirroring   = (*p) & (1<<0) ? false : true;
    horizontal_mirroring = !vertical_mirroring;  
    battery_ram          = (*p) & (1<<1) ? false : true;
    trainer              = (*p) & (1<<2) ? false : true;
    four_chr             = (*p) & (1<<3) ? false : true;
    map_type             = ((*p)&(1<<4))*1 + ((*p)&(1<<5))*2 + ((*p)&(1<<6))*4 + ((*p)&(1<<7))*8;
  }
  action get_vs_system{
    vs_system = (*p) & (1<<0) ? false : true;
  }
  action get_ram_size { 
		sz_ram = *p; 
	}
  action get_disp_info{
    pal  = (*p) & (1<<0) ? false : true;
  }
  action get_next_prg_byte{
    if(c_prg > get_prg_size()){
      fgoto Chr;
		}
    else{
      prg[c_prg] = (unsigned char)*p;
			c_prg++;
		}
  }
  action get_next_chr_byte{ 
    if(c_chr > get_chr_size()){
			fbreak;
		} 
    else{
      chr[c_chr] = (unsigned char)*p;
			c_chr++;
    }
  }
  
  #events
  #header events
  header_preamble = "NES" . 0x1A;
  prg_size        = extend @get_prg_size;
  chr_size        = extend @get_chr_size;
  opt_flags       = extend @get_options;
  vs_syste        = extend @get_vs_system;
  ram_size        = extend @get_ram_size;
  disp_info       = 0..1  @get_disp_info;
  header_end      = 0 {6};
  
  #body events
  prg             = extend+ @get_next_prg_byte;
  chr             = extend* @get_next_chr_byte;
  
  Ines = (
    start: (
      header_preamble -> Header
    ),
    
    Header: (
      prg_size . chr_size . opt_flags .vs_syste . ram_size . disp_info . header_end -> Prg
    ),
    
    Prg: (
      prg
    ),
    
    Chr: (
      chr
    )
  );
  
  main := Ines;
}%%

%%write data;

Ines::Ines(){
	c_prg = 0;
	c_chr = 0;
}

void Ines::load_rom(char* fname){
	FILE* fp = fopen(fname,"rb");
	int fsize;

	if(!fp){
		printf("Unable to open input file!\n");
		exit(1);
	}

	fseek(fp,0,SEEK_END);
  fsize = ftell(fp);
	fseek(fp,0,SEEK_SET);
	p = (unsigned char*)malloc(fsize*sizeof(unsigned char));
  fread(p,sizeof(unsigned char),fsize,fp);
	pe = p + fsize;
  fclose(fp);

	%%write init;
	%%write exec;
	if(p)
		free(p);
}

void Ines::clean_up(){
	if(p)
		free(p);
}
