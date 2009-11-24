#ifndef _PAPU_H
	#include "pAPU.h"
#endif

pAPU::pAPU(){

}

void pAPU::handle_io(short address){
	unsigned char tmp;
	switch(address){
		case 0x4015:
			/*channel enable register*/
			tmp = cpu_memory[0x4015];
			if(tmp&(1<<0)){
				enable_square1();
			}
			else{
				disable_square1();
			}
			if(tmp&(1<<1)){
				enable_square2();
			}
			else{
				disable_square2();
			}
			if(tmp&(1<<2)){
				enable_triangle();
			}
			else{
				disable_triangle();
			}
			if(tmp&(1<<3)){
				enable_noise();
			}
			else{
				disable_noise();
			}
			if(tmp&(1<<4)){
				enable_dmc();
			}
			else{
				disable_dmc();
			}
			break;
		default:break;
	}
}

void pAPU::setup_memory(unsigned char* m){
	cpu_memory = m;
}

void pAPU::enable_square1(){
	is_sq1_enabled = true;
}

void pAPU::disable_square1(){
	is_sq1_enabled = false;
}

void pAPU::enable_square2(){
	is_sq2_enabled = true;
}

void pAPU::disable_square2(){
	is_sq2_enabled = false;
}

void pAPU::enable_triangle(){
	is_tri_enabled = true;
}

void pAPU::disable_triangle(){
	is_tri_enabled = false;
}

void pAPU::enable_noise(){
	is_noise_enabled = true;
}

void pAPU::disable_noise(){
	is_noise_enabled = false;
}

void pAPU::enable_dmc(){
	is_dmc_enabled = true;
}

void pAPU::disable_dmc(){
	is_dmc_enabled = false;
}
