system("ragel src/2a03.rl")
system("ragel src/ines.rl")
system("g++ -I /usr/include/SDL -lSDL -Wall src/2a03.c src/cpu_instruction_test.cpp src/ines.c src/pAPU.cpp -o ./2a03")
system("cd tests;ruby run_tests.rb")
system("rm 2a03")
