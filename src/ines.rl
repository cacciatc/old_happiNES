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
    prg = (unsigned char*)malloc(sz_prg*sizeof(unsigned char)); 
  }
  action get_chr_size { 
    sz_chr = *p;
    chr = (unsigned char*)malloc(sz_chr*sizeof(unsigned char));  
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
    if(c_prg > sz_prg){
      fgoto Chr;
		}
    else{
      prg[c_prg] = *p;
			c_prg++;
		}
  }
  action get_next_chr_byte{ 
    if(c_chr > sz_chr){
		} 
    else{
      chr[c_chr] = *p;
			c_chr++;
    }
  }
  
	action cyclic_tasks {
		c_count++;
	}
  
  #events
  #header events
  header_preamble = "NES" . 0x1A;
  prg_size        = 0..64 @get_prg_size;
  chr_size        = 0..64 @get_chr_size;
  opt_flags       = ascii @get_options;
  vs_syste        = ascii @get_vs_system;
  ram_size        = ascii @get_ram_size;
  disp_info       = 0..1  @get_disp_info;
  header_end      = 0 {6};
  
  #body events
  prg             = extend+ @get_next_prg_byte;
  chr             = extend* @get_next_chr_byte;
  
  Ines = (
    start: (
      header_preamble -> Header
    ) @cyclic_tasks,
    
    Header: (
      prg_size . chr_size . opt_flags .vs_syste . ram_size . disp_info . header_end -> Prg
    ) @cyclic_tasks,
    
    Prg: (
      prg
    ) @cyclic_tasks,
    
    Chr: (
      chr
    ) @cyclic_tasks
  );
  
  main := Ines;
}%%

%%write data;
INes::INes(char* fname){

	FILE* fp = fopen(fname,"rb");
	int fsize;

	if(!fp){
		printf("Unable to open input file!\n");
		exit(1);
	}

	c_count = 0;
	c_prg = 0;
	c_chr = 0;

	fseek(fp,0,SEEK_END);
  fsize = ftell(fp);
	fseek(fp,0,SEEK_SET);
  fread(p,sizeof(unsigned char),fsize,fp);
	pe = p + fsize;
  fclose(fp);

	%%write init;
	%%write exec;
}
