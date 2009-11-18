/*TODO
** -not counting cycles correctly for looking up across pages.
*/
#include "2a03.h"
		
%%{
  machine cpu;
  alphtype unsigned char;
  
  #actions
  ##system functions
  action no_operation {
    cycles -= 2;
  }
  action double_no_operation {
    current_op = *(p-arg_count);
    switch(current_op){
      case 0x80 :
        cycles -= 2;
        break;
      case 0x82 :
        cycles -= 2;
        break;
      case 0x89 :
        cycles -= 2;
        break;
      case 0xC2 :
        cycles -= 2;
        break;
      case 0xE2 :
        cycles -= 2;
        break;
      case 0x04 :
        cycles -= 3;
        break;
      case 0x44 :
        cycles -= 3;
        break;
      case 0x64 :
        cycles -= 3;
        break;
      default :
        cycles -= 4;
    }
  }
  action triple_no_operation {
    current_op = *(p-arg_count);
    unsigned char most_sig  = *(p-arg_count+2);
    unsigned char least_sig = *(p-arg_count+1); 
    switch(current_op){
      case 0x0C :
        cycles -= 4;
        break;
      default :
        cycles -= (4 + (absolute_x(most_sig,least_sig) > PAGE_SIZE ? 1 : 0));
    }
  }
  action brk {
    /*push program counter and status*/
    push(p-m-ROM_START+1);
    push(status);
    /*load interrupt vector*/
    schedule_jump(read_memory(IRQ+1)*256 + read_memory(IRQ));
    set_break_flag();
 		set_interrupt_disable_flag();   
		cycles -= 7;
  }
  action return_from_interrupt {
    /*pop status and pc*/
    status = pop();
    schedule_jump(pop());
 		clear_interrupt_disable_flag();
    cycles -= 6;
  }
	action kill {
		fbreak;
	}
  
  ##load and store instructions
  action load_accumulator {
    current_op = *(p-arg_count);
    switch(current_op){
      case 0xA9 :
        /*immediate*/
        a_register = (*p);
        cycles -= 2;
        break;
      case 0xA5 :
        a_register = read_memory(zero_page(*p));
        cycles -= 3;
        break;
      case 0xB5 :
        a_register = read_memory(zero_page_x(*p));
        cycles -= 4;
        break;
      case 0xAD :
        a_register = read_memory(absolute(*p,*(p-1)));
        cycles -= 4;
        break;
      case 0xBD :
        a_register = read_memory(absolute_x(*p,*(p-1)));
        cycles -= 4 + (absolute_x(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
        break;
      case 0xB9 :
        a_register = read_memory(absolute_y(*p,*(p-1)));
        cycles -= 4 + (absolute_y(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
        break;
      case 0xA1 :
        a_register = read_memory(indexed_indirect(*p));
        cycles -= 6;
        break;
      case 0xB1 :
        a_register = read_memory(indirect_indexed(*p));
        cycles -= 5 + (indirect_indexed(*p) > PAGE_SIZE ? 1 : 0);
    }
    check_for_zero(a_register);
    check_for_negative(a_register);
  }
  action load_x {
    current_op = *(p-arg_count);
    switch(current_op){
      case 0xA2 :
        /*immediate*/
        x_register = (*p);
        cycles -= 2;
        break;
      case 0xA6 :
        x_register = read_memory(zero_page(*p));
        cycles -= 3;
        break;
      case 0xB6 :
        x_register = read_memory(zero_page_y(*p));
        cycles -= 4;
        break;
      case 0xAE :
        x_register = read_memory(absolute(*p,*(p-1)));
        cycles -= 4;
        break;
      case 0xBE :
        x_register = read_memory(absolute_y(*p,*(p-1)));
        cycles -= 4 + (absolute_y(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
    }
    check_for_zero(x_register);
    check_for_negative(x_register);
  }
  action load_y {
    current_op = *(p-arg_count);
    switch(current_op){
      case 0xA0 :
        /*immediate*/
        y_register = (*p);
        cycles -= 2;
        break;
      case 0xA4 :
        y_register = read_memory(zero_page(*p));
        cycles -= 3;
        break;
      case 0xB4 :
        y_register = read_memory(zero_page_x(*p));
        cycles -= 4;
        break;
      case 0xAC :
        y_register = read_memory(absolute(*p,*(p-1)));
        cycles -= 4;
        break;
      case 0xBC :
        y_register = read_memory(absolute_x(*p,*(p-1)));
        cycles -= 4 + (absolute_x(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
    }
    check_for_zero(y_register);
    check_for_negative(y_register);
  }
  action store_accumulator {
    current_op = *(p-arg_count);
    switch(current_op){
      case 0x85 :
        write_memory(zero_page(*p),a_register);
        cycles -= 3;
        break;
      case 0x95 :
        write_memory(zero_page_x(*p),a_register);
        cycles -= 4;
        break;
      case 0x8D :
        write_memory(absolute(*p,*(p-1)),a_register);
        cycles -= 4;
        break;
      case 0x9D :
        write_memory(absolute_x(*p,*(p-1)),a_register);
        cycles -= 5;
        break;
      case 0x99 :
        write_memory(absolute_y(*p,*(p-1)),a_register);
        cycles -= 5;
        break;
      case 0x81 :
        write_memory(indexed_indirect(*p),a_register);
        cycles -= 6;
        break;
      case 0x91 :
        write_memory(indirect_indexed(*p),a_register);
        cycles -= 6;
    }
  }
  action store_x {
		current_op = *(p-arg_count);
    switch(current_op){
			case 0x86 :
				write_memory(zero_page(*p),x_register);
				cycles -= 3;
				break;
			case 0x96 :
				write_memory(zero_page_y(*p),x_register);
				cycles -= 4;
				break;
			case 0x8E :;
				write_memory(absolute(*p,*(p-1)),x_register);
				cycles -= 4;
				break;
		}
  }
	action store_y {
		current_op = *(p-arg_count);
    switch(current_op){
			case 0x84 :
				write_memory(zero_page(*p),y_register);
				cycles -= 3;
				break;
			case 0x94 :
				write_memory(zero_page_x(*p),y_register);
				cycles -= 4;
				break;
			case 0x8C :
				write_memory(absolute(*p,*(p-1)),y_register);
				cycles -= 4;
				break;
		}
  }
	action load_accumulator_and_x {
		/*stores result of memory lookup*/
		unsigned char temp;
		current_op = *(p-arg_count);
    switch(current_op){
			case 0xA7 :
				temp = read_memory(zero_page(*p));
				x_register = temp;
				a_register = temp;
				cycles -= 3;
				break;
			case 0xB7 :
				temp = read_memory(zero_page_y(*p));
				x_register = temp;
				a_register = temp;
				cycles -= 4;
				break;
			case 0xAF :
				temp = read_memory(absolute(*p,*(p-1)));
				x_register = temp;
				a_register = temp;
				cycles -= 4;
				break;
			case 0xBF :
				temp = read_memory(absolute_y(*p,*(p-1)));
				x_register = temp;
				a_register = temp;
				cycles -= 4 + (absolute_y(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
				break;
			case 0xA3 :
				temp = read_memory(indexed_indirect(*p));
				x_register = temp;
				a_register = temp;
				cycles -= 6;
				break;
			case 0xB3 :
				temp = read_memory(indirect_indexed(*p));
				x_register = temp;
				a_register = temp;
				cycles -= 5 + (indirect_indexed(*p) > PAGE_SIZE ? 1 : 0);
				break;
		}
		check_for_zero(a_register);
		check_for_negative(a_register);
	}

	##register transfer instructions
	action transfer_accumulator_to_x {
		x_register = a_register;
		
		check_for_zero(x_register);
		check_for_negative(x_register);
		cycles -= 2;
	}
	action transfer_accumulator_to_y {
		y_register = a_register;
		
		check_for_zero(y_register);
		check_for_negative(y_register);
		cycles -= 2;
	}
	action transfer_x_to_accumulator {
		a_register = x_register;
		
		check_for_zero(a_register);
		check_for_negative(a_register);
		cycles -= 2;
	}
	action transfer_y_to_accumulator {
		a_register = y_register;
		
		check_for_zero(a_register);
		check_for_negative(a_register);
		cycles -= 2;
	}

	##stack operation instructions
	action transfer_stack_to_x {
		x_register = pstack;

		check_for_zero(x_register);
		check_for_negative(x_register);
		cycles -= 2;
	}
	action transfer_x_to_stack {
		pstack = x_register;
		cycles -= 2;
	}
	action push_accumulator {
		push(a_register);
		cycles -= 3;
	}
	action push_status {
		push(status);
		cycles -= 3;
	}
	action pull_accumulator {
		a_register = pop();
		check_for_zero(a_register);
		check_for_negative(a_register);
		cycles -= 4;
	}
	action pull_status {
		status = pop();
		cycles -= 4;
	}

	##logical instructions
	action logical_and {
		current_op = *(p-arg_count);
    switch(current_op){
			case 0x29 :
				a_register &= (*p);
				cycles -= 2;
				break;
			case 0x25 :
				a_register &= read_memory(zero_page(*p));
				cycles -= 3;
				break;
			case 0x35 :
				a_register &= read_memory(zero_page_x(*p));
				cycles -= 4;
				break;
			case 0x2D :
				a_register &= read_memory(absolute(*p,*(p-1)));
				cycles -= 4;
				break;
			case 0x3D :
				a_register &= read_memory(absolute_x(*p,*(p-1)));
				cycles -= 4 + (absolute_x(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
				break;
			case 0x39 :		
				a_register &= read_memory(absolute_y(*p,*(p-1)));
				cycles -= 4 + (absolute_y(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
				break;
			case 0x21 :
				a_register &= read_memory(indirect_indexed(*p));
				cycles -= 6;
				break;
			case 0x31 :
				a_register &= read_memory(indexed_indirect(*p));
				cycles -= 5 + (indexed_indirect(*p) > PAGE_SIZE ? 1 : 0);
		}
		check_for_zero(a_register);
		check_for_negative(a_register);
	}
	action logical_eor {
		current_op = *(p-arg_count);
    switch(current_op){
			case 0x49 :
				a_register ^= (*p);
				cycles -= 2;
				break;
			case 0x45 :
				a_register ^= read_memory(zero_page(*p));
				cycles -= 3;
				break;
			case 0x55 :
				a_register ^= read_memory(zero_page_x(*p));
				cycles -= 4;
				break;
			case 0x4D :
				a_register ^= read_memory(absolute(*p,*(p-1)));
				cycles -= 4;
				break;
			case 0x5D :
				a_register ^= read_memory(absolute_x(*p,*(p-1)));
				cycles -= 4 + (absolute_x(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
				break;
			case 0x59 :		
				a_register ^= read_memory(absolute_y(*p,*(p-1)));
				cycles -= 4 + (absolute_y(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
				break;
			case 0x41 :
				a_register ^= read_memory(indirect_indexed(*p));
				cycles -= 6;
				break;
			case 0x51 :
				a_register ^= read_memory(indexed_indirect(*p));
				cycles -= 6 + (indexed_indirect(*p) > PAGE_SIZE ? 1 : 0);
		}
		check_for_zero(a_register);
		check_for_negative(a_register);
	}
	action logical_ora {
		current_op = *(p-arg_count);
    switch(current_op){
			case 0x09 :
				a_register |= (*p);
				cycles -= 2;
				break;
			case 0x05 :
				a_register |= read_memory(zero_page(*p));
				cycles -= 3;
				break;
			case 0x15 :
				a_register |= read_memory(zero_page_x(*p));
				cycles -= 4;
				break;
			case 0x0D :
				a_register |= read_memory(absolute(*p,*(p-1)));
				cycles -= 4;
				break;
			case 0x1D :
				a_register |= read_memory(absolute_x(*p,*(p-1)));
				cycles -= 4 + (absolute_x(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
				break;
			case 0x19 :		
				a_register |= read_memory(absolute_y(*p,*(p-1)));
				cycles -= 4 + (absolute_y(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
				break;
			case 0x01 :
				a_register |= read_memory(indirect_indexed(*p));
				cycles -= 6;
				break;
			case 0x11 :
				a_register |= read_memory(indexed_indirect(*p));
				cycles -= 6 + (indexed_indirect(*p) > PAGE_SIZE ? 1 : 0);
		}
		check_for_zero(a_register);
		check_for_negative(a_register);
	}
	action logical_bit {
		unsigned char temp;
		unsigned char mem_val;
		current_op = *(p-arg_count);
    switch(current_op){
			case 0x24 :
				mem_val = read_memory(zero_page(*p));
				temp = a_register & mem_val;
				cycles -= 3;
				break;
			case 0x2C :
				mem_val = read_memory(absolute(*p,*(p-1)));
				temp = a_register & mem_val;
				cycles -= 4;
		}
		check_for_zero(temp);
		check_for_negative(temp);
		if(temp & (1 << 6)){
			set_overflow_flag();
		}
	}
	action logical_and_accumulator_with_byte {
		unsigned char temp;
		current_op = *(p-arg_count);
    switch(current_op){
			case 0x0B :
				temp = a_register & *p;
				break;
			case 0x2B :
				temp = a_register & *p;
		}
		cycles -= 2;
		check_for_zero(temp);
		check_for_negative(temp);
		if(temp & (1 << 6)){
			set_overflow_flag();
		}
	}
	action logical_and_accumulator_with_x {
		unsigned char temp;
		current_op = *(p-arg_count);
		
		temp = a_register & x_register;
    switch(current_op){
			case 0x87 :
				write_memory(zero_page(*p),temp);
				cycles -= 3;
				break;
			case 0x97 :
				write_memory(zero_page_y(*p),temp);
				cycles -= 4;
				break;
			case 0x93 :
				write_memory(indirect_indexed(*p),temp);
				cycles -= 6;
				break;
			case 0x8F :
				write_memory(absolute(*p,*(p-1)),temp);
				cycles -= 4;
		}
		check_for_zero(temp);
		check_for_negative(temp);
	}
	action logical_and_accumulator_with_byte_right_rotate{
		/*and with byte*/
		a_register &= *p;
		/*rotate right*/
		a_register = a_register>>1;

		/*undocumented opcode - check nesdev.parodius.com/undocumented_opcodes.txt*/
		if(a_register & (1 << 6)){
			if(a_register & (1 << 5)){
				set_carry_flag();
				clear_overflow_flag();
			}
			else{
				set_carry_flag();
				set_overflow_flag();
			}
		}
		else{
			if(a_register & (1 << 5)){
					clear_carry_flag();
					set_overflow_flag();
			}
			else{
				clear_carry_flag();
				clear_overflow_flag();
			}
		}
		check_for_negative(a_register);
		check_for_zero(a_register);
		cycles -= 2;
	}
	action logical_and_accumulator_with_byte_right_shift{
		check_for_carry(a_register,*p);	
		/*and with byte*/
		a_register &= *p;
		/*rotate right*/
		a_register = a_register>>1;

		check_for_negative(a_register);
		check_for_zero(a_register);
		cycles -= 2;
	}
	action logical_and_accumulator_with_byte_store_x {
		/*and with byte*/
		a_register &= *p;
		x_register = a_register;

		check_for_negative(a_register);
		check_for_zero(a_register);
		cycles -= 2;
	}
	action logical_and_accumulator_with_x_store_memory {
		unsigned char temp;
		current_op = *(p-arg_count);

		temp = (a_register & x_register) & 0x07;
    switch(current_op){
			case 0x9F :
				write_memory(absolute_y(*p,*(p-1)),temp);
				cycles -= 5;
				break;
			case 0x93 :
				write_memory(indirect_indexed(*p),temp);
				cycles -= 6;
		}
	}
	action logical_and_accumulator_with_x_sub_byte {
		check_for_carry(x_register,*p);	
		x_register &= a_register;
		x_register -= *p;

		check_for_negative(x_register);
		check_for_zero(x_register);
;
		cycles -= 2;
	}
	action logical_and_mem_with_stack_pointer {
		unsigned char temp;		

		temp = read_memory(absolute_y(*p,*(p-1)));
		temp &= pstack;
		a_register = temp;
		x_register = temp;
		pstack = temp;
		
		check_for_negative(a_register);
		check_for_zero(a_register);
		cycles -= 4 + (absolute_y(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
	}
	action logical_and_high_byte_with_x {
		x_register &= *(p);
		write_memory(absolute_y(*p,*(p-1)),x_register+1);
		cycles -= 5;
	}
	action logical_and_high_byte_with_y {
		y_register &= *(p);
		write_memory(absolute_x(*p,*(p-1)),y_register+1);
		cycles -= 5;
	}
	action logical_and_x_with_accumulator_store_in_stack {
		pstack = x_register & a_register;
		write_memory(absolute_y(*p,*(p-1)),(pstack & *p) + 1);		
		cycles -= 5;
	}

	##arithmetic instructions
	action add {
		unsigned char temp;
		unsigned char old_a = a_register;
		current_op = *(p-arg_count);
    switch(current_op){
			case 0x69 :
				temp = get_carry_flag();
				check_for_carry(a_register,*p + get_carry_flag());
				a_register += ( (*p) + temp);
				cycles -= 2;
				break;
			case 0x65 :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(zero_page(*p)) + get_carry_flag());
				a_register += (read_memory(zero_page(*p)) + temp);
				cycles -= 3;
				break;
			case 0x75 :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(zero_page_x(*p)) + get_carry_flag());
				a_register += (read_memory(zero_page_x(*p)) + temp);
				cycles -= 4;
				break;
			case 0x6D :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(absolute(*p,*(p-1))) + get_carry_flag());
				a_register += (read_memory(absolute(*p,*(p-1))) + temp);
				cycles -= 4;
				break;
			case 0x7D :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(absolute_x(*p,*(p-1))) + get_carry_flag());
				a_register += (read_memory(absolute_x(*p,*(p-1))) + temp);
				cycles -= 4 + (absolute_x(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
				break;
			case 0x79 :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(absolute_y(*p,*(p-1))) + get_carry_flag());
				a_register += (read_memory(absolute_y(*p,*(p-1))) + temp);
				cycles -= 4 + (absolute_y(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
				break;
			case 0x61 :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(indexed_indirect(*p)) + get_carry_flag());
				a_register += (read_memory(indexed_indirect(*p)) + temp);
				cycles -= 6;
				break;
			case 0x71 :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(indirect_indexed(*p)) + get_carry_flag());
				a_register += (read_memory(indirect_indexed(*p)) + temp);
				cycles -= 5 + (indirect_indexed(*p) > PAGE_SIZE ? 1 : 0);
				break;
			default : break;
		}

		check_for_zero(a_register);
		check_for_overflow(a_register,old_a);
		check_for_negative(a_register);
	}
	action subtract {
		unsigned char temp;
		unsigned char old_a = a_register;
		current_op = *(p-arg_count);

    switch(current_op){
			case 0xE9 :
				temp = get_carry_flag();
				check_for_carry(a_register,*p - (1 - get_carry_flag()));
				a_register -= ( (*p) - (1 - temp));
				cycles -= 2;
				break;
			/*illegal opcode, same as 0xE9*/
			case 0xEB :
				temp = get_carry_flag();
				check_for_carry(a_register,*p - (1 - get_carry_flag()));
				a_register -= ( (*p) - (1 - temp));
				cycles -= 2;
				break;
			case 0xE5 :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(zero_page(*p)) - (1-get_carry_flag()));
				a_register -= (read_memory(zero_page(*p)) - (1 - temp));
				cycles -= 3;
				break;
			case 0xF5 :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(zero_page_x(*p)) -(1 - get_carry_flag()));
				a_register -= (read_memory(zero_page_x(*p)) - (1-temp));
				cycles -= 4;
				break;
			case 0xED :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(absolute(*p,*(p-1))) - (1- get_carry_flag()));
				a_register -= (read_memory(absolute(*p,*(p-1))) - (1-temp));
				cycles -= 4;
				break;
			case 0xFD :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(absolute_x(*p,*(p-1))) - (1- get_carry_flag()));
				a_register -= (read_memory(absolute_x(*p,*(p-1))) -(1- temp));
				cycles -= 4 + (absolute_x(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
				break;
			case 0xF9 :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(absolute_y(*p,*(p-1))) - (1- get_carry_flag()));
				a_register -= (read_memory(absolute_y(*p,*(p-1))) - (1-temp));
				cycles -= 4 + (absolute_y(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
				break;
			case 0xE1 :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(indexed_indirect(*p)) - (1- get_carry_flag()));
				a_register -= (read_memory(indexed_indirect(*p)) -(1- temp));
				cycles -= 6;
				break;
			case 0xF1 :
				temp = get_carry_flag();
				check_for_carry(a_register,read_memory(indirect_indexed(*p)) -(1- get_carry_flag()));
				a_register -= (read_memory(indirect_indexed(*p)) -(1-temp));
				cycles -= 5 + (indirect_indexed(*p) > PAGE_SIZE ? 1 : 0);
				break;
			default : break;
		}

		check_for_zero(a_register);
		check_for_overflow(a_register,old_a);
		check_for_negative(a_register);
	}
	action compare {
		unsigned char temp;
		current_op = *(p-arg_count);

    switch(current_op){
			case 0xC9 :
				if(a_register >= *p){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(a_register == *p){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 2;
				break;
			case 0xC5 :
				temp = read_memory(zero_page(*p));
				if(a_register >= temp){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(a_register == temp){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 3;
				break;
			case 0xD5 :
				temp = read_memory(zero_page_x(*p));
				if(a_register >= temp){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(a_register == temp){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 4;
				break;
			case 0xCD :
				temp = read_memory(absolute(*p,*(p-1)));
				if(a_register >= temp){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(a_register == temp){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 4;
				break;
			case 0xDD :
				temp = read_memory(absolute_x(*p,*(p-1)));
				if(a_register >= temp){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(a_register == temp){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 4 + (absolute_x(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
				break;
			case 0xD9 :
				temp = read_memory(absolute_y(*p,*(p-1)));
				if(a_register >= temp){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(a_register == temp){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 4 + (absolute_y(*p,*(p-1)) > PAGE_SIZE ? 1 : 0);
				break;
			case 0xC1 :
				temp = read_memory(indexed_indirect(*p));
				if(a_register >= temp){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(a_register == temp){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 6;
				break;
			case 0xD1 :
				temp = read_memory(indirect_indexed(*p));
				if(a_register >= temp){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(a_register == temp){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 5 + (indirect_indexed(*p) > PAGE_SIZE ? 1 : 0);
				break;
			default : break;
		}
		check_for_negative(a_register);
	}
	action compare_x {
		unsigned char temp;
		current_op = *(p-arg_count);

    switch(current_op){
			case 0xE0 :
				if(x_register >= *p){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(x_register == *p){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 2;				
				break;			
			case 0xE4 : 
				temp = read_memory(zero_page(*p));
				if(x_register >= temp){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(x_register == temp){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 3;
				break;
			case 0xEC :
				temp = read_memory(absolute(*p,*(p-1)));
				if(x_register >= temp){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(x_register == temp){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 4;
				break;
			default : break;
		}
		check_for_negative(x_register);
	}
	action compare_y {
		unsigned char temp;
		current_op = *(p-arg_count);

    switch(current_op){
			case 0xC0 :
				if(y_register >= *p){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(y_register == *p){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 2;				
				break;			
			case 0xC4 : 
				temp = read_memory(zero_page(*p));
				if(y_register >= temp){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(y_register == temp){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 3;
				break;
			case 0xCC :
				temp = read_memory(absolute(*p,*(p-1)));
				if(y_register >= temp){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				if(y_register == temp){
					set_zero_flag();
				}
				else{
					clear_zero_flag();
				}
				cycles -= 4;
				break;
			default : break;
		}
		check_for_negative(y_register);
	}

	##increments and decrements
	action inc {
		unsigned char temp;
		current_op = *(p-arg_count);

		switch(current_op){
			case 0xE6 :
				temp = read_memory(zero_page(*p));
				temp++;				
				write_memory(zero_page(*p),temp);
				cycles -= 5;
				break;
			case 0xF6 :
				temp = read_memory(zero_page_x(*p));
				temp++;				
				write_memory(zero_page_x(*p),temp);
				cycles -= 6;
				break;
			case 0xEE :
				temp = read_memory(absolute(*p,*(p-1)));
				temp++;				
				write_memory(absolute(*p,*(p-1)),temp);
				cycles -= 6;
				break;
			case 0xFE :
				temp = read_memory(absolute_x(*p,*(p-1)));
				temp++;				
				write_memory(absolute_x(*p,*(p-1)),temp);
				cycles -= 7;
				break;
			default : break;
		}
		check_for_negative(temp);
		check_for_zero(temp);
	}
	action inc_x {			
		x_register++;
		cycles -= 2;
		check_for_negative(x_register);
		check_for_zero(x_register);
	}
	action inc_y {			
		y_register++;
		cycles -= 2;
		check_for_negative(y_register);
		check_for_zero(y_register);
	}
	action dec {
		unsigned char temp;
		current_op = *(p-arg_count);

		switch(current_op){
			case 0xC6 :
				temp = read_memory(zero_page(*p));
				temp--;				
				write_memory(zero_page(*p),temp);
				cycles -= 5;
				break;
			case 0xD6 :
				temp = read_memory(zero_page_x(*p));
				temp--;				
				write_memory(zero_page_x(*p),temp);
				cycles -= 6;
				break;
			case 0xCE :
				temp = read_memory(absolute(*p,*(p-1)));
				temp--;				
				write_memory(absolute(*p,*(p-1)),temp);
				cycles -= 6;
				break;
			case 0xDE :
				temp = read_memory(absolute_x(*p,*(p-1)));
				temp--;				
				write_memory(absolute_x(*p,*(p-1)),temp);
				cycles -= 7;
				break;
			default : break;
		}
		check_for_negative(temp);
		check_for_zero(temp);
	}
	action dec_x {			
		x_register--;
		cycles -= 2;
		check_for_negative(x_register);
		check_for_zero(x_register);
	}
	action dec_y {			
		y_register--;
		cycles -= 2;
		check_for_negative(y_register);
		check_for_zero(y_register);
	}
	action dcp {
		unsigned char temp;
		current_op = *(p-arg_count);

		switch(current_op){
			case 0xC7 :
				temp = read_memory(zero_page(*p));
				temp--;				
				write_memory(zero_page(*p),temp);
				cycles -= 5;
				break;
			case 0xD7 :
				temp = read_memory(zero_page_x(*p));
				temp--;				
				write_memory(zero_page_x(*p),temp);
				cycles -= 6;
				break;
			case 0xCF :
				temp = read_memory(absolute(*p,*(p-1)));
				temp--;				
				write_memory(absolute(*p,*(p-1)),temp);
				cycles -= 6;
				break;
			case 0xDF :
				temp = read_memory(absolute_x(*p,*(p-1)));
				temp--;				
				write_memory(absolute_x(*p,*(p-1)),temp);
				cycles -= 7;
				break;
			case 0xDB :
				temp = read_memory(absolute_y(*p,*(p-1)));
				temp--;				
				write_memory(absolute_y(*p,*(p-1)),temp);
				cycles -= 7;
				break;
			case 0xC3 :
				temp = read_memory(indexed_indirect(*p));
				temp--;				
				write_memory(indexed_indirect(*p),temp);
				cycles -= 8;
				break;
			case 0xD3 :
				temp = read_memory(indirect_indexed(*p));
				temp--;				
				write_memory(indirect_indexed(*p),temp);
				cycles -= 8;
				break;
			default : break;
		}
		check_for_negative(temp);
		check_for_zero(temp);
	}

	##jumps and calls
	action jump {
		current_op = *(p-arg_count);

		switch(current_op){
			case 0x4C :
				schedule_jump(absolute(*p,*(p-1)));
				cycles -= 3;
				break;
			case 0x6C :
				schedule_jump(indirect(*p,*(p-1)));
				cycles -= 5;
				break;
			default : break;
		}
	}
	action jump_to_subroutine {
		push(p-m-ROM_START+1);		
		schedule_jump(absolute(*p,*(p-1)));
		cycles -= 6;
	}
	action return_from_subroutine {		
		schedule_jump(pop());
		cycles -= 6;
	}

	##branches
	action branch_if_carry_clear {
		if(!get_carry_flag()){
			schedule_relative_jump(*p);
			cycles -= 1;
		}
		/*currently not accounting for if new address is on a different page*/
		cycles -= 2;
	}
	action branch_if_carry_set {
		if(get_carry_flag()){
			schedule_relative_jump(*p);
			cycles -= 1;
		}
		/*currently not accounting for if new address is on a different page*/
		cycles -= 2;
	}
	action branch_if_equal {
		if(get_zero_flag()){
			schedule_relative_jump(*p);
			cycles -= 1;
		}
		/*currently not accounting for if new address is on a different page*/
		cycles -= 2;
	}
	action branch_if_not_equal {
		if(!get_zero_flag()){
			schedule_relative_jump(*p);
			cycles -= 1;
		}
		/*currently not accounting for if new address is on a different page*/
		cycles -= 2;
	}
	action branch_if_minus {
		if(get_negative_flag()){
			schedule_relative_jump(*p);
			cycles -= 1;
		}
		/*currently not accounting for if new address is on a different page*/
		cycles -= 2;
	}
	action branch_if_positive {
		if(!get_negative_flag()){
			schedule_relative_jump(*p);
			cycles -= 1;
		}
		/*currently not accounting for if new address is on a different page*/
		cycles -= 2;
	}
	action branch_if_overflow_clear {
		if(!get_overflow_flag()){
			schedule_relative_jump(*p);
			cycles -= 1;
		}
		/*currently not accounting for if new address is on a different page*/
		cycles -= 2;
	}
	action branch_if_overflow_set {
		if(get_overflow_flag()){
			schedule_relative_jump(*p);
			cycles -= 1;
		}
		/*currently not accounting for if new address is on a different page*/
		cycles -= 2;
	}

	##status flag changes
	action set_carry_flag {
		set_carry_flag();
		cycles -= 2;
	}
	action clear_carry_flag {
		clear_carry_flag();
		cycles -= 2;
	}
	action clear_overflow_flag {
		clear_overflow_flag();
		cycles -= 2;
	}
	action set_interrupt_disable_flag {
		set_interrupt_disable_flag();
		cycles -= 2;
	}
	action clear_interrupt_disable_flag {
		clear_interrupt_disable_flag();
		cycles -= 2;
	}
	action set_decimal_mode_flag {
		set_decimal_mode_flag();
		cycles -= 2;
	}
	action clear_decimal_mode_flag {
		clear_decimal_mode_flag();
		cycles -= 2;
	}

	##shifts
	action arithmetic_shift_left {
		unsigned char temp;
		current_op = *(p-arg_count);

		switch(current_op){
			case 0x0A :
				/*set carry flag to old bit 7*/
				if(a_register & (1 << 7)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				a_register *= 2;
				temp = a_register;
				cycles -= 2;
				break;
			case 0x06 :
				temp = read_memory(zero_page(*p));				
				/*set carry flag to old bit 7*/
				if(temp & (1 << 7)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp *= 2;
				write_memory(zero_page(*p),temp);
				cycles -= 5;
				break;
			case 0x16 :
				temp = read_memory(zero_page_x(*p));				
				/*set carry flag to old bit 7*/
				if(temp & (1 << 7)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp *= 2;
				write_memory(zero_page_x(*p),temp);
				cycles -= 6;
				break;
			case 0x0E :
				temp = read_memory(absolute(*p,*(p-1)));				
				/*set carry flag to old bit 7*/
				if(temp & (1 << 7)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp *= 2;
				write_memory(absolute(*p,*(p-1)),temp);
				cycles -= 6;
				break;
			case 0x1E :
				temp = read_memory(absolute_x(*p,*(p-1)));		
				/*set carry flag to old bit 7*/
				if(temp & (1 << 7)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp *= 2;
				write_memory(absolute_x(*p,*(p-1)),temp);
				cycles -= 7;
				break;
			default : break;
		}
		check_for_zero(temp);
		check_for_negative(temp);
	}
	action logical_shift_right {
		unsigned char temp;
		current_op = *(p-arg_count);

		switch(current_op){
			case 0x4A :
				/*set carry flag to old bit 0*/
				if(a_register & (1 << 0)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				a_register /= 2;
				temp = a_register;
				cycles -= 2;
				break;
			case 0x46 :
				temp = read_memory(zero_page(*p));				
				/*set carry flag to old bit 0*/
				if(temp & (1 << 0)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp /= 2;
				write_memory(zero_page(*p),temp);
				cycles -= 5;
				break;
			case 0x56 :
				temp = read_memory(zero_page_x(*p));				
				/*set carry flag to old bit 0*/
				if(temp & (1 << 0)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp /= 2;
				write_memory(zero_page_x(*p),temp);
				cycles -= 6;
				break;
			case 0x4E :
				temp = read_memory(absolute(*p,*(p-1)));				
				/*set carry flag to old bit 0*/
				if(temp & (1 << 0)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp /= 2;
				write_memory(absolute(*p,*(p-1)),temp);
				cycles -= 6;
				break;
			case 0x5E :
				temp = read_memory(absolute_x(*p,*(p-1)));				
				/*set carry flag to old bit 0*/
				if(temp & (1 << 0)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp /= 2;
				write_memory(absolute_x(*p,*(p-1)),temp);
				cycles -= 7;
				break;
			default : break;
		}
		check_for_zero(temp);
		check_for_negative(temp);
	}
	action rotate_left {
		unsigned char temp;
		unsigned char old_carry;
		
		current_op = *(p-arg_count);
		old_carry = get_carry_flag();

		switch(current_op){
			case 0x2A :
				/*set carry flag to old bit 7*/
				if(a_register & (1 << 7)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				a_register *= 2;
				a_register |= (old_carry<<0);
				temp = a_register;
				cycles -= 2;
				break;
			case 0x26 :
				temp = read_memory(zero_page(*p));				
				/*set carry flag to old bit 7*/
				if(temp & (1 << 7)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp *= 2;
				temp |= (old_carry<<0);
				write_memory(zero_page(*p),temp);
				cycles -= 5;
				break;
			case 0x36 :
				temp = read_memory(zero_page_x(*p));				
				/*set carry flag to old bit 7*/
				if(temp & (1 << 7)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp *= 2;
				temp |= (old_carry<<0);
				write_memory(zero_page_x(*p),temp);
				cycles -= 6;
				break;
			case 0x2E :
				temp = read_memory(absolute(*p,*(p-1)));				
				/*set carry flag to old bit 7*/
				if(temp & (1 << 7)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp *= 2;
				temp |= (old_carry<<0);
				write_memory(absolute(*p,*(p-1)),temp);
				cycles -= 6;
				break;
			case 0x3E :
				temp = read_memory(absolute_x(*p,*(p-1)));				
				/*set carry flag to old bit 7*/
				if(temp & (1 << 7)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp *= 2;
				temp |= (old_carry<<0);
				write_memory(absolute_x(*p,*(p-1)),temp);
				cycles -= 7;
				break;
			default : break;
		}
		check_for_zero(temp);
		check_for_negative(temp);
	}
	action rotate_right {
		unsigned char temp;
		unsigned char old_carry;

		current_op = *(p-arg_count);
		old_carry = get_carry_flag();

		switch(current_op){
			case 0x6A :
				/*set carry flag to old bit 0*/
				if(a_register & (1 << 0)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				a_register /= 2;
				a_register |= (old_carry<<7);
				temp = a_register;
				cycles -= 2;
				break;
			case 0x66 :
				temp = read_memory(zero_page(*p));		
				/*set carry flag to old bit 0*/
				if(temp & (1 << 0)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp /= 2;
				temp |= (old_carry<<7);
				write_memory(zero_page(*p),temp);
				cycles -= 5;
				break;
			case 0x76 :
				temp = read_memory(zero_page_x(*p));				
				/*set carry flag to old bit 0*/
				if(temp & (1 << 0)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp /= 2;
				temp |= (old_carry<<7);
				write_memory(zero_page_x(*p),temp);
				cycles -= 6;
				break;
			case 0x6E :
				temp = read_memory(absolute(*p,*(p-1)));				
				/*set carry flag to old bit 0*/
				if(temp & (1 << 0)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp /= 2;
				temp |= (old_carry<<7);
				write_memory(absolute(*p,*(p-1)),temp);
				cycles -= 6;
				break;
			case 0x7E :
				temp = read_memory(absolute_x(*p,*(p-1)));				
				/*set carry flag to old bit 0*/
				if(temp & (1 << 0)){
					set_carry_flag();
				}
				else{
					clear_carry_flag();
				}
				temp /= 2;
				temp |= (old_carry<<7);
				write_memory(absolute_x(*p,*(p-1)),temp);
				cycles -= 7;
				break;
			default : break;
		}
		check_for_zero(temp);
		check_for_negative(temp);
	}
  
  #special actions
  action cyclic_tasks {
		if(is_debug){
			printf("[0x%.4X] ",(unsigned int)(p-arg_count));
  		for(int i = arg_count; i >= 0;i--){
    		printf("0x%.4X ",*(p-i));
  		}
  		printf("\n");
		}
		
    if(cycles <= 0){
      cycles += interrupt_period;
    }
    if(p >= pe){
      fbreak;
		}
		/*perform any scheduled jumps*/
		if(is_jump_planned){
			is_jump_planned = 0;
			p = jump_address;
			fexec p;
		}
		if(is_debug){
			cs = fcurs;
			fbreak;
		}
  }
 
  #system functions
  NOP = (0x1A | 0x3A| 0x5A | 0x7A | 0xDA | 0xEA | 0xFA) @{arg_count = 0;} @no_operation;
  DOP = ((0x04 | 0x14 | 0x34 | 0x44 | 0x54 | 0x64 | 0x74 | 0x80 | 0x82 | 0x89 | 0xC2 | 0xD4 | 0xE2 | 0xF4) . extend) @{arg_count = 1;} @double_no_operation;
  TOP = ((0x0C | 0x1C | 0x3C | 0x5C | 0x7C | 0xDC | 0xFC) . extend . extend) @{arg_count = 2;} @triple_no_operation;
  BRK = (0x00) @{arg_count = 0;} @brk;
  RTI = (0x40) @{arg_count = 0;} @return_from_interrupt;
	KIL = ((0x02 | 0x12 | 0x22 | 0x32 | 0x42 | 0x52 | 0x62 | 0x72 | 0x92 | 0xB2 | 0xD2 | 0xF2) @{arg_count = 0;}) @kill;
  
  #load and store instructions
	LAX = (((0xA7 | 0xB7 | 0xA3 | 0xB3) . extend) @{arg_count = 1;} | ((0xAF | 0xBF) . extend . extend) @{arg_count = 2;}) @load_accumulator_and_x;
  LDA = ((((0xA9 | 0xA5 | 0xB5 | 0xA1 | 0xB1) . extend) @{arg_count = 1;}) | (((0xAD | 0xBD | 0xB9) . extend . extend) @{arg_count = 2;}) ) @load_accumulator;
  LDX = ((((0xA2 | 0xA6 | 0xB6) . extend) @{arg_count = 1;}) | (((0xAE | 0xBE) . extend .extend) @{arg_count = 2;}) ) @load_x;
  LDY = ((((0xA0 | 0xA4 | 0xB4) . extend) @{arg_count = 1;}) | (((0xAC | 0xBC) . extend .extend) @{arg_count = 2;}) ) @load_y;
  STA = ((((0x85 | 0x95 | 0x81 | 0x91) .extend) @{arg_count = 1;}) | (((0x8D | 0x9D | 0x99) . extend . extend) @{arg_count = 2;}) ) @store_accumulator; 
  STX = (((0x86 | 0x96) . extend) @{arg_count = 1;} | ((0x8E) . extend . extend) @{arg_count = 2;}) @store_x;
	STY = (((0x84 | 0x94) . extend) @{arg_count = 1;} | ((0x8C) . extend . extend) @{arg_count = 2;}) @store_y;

	#register transfer instructions
	TAX = (0xAA @{arg_count = 0;}) @transfer_accumulator_to_x;
	TAY = (0xA8 @{arg_count = 0;}) @transfer_accumulator_to_y;
	TXA = (0x8A @{arg_count = 0;}) @transfer_x_to_accumulator;
	TYA = (0x98 @{arg_count = 0;}) @transfer_y_to_accumulator;

	#stack operation instructions
	TSX = (0xBA @{arg_count = 0;}) @transfer_stack_to_x;
	TXS = (0x9A @{arg_count = 0;}) @transfer_x_to_stack;
	PHA = (0x48 @{arg_count = 0;}) @push_accumulator;
	PHP = (0x08 @{arg_count = 0;}) @push_status;
	PLA = (0x68 @{arg_count = 0;}) @pull_accumulator;
	PLP = (0x28 @{arg_count = 0;}) @pull_status;

	#logical instructions
  AND = (((0x29 | 0x25 | 0x35 | 0x21 | 0x31) . extend) @{arg_count = 1;} | ((0x2D | 0x3D | 0x39) . extend . extend) @{arg_count = 2;}) @logical_and;
	EOR = (((0x49 | 0x45 | 0x55 | 0x41 | 0x51) . extend) @{arg_count = 1;} | ((0x4D | 0x5D | 0x59) . extend . extend) @{arg_count = 2;}) @logical_eor;
	ORA = (((0x09 | 0x05 | 0x15 | 0x01 | 0x11) . extend) @{arg_count = 1;} | ((0x0D | 0x1D | 0x19) . extend . extend) @{arg_count = 2;}) @logical_ora;
	BIT = ((0x24 . extend) @{arg_count = 1;} | (0x2C . extend . extend) @{arg_count = 2;}) @logical_bit;
	AAC = (((0x0B | 0x2B) . extend) @{arg_count = 1;}) @logical_and_accumulator_with_byte;
	AAX = (((0x87 | 0x97 | 0x83) . extend) @{arg_count = 1;} | (0x8F . extend . extend) @{arg_count = 2;}) @logical_and_accumulator_with_x;
	ARR = ((0x6B . extend) @{arg_count = 1;}) @logical_and_accumulator_with_byte_right_rotate;
	ASR = ((0x4B . extend) @{arg_count = 1;}) @logical_and_accumulator_with_byte_right_shift;
	ATX = ((0xAB . extend) @{arg_count = 1;}) @logical_and_accumulator_with_byte_store_x;
	AXA = ((0x93 . extend) @{arg_count = 1;} | (0x9F . extend . extend) @{arg_count = 2;}) @logical_and_accumulator_with_x_store_memory;
	AXS = (0xCB . extend @{arg_count = 1;}) @logical_and_accumulator_with_x_sub_byte;
	LAR = (0xBB . extend . extend @{arg_count = 2;}) @logical_and_mem_with_stack_pointer;
	SXA = (0x9E . extend . extend @{arg_count = 2;}) @logical_and_high_byte_with_x;
	SYA = (0x9C . extend . extend @{arg_count = 2;}) @logical_and_high_byte_with_y;
	XAS = (0x9B . extend . extend @{arg_count = 2;}) @logical_and_x_with_accumulator_store_in_stack;

	#arithmetic instuctions
	ADC = ((((0x69 | 0x65 | 0x75 | 0x61 | 0x71) . extend) @{arg_count = 1;}) | ((0x6D | 0x7D | 0x79) . extend . extend) @{arg_count = 2;}) @add;
	SBC = ((((0xE9 | 0xE5 | 0xF5 | 0xE1 | 0xF1 | 0xEB) . extend) @{arg_count = 1;}) | ((0xED | 0xFD | 0xF9) . extend . extend) @{arg_count = 2;}) @subtract;
	CMP = ((((0xC9 | 0xC5 | 0xD5 | 0xC1 | 0xD1) . extend) @{arg_count = 1;}) | ((0xCD | 0xDD | 0xD9) . extend . extend) @{arg_count = 2;}) @compare;
	CPX = (((0xE0 | 0xE4) . extend @{arg_count = 1;}) | ((0xEC) . extend . extend @{arg_count = 2;})) @compare_x;
	CPY = (((0xC0 | 0xC4) . extend @{arg_count = 1;}) | ((0xCC) . extend . extend @{arg_count = 2;})) @compare_y;

	#increments and decrements
	INC = (((0xE6 | 0xF6) . extend @{arg_count = 1;}) | ((0xEE | 0xFE) . extend . extend @{arg_count = 2;})) @inc;
	INX = (0xE8 @{arg_count = 0;}) @inc_x;
	INY = (0xC8 @{arg_count = 0;}) @inc_y;
	DEC = (((0xC6 | 0xD6) . extend @{arg_count = 1;}) | ((0xCE | 0xDE) . extend . extend @{arg_count = 2;})) @dec;
	DEX = (0xCA @{arg_count = 0;}) @dec_x;
	DEY = (0x88 @{arg_count = 0;}) @dec_y;
	DCP = (((0xC7 | 0xD7 | 0xC3 | 0xD3) . extend @{arg_count = 1;}) | ((0xCF | 0xDF | 0xDB) . extend . extend @{arg_count = 2;})) @dcp;

	#jumps and calls
	JMP = ((0x4C | 0x6C) . extend . extend @{arg_count = 2;}) @jump;
	JSR = ((0x20 . extend . extend) @{arg_count = 2;}) @jump_to_subroutine;
	RTS = (0x60 @{arg_count = 0;}) @return_from_subroutine;

	##branches
	BCC = ((0x90 . extend) @{arg_count = 1;}) @branch_if_carry_clear;
	BCS = ((0xB0 . extend) @{arg_count = 1;}) @branch_if_carry_set;
	BEQ = ((0xF0 . extend) @{arg_count = 1;}) @branch_if_equal;
	BNE = ((0xD0 . extend) @{arg_count = 1;}) @branch_if_not_equal;
	BMI = ((0x30 . extend) @{arg_count = 1;}) @branch_if_minus;
	BPL = ((0x10 . extend) @{arg_count = 1;}) @branch_if_positive;
	BVC = ((0x50 . extend) @{arg_count = 1;}) @branch_if_overflow_clear;
	BVS = ((0x70 . extend) @{arg_count = 1;}) @branch_if_overflow_set;

	##status flag changes
	CLC = (0x18 @{arg_count = 0;}) @clear_carry_flag;
	SEC = (0x38 @{arg_count = 0;}) @set_carry_flag;
	CLV = (0xB8 @{arg_count = 0;}) @clear_overflow_flag;
	SEI = (0x78 @{arg_count = 0;}) @set_interrupt_disable_flag;
	CLI = (0x58 @{arg_count = 0;}) @clear_interrupt_disable_flag;
	CLD = (0xD8 @{arg_count = 0;}) @clear_decimal_mode_flag;
	SED = (0xF8 @{arg_count = 0;}) @set_decimal_mode_flag;

	##shifts
	ASL = ((0x0A @{arg_count = 0;}) | ((0x06 | 0x16) . extend @{arg_count = 1;}) | ((0x0E | 0x1E) . extend . extend @{arg_count = 2;})) @arithmetic_shift_left;
	LSR = ((0x4A @{arg_count = 0;}) | ((0x46 | 0x56) . extend @{arg_count = 1;}) | ((0x4E | 0x5E) . extend . extend @{arg_count = 2;})) @logical_shift_right;
	ROL = ((0x2A @{arg_count = 0;}) | ((0x26 | 0x36) . extend @{arg_count = 1;}) | ((0x2E | 0x3E) . extend . extend @{arg_count = 2;})) @rotate_left;
	ROR = ((0x6A @{arg_count = 0;}) | ((0x66 | 0x76) . extend @{arg_count = 1;}) | ((0x6E | 0x7E) . extend . extend @{arg_count = 2;})) @rotate_right;

  Lexecute = (
    #system functions
    NOP | DOP | TOP | BRK | RTI | KIL |
    #load and store instructions
    LAX | LDA | LDX | LDY | STA | STX | STY |
		#register transfer instructions
		TAX | TAY | TXA | TYA |
		#stack operation instructions
		TSX | TXS | PHA | PHP | PLA | PLP |
		#logical instructions
		AND | EOR | ORA | BIT | AAC | AAX | ARR | ASR | ATX | AXA | AXS | LAR | SXA | SYA | XAS |
		#arithmetic instructions
		ADC | SBC | CMP | CPX | CPY |
		#increments and decrements
		INC | INX | INY | DEC | DEX | DEY | DCP |
		#jumps and calls
		JMP | JSR | RTS |
		#branches
		BCC | BCS | BEQ | BNE | BMI | BPL | BVC | BVS |
		#status flag changes
		CLC | SEC | CLV | CLI | SEI | CLD | SED |
		#shifts
		ASL | LSR | ROL | ROR
  );
    
  main := (Lexecute @cyclic_tasks)+;
}%%

%%write data;

CPUCore::CPUCore(){
	cycles = interrupt_period = 100;
	status    = 0;
	arg_count = 0;
	is_debug  = 0;	
	pstack    = MY_STACK_SIZE-1;
	is_jump_planned = 0;

	%%write init;
}

void CPUCore::run(){
	%%write exec;
}

void CPUCore::step(){
	char cmd = 0;	
	is_debug = 1;

	%%write exec;

	printf("[0x%.4X] ",(unsigned int)(p-arg_count));
  for(int i = arg_count; i >= 0;i--){
    printf("0x%.4X ",*(p-i));
  }
  printf("\n");
	while(cmd != 'n'){
		scanf("%c",&cmd);
		switch(cmd){
			case 'd' :
				printf("a : 0x%X\n",a_register);
				printf("x : 0x%X\n",x_register);
				printf("y : 0x%X\n",y_register);
				printf("s : 0x%X\n",status);
				break;
			case 'n':
				break;				
			default :
				break;
		}
	}	
}

void CPUCore::dump_core(CPUCore_dump* core){
	core->a_register = a_register;
	core->x_register = x_register;
	core->y_register = y_register;
	core->pstack     = pstack;
	core->status     = status;
	memcpy(core->m,m,RAM_SIZE);
}

void CPUCore::load_debug_code(char* fname){
	FILE* fp = fopen(fname,"rb");
	int fsize;

	if(!fp){
		printf("Unable to open input file!\n");
		exit(1);
	}

	fseek(fp,0,SEEK_END);
  fsize = ftell(fp);
	fseek(fp,0,SEEK_SET);
  fread(&m[ROM_START],sizeof(unsigned char),fsize,fp);
	p = &m[ROM_START];
	pe = p + fsize;
  fclose(fp);
}

void CPUCore::load_ines(char* fname){
	FILE* fp = fopen(fname,"rb");
	int fsize;

	if(!fp){
		printf("Unable to open input file!\n");
		exit(1);
	}
	
	/*first read in header*/
	/*now prg and char rom*/

	fseek(fp,0,SEEK_END);
  fsize = ftell(fp);
	fseek(fp,0,SEEK_SET);
  fread(&m[ROM_START],sizeof(unsigned char),fsize,fp);
	p = &m[ROM_START];
	pe = p + fsize;
  fclose(fp);
}
