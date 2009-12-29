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
#include "happiNES.h"

/*main happiNES loop*/
int main(int argc,char** argv){
	Happines hap;
	hap = Happines();

	//hap.load_rom("/home/cacciatc/Desktop/happiNES/Legendary Wings (U).nes");
	hap.load_rom("/home/cacciatc/Desktop/happiNES/a_demo.nes");
	return hap.run();
}

/*happiNES class methods*/
Happines::Happines(){
	
	/*initialize SDL*/
	SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO);
  screen = SDL_SetVideoMode(320, 240, 0, SDL_RESIZABLE);

	SDL_WM_SetCaption("happiNES","happiNES");

	/*create a default machine*/
	core_index = DEFAULT_CORE_INDEX;
	cores[core_index] = CPUCore();
	
	/*load some recent roms*/
	load_recent_roms(MAX_PRELOADED_ROMS);

	/*startup GUI*/

}

void Happines::load_recent_roms(int num){

}

void Happines::load_rom(char* fname){
	cores[core_index].load_ines(fname);
	cores[core_index].set_debug();
}

Happines::~Happines(){

}

int Happines::run(){
	last_ntsc_tick = last_pal_tick = SDL_GetTicks();
	while(true){
		next_pal_tick = next_ntsc_tick = SDL_GetTicks();
		/*see how much time has passed and update cycles*/
		if(cores[0].get_type() == NTSC && next_ntsc_tick-last_ntsc_tick > 0){
			cores[0].run_for(next_ntsc_tick-last_ntsc_tick);
			last_ntsc_tick = SDL_GetTicks();
		}
		/*what about a PAL one?*/
		if(cores[0].get_type() == PAL && next_pal_tick-last_pal_tick > 0){
			cores[0].run_for(next_pal_tick-last_pal_tick);
			last_pal_tick = next_pal_tick;
		}

		/*check SDL events*/
		while(SDL_PollEvent(&event)) {
			 switch(event.type) {
			  case SDL_QUIT:
					return(0);
			 	case SDL_KEYDOWN:
			 	case SDL_KEYUP:
					handle_key(event.key);
					break;
			 }
		}
	}
	return 0;
}

void Happines::handle_key(SDL_KeyboardEvent key) {
  switch(key.keysym.sym) {
  	case SDLK_ESCAPE:
    	if(key.type == SDL_KEYDOWN)
				SDL_Quit();
    	break;
		default:break;
 	}
}

