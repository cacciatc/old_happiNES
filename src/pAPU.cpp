#ifndef _PAPU_H
	#include "pAPU.h"
#endif

pAPU::pAPU(){

}

void pAPU::handle_io(short address){
	unsigned char tmp;
	switch(address){
		/*channel enable register*/
		case 0x4015:
			tmp = cpu_memory[0x4015];
			if(tmp&(1<<0)){
				sq1.is_enabled = true;
			}
			else{
				sq1.is_enabled = false;
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
		/*pulse 1 control*/
		case 0x4000:
			/*0-3	volume / envelope decay rate
			4	envelope decay disable
			5	length counter clock disable / envelope decay looping enable
			6-7	duty cycle type (unused on noise channel)*/
			break;
		/*pulse 1 ramp control*/
		case 0x4001:

			break;
		/*pulse 1 fine tune*/
		case 0x4002:

			break;
		default:break;
	}
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

void pAPU::set_prg_timer(unsigned short value){
	
}
