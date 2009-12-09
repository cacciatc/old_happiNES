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

#include <stdlib.h>
#include "SDL.h"
#include "SDL_mixer.h"

#define MONO   1
#define STEREO 2
#define SAMPLE_RATE 44100
#define SOUND_BUFFER_SIZE 2048

/*used in the square channels*/
const int duty_cycle_lookup_table[] = {
	0,1,0,0,0,0,0,0,	/*12.5%*/
	0,1,1,0,0,0,0,0,  /*25%*/
	0,1,1,1,1,0,0,0,  /*50%*/
	1,0,0,1,1,1,1,1   /*25% negated*/
};

/*base channel*/
struct Channel{
	bool is_enabled;
};

/*maybe someday put channels in class, or maybe not...*/
struct Square1_Channel : Channel {
	bool is_envelope_decay_enabled;
	bool is_length_counter_clock_enabled;
	bool is_envelope_decay_loop_enabled;
	bool is_sweep_enabled;
	bool is_increasing_wavelength;
	
	/*2 bits, 0-4 maps to lookup table above*/
	int duty_cycle_type;
	/*volume of this channel*/
	int volume;
	int envelope_decay_rate;
	int sweep_update_rate;
	int right_shift_amt;
	/*a timer used to silence a channel*/
	int length_counter;
	/*11 bit timer*/
	int prg_timer;

	/*SDL sound specific*/
	unsigned char* raw_sample;
	Mix_Chunk* sample;

	void update_length_counter(){
		/*if this counter is enabled and greater than zero*/
		if(is_length_counter_clock_enabled && length_counter > 0){
			length_counter--;
			/*now update the sample since this channel is silenced!*/
			if(length_counter == 0)
				update_sample();
		}
	}
	void update_sweep(){

	}
	void update_envelope_decay(){

	}
	void update_sample(){

	}
};

class pAPU {
	private:
		/*channels*/
		Square1_Channel sq1;
		bool is_sq2_enabled;
		bool is_tri_enabled;
		bool is_noise_enabled;
		bool is_dmc_enabled;

		/*generates low freq signals reqd to clock counters, and generates IRQs*/
		int frame_counter;
		int frame_divider;
		int frame_irq_freq;
		bool frame_irq_enabled;

		/*ptr to CPU memory*/
		unsigned char *cpu_memory;

		/*SDL and audio vars*/
		int sample_rate;
		int num_audio_channels;
		int audio_format;
		int buffer_size;
		
	public:
		/*initializes pAPU vars*/
		pAPU();

		/*cleans up SDL etc*/
		~pAPU();

		/*called when CPU memory mapped to the pAPU is written to*/
		void handle_write(short address);

		/*called when CPU memory mapped to pAPU is read from*/
		int handle_read(short address);

		/*gives pAPU access to CPU memory, must be called before running pAPU*/
		void setup_memory(unsigned char* m);

		/*initializes SDL sound*/
		bool initialize_sound();
		void close_sound();

		/*MONO,STEREO*/
		void set_audio_channels(int num);
 
		/*resets all channels to default values.  Note, this reset must be called with CPUCore.reset()*/
		void reset();

		/*called in CPU's main loop*/
		void update_frame(int cycles);

	private:

		/*channel enable/disable*/
		void enable_square2();
		void disable_square2();
		void enable_triangle();
		void disable_triangle();
		void enable_noise();
		void disable_noise();
		void enable_dmc();
		void disable_dmc();

};
