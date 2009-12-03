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
#ifndef _2a03_H
		#include "2a03.h"
#endif
#include <SDL.h>

/*the maximum number of remembered ROM sessions available*/
#define MAX_PRELOADED_ROMS 5

class Happines{
	private:
		/*SDL vars*/
		SDL_Surface *screen;	
  	SDL_Event event;
		/*emulation vars*/
		CPUCore cores[MAX_PRELOADED_ROMS];

	public:
		Happines();
		~Happines();
		/*starts the main processing loop*/
		int run();

	private:
		/*handles keyboard input*/
		void handle_key(SDL_KeyboardEvent key);
		/*opens a config file and attempts to load num most recent ROMS*/
		void load_recent_roms(int num);
};