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
#define NTSC_FRAMES_PER_SECOND 60
#define PAL_FRAMES_PER_SECOND  50


class PPU{
	private:
	/*map to CPU memory*/
	unsigned char* cpu_memory;
	/*used to send a vblank to the CPU*/
	bool req_vblank;

	public:
	PPU();
	~PPU();
	
	/*called when CPU memory mapped to the pAPU is written to*/
	void handle_write(short address);

	/*called when CPU memory mapped to pAPU is read from*/
	int handle_read(short address);

	/*gives PPU access to CPU memory, must be called before running PPU*/
	void setup_memory(unsigned char* m);

	/**/
	void update(int cycles){

	}
	bool is_nmi_vblank_active(){
		return req_vblank;
	}
};
