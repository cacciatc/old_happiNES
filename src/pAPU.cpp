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

#ifndef _PAPU_H
	#include "pAPU.h"
#endif

pAPU::pAPU(){
	sample_rate = SAMPLE_RATE;
	/*default to stereo*/
	num_audio_channels = STEREO;
	/*16 bit*/
	audio_format = AUDIO_S16SYS;
	buffer_size = SOUND_BUFFER_SIZE;
	is_sdl_sound_open = false;
}

pAPU::~pAPU(){
	if(is_sdl_sound_open){
		SDL_PauseAudio(true);
		SDL_CloseAudio();
		SDL_Quit();
	}
}

int pAPU::initialize_sound(){
	SDL_AudioSpec spec;
	
	/*setup audio spec*/
	spec.freq = sample_rate;
	spec.format = audio_format;
	spec.channels = num_audio_channels;
	spec.samples = buffer_size;
	/*calced values, so just clear*/
	spec.size = 0;
	spec.silence = 0;

	if(SDL_Init(SDL_INIT_AUDIO) < 0){
		printf("%s\n",SDL_GetError());
	}

	if(SDL_OpenAudio(&spec,NULL) < 0 ){
		printf("%s\n",SDL_GetError());
	}

	SDL_PauseAudio(false);

	return(0);
}

void pAPU::setup_memory(unsigned char* m){
	cpu_memory = m;
}

void pAPU::handle_io(short address){
	unsigned char tmp;

	/*the memory has not been setup!*/	
	if(!cpu_memory)
		return;

	switch(address){
		/*channel enable register*/
		case 0x4015:
			tmp = cpu_memory[0x4015];

			sq1.is_enabled = tmp&(1<<0) ? true : false;

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
			sq1.is_envelope_decay_enabled       = (tmp&(1<<4)) ? true : false;
			sq1.is_length_counter_clock_enabled = (tmp&(1<<5)) ? true : false;
			sq1.is_envelope_decay_loop_enabled  = (tmp&(1<<5)) ? true : false;
			sq1.duty_cycle_type     = (tmp&0xC0);
			sq1.envelope_decay_rate = (tmp&0x07);
			break;
		/*pulse 1 ramp control*/
		case 0x4001:
			sq1.is_increasing_wavelength = (tmp&(1<<3));
			sq1.is_sweep_enabled         = (tmp&(1<<7));
			sq1.sweep_update_rate = (tmp&0x38);
			sq1.right_shift_amt   = (tmp&0x07);
			break;
		/*pulse 1 fine tune*/
		case 0x4002:
			/*some fun logic, since prg timer is only 11 bits*/
			sq1.prg_timer &= 0x700;
			sq1.prg_timer |= tmp;
			break;
		/*pulse 1 course tune*/
		case 0x4003:
			/*the three most significant bits of the timer*/
			sq1.prg_timer &= 0xFF;
			sq1.prg_timer |= (tmp&07);
			/*length counter? what is it*/
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

void pAPU::run(){
	/*update square 1*/
	if(sq1.is_enabled){
		/*env*/
		if(sq1.is_envelope_decay_enabled)
			envelope(sq1);
		/*sweep*/
		if(sq1.is_sweep_enabled)
			sweep(sq1);
		/*length counter*/
		if(sq1.is_length_counter_clock_enabled)
			update_length_counter(sq1);
	}

	/*update square 2*/
	/*update triangle*/
	/*update noise*/
	/*update dmc*/
	
	/*mix*/
	/*output*/
}

void pAPU::reset(){
	/*reset square 1*/
	sq1.is_enabled = false;
	sq1.is_envelope_decay_enabled = false;
	sq1.is_envelope_decay_loop_enabled  = false;
	sq1.is_length_counter_clock_enabled = false;
	sq1.is_sweep_enabled = false;

	sq1.volume = 0;
	sq1.duty_cycle_type = 0;
	sq1.envelope_decay_rate = 0;
	sq1.right_shift_amt = 0;
	sq1.sweep_update_rate = 0;
	sq1.prg_timer = 0;

	/*reset square 2*/
	/*reset triangle*/
	/*reset dmc*/
	/*reset noise*/
}

void pAPU::set_audio_channels(int num){
	num_audio_channels = num;
}

void pAPU::envelope(Channel& ch){

}

void pAPU::sweep(Channel& ch){

}
	
void pAPU::update_length_counter(Channel& ch){

}
