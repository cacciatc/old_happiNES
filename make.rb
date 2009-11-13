system("ragel src/2a03.rl")
system("g++ -Wall src/2a03.c src/cpu_instruction_test.cpp -o ./2a03")
system("cd tests;ruby run_tests.rb")
