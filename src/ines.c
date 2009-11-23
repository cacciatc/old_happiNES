#line 1 "src/ines.rl"
/*This machine currently does not support trainers!*/
/*This machine currently only checks for the mappers 0-15.*/
#ifndef _INES_H
	#include "ines.h"
#endif

#line 91 "src/ines.rl"



#line 13 "src/ines.c"
static const char _ines_actions[] = {
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 4, 1, 5, 1, 6, 1, 
	7
};

static const char _ines_key_offsets[] = {
	0, 0, 1, 2, 3, 4, 4, 4, 
	4, 4, 4, 6, 7, 8, 9, 10, 
	11, 12, 12
};

static const char _ines_trans_keys[] = {
	78, 69, 83, 26, 0, 1, 0, 0, 
	0, 0, 0, 0, 0
};

static const char _ines_single_lengths[] = {
	0, 1, 1, 1, 1, 0, 0, 0, 
	0, 0, 0, 1, 1, 1, 1, 1, 
	1, 0, 0
};

static const char _ines_range_lengths[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 1, 0, 0, 0, 0, 0, 
	0, 0, 0
};

static const char _ines_index_offsets[] = {
	0, 0, 2, 4, 6, 8, 9, 10, 
	11, 12, 13, 15, 17, 19, 21, 23, 
	25, 27, 28
};

static const char _ines_trans_targs[] = {
	2, 0, 3, 0, 4, 0, 5, 0, 
	6, 7, 8, 9, 10, 11, 0, 12, 
	0, 13, 0, 14, 0, 15, 0, 16, 
	0, 17, 0, 17, 18, 0
};

static const char _ines_trans_actions[] = {
	0, 0, 0, 0, 0, 0, 0, 0, 
	1, 3, 5, 7, 9, 11, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 13, 15, 0
};

static const int ines_start = 1;
static const int ines_first_final = 19;
static const int ines_error = 0;

static const int ines_en_main = 1;
static const int ines_en_main_Ines_Chr = 18;

#line 94 "src/ines.rl"

Ines::Ines(){
	c_prg = 0;
	c_chr = 0;
}

void Ines::load_rom(char* fname){
	FILE* fp = fopen(fname,"rb");
	int fsize;

	if(!fp){
		printf("Unable to open input file!\n");
		exit(1);
	}

	fseek(fp,0,SEEK_END);
  fsize = ftell(fp);
	fseek(fp,0,SEEK_SET);
	p = (unsigned char*)malloc(fsize*sizeof(unsigned char));
  fread(p,sizeof(unsigned char),fsize,fp);
	pe = p + fsize;
  fclose(fp);

	
#line 95 "src/ines.c"
	{
	cs = ines_start;
	}
#line 118 "src/ines.rl"
	
#line 101 "src/ines.c"
	{
	int _klen;
	unsigned int _trans;
	const char *_acts;
	unsigned int _nacts;
	const char *_keys;

	if ( p == pe )
		goto _test_eof;
	if ( cs == 0 )
		goto _out;
_resume:
	_keys = _ines_trans_keys + _ines_key_offsets[cs];
	_trans = _ines_index_offsets[cs];

	_klen = _ines_single_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + _klen - 1;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + ((_upper-_lower) >> 1);
			if ( (*p) < *_mid )
				_upper = _mid - 1;
			else if ( (*p) > *_mid )
				_lower = _mid + 1;
			else {
				_trans += (_mid - _keys);
				goto _match;
			}
		}
		_keys += _klen;
		_trans += _klen;
	}

	_klen = _ines_range_lengths[cs];
	if ( _klen > 0 ) {
		const char *_lower = _keys;
		const char *_mid;
		const char *_upper = _keys + (_klen<<1) - 2;
		while (1) {
			if ( _upper < _lower )
				break;

			_mid = _lower + (((_upper-_lower) >> 1) & ~1);
			if ( (*p) < _mid[0] )
				_upper = _mid - 2;
			else if ( (*p) > _mid[1] )
				_lower = _mid + 2;
			else {
				_trans += ((_mid - _keys)>>1);
				goto _match;
			}
		}
		_trans += _klen;
	}

_match:
	cs = _ines_trans_targs[_trans];

	if ( _ines_trans_actions[_trans] == 0 )
		goto _again;

	_acts = _ines_actions + _ines_trans_actions[_trans];
	_nacts = (unsigned int) *_acts++;
	while ( _nacts-- > 0 )
	{
		switch ( *_acts++ )
		{
	case 0:
#line 11 "src/ines.rl"
	{ 
    sz_prg = *p;
    prg = (unsigned char*)malloc(sz_prg*16*1024*sizeof(unsigned char));
  }
	break;
	case 1:
#line 15 "src/ines.rl"
	{ 
    sz_chr = *p;
		if(sz_chr == 0)
			sz_chr = 1;
    chr = (unsigned char*)malloc(sz_chr*8*1024*sizeof(unsigned char));  
  }
	break;
	case 2:
#line 21 "src/ines.rl"
	{ 
    vertical_mirroring   = (*p) & (1<<0) ? false : true;
    horizontal_mirroring = !vertical_mirroring;  
    battery_ram          = (*p) & (1<<1) ? false : true;
    trainer              = (*p) & (1<<2) ? false : true;
    four_chr             = (*p) & (1<<3) ? false : true;
    map_type             = ((*p)&(1<<4))*1 + ((*p)&(1<<5))*2 + ((*p)&(1<<6))*4 + ((*p)&(1<<7))*8;
  }
	break;
	case 3:
#line 29 "src/ines.rl"
	{
    vs_system = (*p) & (1<<0) ? false : true;
  }
	break;
	case 4:
#line 32 "src/ines.rl"
	{ 
		sz_ram = *p; 
	}
	break;
	case 5:
#line 35 "src/ines.rl"
	{
    pal  = (*p) & (1<<0) ? false : true;
  }
	break;
	case 6:
#line 38 "src/ines.rl"
	{
    if(c_prg > get_prg_size()){
      {cs = 18; goto _again;}
		}
    else{
      prg[c_prg] = (unsigned char)*p;
			c_prg++;
		}
  }
	break;
	case 7:
#line 47 "src/ines.rl"
	{ 
    if(c_chr > get_chr_size()){
			{p++; goto _out; }
		} 
    else{
      chr[c_chr] = (unsigned char)*p;
			c_chr++;
    }
  }
	break;
#line 243 "src/ines.c"
		}
	}

_again:
	if ( cs == 0 )
		goto _out;
	if ( ++p != pe )
		goto _resume;
	_test_eof: {}
	_out: {}
	}
#line 119 "src/ines.rl"
	if(!p)
		free(p);
}

void Ines::clean_up(){
	if(!p)
		free(p);
}
