
all : generate_scripts_bench

generate_scripts_bench : generate_scripts_bench.c
	gcc $^ -O3 -o $@.bin 

clean :
	rm -rf *.bin scripts_test
