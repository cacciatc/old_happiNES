src_path = ../src/
sdl_lib = SDL
sdl_inc = /usr/include/SDL
sdl_mixer_lib = SDL_mixer
sdl_mixer_inc = /usr/include/SDL_mixer
sdl_comp_flags = -l$(sdl_lib) -l$(sdl_mixer_lib) -I $(sdl_inc) -I $(sdl_mixer_inc)

instruction_tests : cpu_instruction_test.cpp $(src_path)2a03.o $(src_path)pAPU.o $(src_path)PPU.o $(src_path)ines.o
	g++ $(sdl_comp_flags) cpu_instruction_test.cpp $(src_path)2a03.o $(src_path)pAPU.o $(src_path)PPU.o $(src_path)ines.o -o ../2a03
	
