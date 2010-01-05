src_path = ./

#library paths
sdl_lib = SDL
sdl_inc = /usr/include/SDL
sdl_mixer_lib = SDL_mixer
sdl_mixer_inc = /usr/include/SDL_mixer
sdl_comp_flags = -l$(sdl_lib) -l$(sdl_mixer_lib) -I $(sdl_inc) -I $(sdl_mixer_inc)

compiler = g++
fs_compiler = ragel

all : happiNES

test : test_instructions

$(src_path)ines.o : $(src_path)ines.rl $(src_path)ines.h
	$(fs_compiler) $(src_path)ines.rl
	$(compiler) -c -g $(src_path)ines.c

$(src_path)pAPU.o : $(src_path)pAPU.cpp $(src_path)pAPU.h
	$(compiler) -c -g $(src_path)pAPU.cpp $(sdl_comp_flags)

$(src_path)PPU.o : $(src_path)PPU.cpp $(src_path)PPU.h
	$(compiler) -c -g $(src_path)PPU.cpp $(sdl_comp_flags)

$(src_path)2a03.o : $(src_path)2a03.rl $(src_path)2a03.h $(src_path)ines.o $(src_path)pAPU.o $(src_path)PPU.o
	$(fs_compiler) $(src_path)2a03.rl
	$(compiler) -c -g $(src_path)2a03.c -I $(sdl_inc) -I $(sdl_mixer_inc)

happiNES : $(src_path)happiNES.cpp $(src_path)happiNES.h $(src_path)2a03.o
	$(compiler) -g $(src_path)happiNES.cpp $(src_path)2a03.o $(src_path)ines.o $(src_path)pAPU.o $(src_path)PPU.o $(sdl_comp_flags) -o ../happiNES

clean :
	rm *.o
