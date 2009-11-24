/*
**  This class represents the psuedo-audio processing chip found within the 2a03.
**  author: cacciatc
**  
*/
struct Square1_Channel {
	bool is_enabled;
	bool is_envelope_decay_enabled;
	bool is_length_counter_clock_enabled;
	bool is_envelope_decay_loop_enabled;
	int duty_cycle_type;
	int volume;
	int envelope_decay_rate;
};

class pAPU {
	private:
		/*channels*/
		Square1_Channel sq1;
		bool is_sq2_enabled;
		bool is_tri_enabled;
		bool is_noise_enabled;
		bool is_dmc_enabled;

		/*ptr to CPU memory*/
		unsigned char *cpu_memory;
		/*11 bit programmable timer*/
		unsigned short prg_timer;

	public:
		pAPU();

		/*called when CPU memory mapped to the pAPU is written to*/
		void handle_io(short address);

		/*gives pAPU access to CPU memory*/
		void setup_memory(unsigned char* m);

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

		/*timer methods*/
		void set_prg_timer(unsigned short value);

};
