#line 1 "src/ines.rl"
/*This machine currently does not support trainers!*/
/*This machine currently only checks for the mappers 0-15.*/
#ifndef _INES_H
	#include "ines.h"
#endif

#line 92 "src/ines.rl"



#line 13 "src/ines.c"
static const char _ines_actions[] = {
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 4, 1, 5, 1, 8, 2, 
	6, 8, 2, 7, 8
};

static const char _ines_key_offsets[] = {
	0, 0, 1, 2, 3, 4, 6, 8, 
	10, 12, 14, 16, 17, 18, 19, 20, 
	21, 22, 22
};

static const char _ines_trans_keys[] = {
	78, 69, 83, 26, 0, 64, 0, 64, 
	0, 127, 0, 127, 0, 127, 0, 1, 
	0, 0, 0, 0, 0, 0, 0
};

static const char _ines_single_lengths[] = {
	0, 1, 1, 1, 1, 0, 0, 0, 
	0, 0, 0, 1, 1, 1, 1, 1, 
	1, 0, 0
};

static const char _ines_range_lengths[] = {
	0, 0, 0, 0, 0, 1, 1, 1, 
	1, 1, 1, 0, 0, 0, 0, 0, 
	0, 0, 0
};

static const char _ines_index_offsets[] = {
	0, 0, 2, 4, 6, 8, 10, 12, 
	14, 16, 18, 20, 22, 24, 26, 28, 
	30, 32, 33
};

static const char _ines_trans_targs[] = {
	2, 0, 3, 0, 4, 0, 5, 0, 
	6, 0, 7, 0, 8, 0, 9, 0, 
	10, 0, 11, 0, 12, 0, 13, 0, 
	14, 0, 15, 0, 16, 0, 17, 0, 
	17, 18, 0
};

static const char _ines_trans_actions[] = {
	0, 0, 0, 0, 0, 0, 13, 0, 
	1, 0, 3, 0, 5, 0, 7, 0, 
	9, 0, 11, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 13, 0, 
	15, 18, 0
};

static const int ines_start = 1;
static const int ines_first_final = 19;
static const int ines_error = 0;

static const int ines_en_main = 1;
static const int ines_en_main_Ines_Chr = 18;

#line 95 "src/ines.rl"
INes::INes(char* fname){

	FILE* fp = fopen(fname,"rb");
	int fsize;

	if(!fp){
		printf("Unable to open input file!\n");
		exit(1);
	}

	c_count = 0;
	c_prg = 0;
	c_chr = 0;

	fseek(fp,0,SEEK_END);
  fsize = ftell(fp);
	fseek(fp,0,SEEK_SET);
  fread(p,sizeof(unsigned char),fsize,fp);
	pe = p + fsize;
  fclose(fp);

	
#line 96 "src/ines.c"
	{
	cs = ines_start;
	}
#line 117 "src/ines.rl"
	
#line 102 "src/ines.c"
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
    prg = (unsigned char*)malloc(sz_prg*sizeof(unsigned char)); 
  }
	break;
	case 1:
#line 15 "src/ines.rl"
	{ 
    sz_chr = *p;
    chr = (unsigned char*)malloc(sz_chr*sizeof(unsigned char));  
  }
	break;
	case 2:
#line 19 "src/ines.rl"
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
#line 27 "src/ines.rl"
	{
    vs_system = (*p) & (1<<0) ? false : true;
  }
	break;
	case 4:
#line 30 "src/ines.rl"
	{ 
		sz_ram = *p; 
	}
	break;
	case 5:
#line 33 "src/ines.rl"
	{
    pal  = (*p) & (1<<0) ? false : true;
  }
	break;
	case 6:
#line 36 "src/ines.rl"
	{
    if(c_prg > sz_prg){
      {cs = 18; goto _again;}
		}
    else{
      prg[c_prg] = *p;
			c_prg++;
		}
  }
	break;
	case 7:
#line 45 "src/ines.rl"
	{ 
    if(c_chr > sz_chr){
		} 
    else{
      chr[c_chr] = *p;
			c_chr++;
    }
  }
	break;
	case 8:
#line 54 "src/ines.rl"
	{
		c_count++;
	}
	break;
#line 247 "src/ines.c"
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
#line 118 "src/ines.rl"
}
