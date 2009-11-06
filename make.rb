system("ragel src/2a03.rl")
system("cd src;gcc -w 2a03.c -o ../2a03")
system("cd tests;ruby run_tests.rb")
