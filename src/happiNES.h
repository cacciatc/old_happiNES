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
#include "2a03.h"
#include <SDL.h>

/*the maximum number of remembered ROM sessions available*/
#define MAX_PRELOADED_ROMS 5
/*Index to the default core*/
#define DEFAULT_CORE_INDEX 0

/*these variables are made global for threading */
int core_index;
/*cores for showing recently played ROMS and the default*/		
CPUCore cores[MAX_PRELOADED_ROMS];
/*accompanying threads for each core*/
SDL_Thread* thread_cores[MAX_PRELOADED_ROMS];
/*accompanying mutexes for each core (reading memory)*/
SDL_mutex* core_mutexes[MAX_PRELOADED_ROMS];

int run_nes_thread(void*data);

class Happines{
	private:
		/*SDL vars*/
		SDL_Surface *screen;	
		/*used for window*/
  	SDL_Event event;

	public:
		Happines();
		~Happines();
		/*loads a rom*/
		void load_rom(char* fname);
		/*starts the main processing loop*/
		int run();
		/*used to launch a nes core*/
		void launch_nes(int index);

	private:
		/*handles keyboard input*/
		void handle_key(SDL_KeyboardEvent key);
		/*opens a config file and attempts to load num most recent ROMS*/
		void load_recent_roms(int num);
};
