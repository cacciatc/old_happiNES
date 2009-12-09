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

	hap.load_rom("Legendary Wings (U).nes");
	hap.launch_nes(DEFAULT_CORE_INDEX);
	return hap.run();
}

int run_nes_thread(void*data){
	/*for debugging*/
	cores[core_index].set_debug();
	cores[core_index].run();
	return 0;
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

void Happines::launch_nes(int index){
	if(index >= DEFAULT_CORE_INDEX and index <= MAX_PRELOADED_ROMS){
			/*core_index is used by run thread*/
			core_index = index;
			if(!thread_cores[index])
				thread_cores[index] = SDL_CreateThread(run_nes_thread,NULL);
	}
}

void Happines::load_recent_roms(int num){

}

void Happines::load_rom(char* fname){
	cores[core_index].load_ines(fname);
}

Happines::~Happines(){

}

int Happines::run(){
	while(true){
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

