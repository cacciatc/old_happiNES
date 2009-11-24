/*
**  This class represents the psuedo-audio processing chip found within the 2a03.
**  author: cacciatc
**  
*/

class pAPU {
	private:
		/*channel enabled/disabled*/
		bool is_sq1_enabled;
		bool is_sq2_enabled;
		bool is_tri_enabled;
		bool is_noise_enabled;
		bool is_dmc_enabled;

		/*ptr to CPU memory*/
		unsigned char *cpu_memory;

	public:
		pAPU();

		/*called when CPU memory-mapped to the pAPU is written to*/
		void handle_io(short address);

		/*gives pAPU access to CPU memory*/
		void setup_memory(unsigned char* m);

		/*channel enable/disable*/
		void enable_square1();
		void disable_square1();
		void enable_square2();
		void disable_square2();
		void enable_triangle();
		void disable_triangle();
		void enable_noise();
		void disable_noise();
		void enable_dmc();
		void disable_dmc();
};
