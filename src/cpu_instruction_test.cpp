#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "2a03.h"

/*packs up memory and registers, etc*/
void pack_it(char* fname,CPUCore_dump* core){
	int i,j;
	FILE* fp = fopen(fname,"w+");
	if(!fp){
		printf("Unable to open dump file.\n");
		exit(1);
	}
	fprintf(fp,"%.2X\n",core->a_register);
	fprintf(fp,"%.2X\n",core->x_register);
	fprintf(fp,"%.2X\n",core->y_register);
	fprintf(fp,"%.2X\n",core->status);
	fprintf(fp,"%.2X\n",core->pstack);
	fprintf(fp,"%.2X\n",core->m[core->pstack+STACK_OFFSET+1]);

	for(i = STACK_OFFSET+MY_STACK_SIZE-1;i >= STACK_OFFSET;i--){
		fprintf(fp,"%.2X\n",core->m[i]);
	}

  for(i = 0;i<PAGE_SIZE;i+=16){
		fprintf(fp,"[%.4X-%.4X]",i,i+15);
		for(j = 0; j < 15; j++){
			fprintf(fp," %.2X",core->m[j+(i*15)]);
		}
		fprintf(fp,"\n");
  }
	fclose(fp);
}

int main(int argc,char** argv){
	if(argc > 2){
		/*init*/
		CPUCore cpu;
		CPUCore_dump core;

		cpu = CPUCore();
	
		cpu.load_debug_code(argv[1]);
		cpu.run();
		cpu.dump_core(&core);
		pack_it(argv[2],&core);
	}
	return 0;
}


