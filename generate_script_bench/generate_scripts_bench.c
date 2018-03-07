
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>


#define MEMORIES_TAB_SIZE 6
#define TIME_LIMITS_TAB_SIZE 4
#define DIRECTORY_NAME_SIZE 255
#define FILE_NAME_SIZE 255

int main(int argc, char const *argv[])
{	
	struct stat st = {0};
	int i, j;
	int memories_tab_size;
	int time_limits_tab_size;
	int memory_sizes[MEMORIES_TAB_SIZE] = {4096, 8192, 16384, 32768, 65536, 124928};
	int time_limits[TIME_LIMITS_TAB_SIZE] = {120, 10080, 20160, 120960};
	char* directory_name;
	char* file_name;
	FILE* file;

	fprintf(stderr, "-- BEGIN GENERATION --\n");

	/* Directories creation */
	for (i=0; i < TIME_LIMITS_TAB_SIZE; i++)
	{
		// Root directory that will contain the scripts
		if (stat("scripts_test", &st) == -1) 
		{
		    mkdir("scripts_test", 0700);
		}

		directory_name = (char *) malloc (DIRECTORY_NAME_SIZE * sizeof(char));
		sprintf(directory_name, "scripts_test/scripts_%d_%d_min", i, time_limits[i]);
		if (stat(directory_name, &st) == -1) 
		{
		    mkdir(directory_name, 0700);
		}

		for (j = 0; j < MEMORIES_TAB_SIZE; j++)
		{	
			file_name = (char *) malloc (FILE_NAME_SIZE * sizeof(char));
			sprintf(file_name, "%s/test_job_%d_%dmn_%dMb.sh", directory_name, j, time_limits[i], memory_sizes[j]);

			fprintf(stderr, "\t -- GENERATE %s --\n", file_name);

			file = fopen (file_name, "w+");
			fprintf(file, "#/bin/bash\n");
			fprintf(file, "#SBATCH --nodes=1\n");
			fprintf(file, "#SBATCH --ntasks=1\n");
			fprintf(file, "#SBATCH --time=%d\n", time_limits[i]);
			fprintf(file, "#SBATCH --mem=%d\n", memory_sizes[j]);
			fprintf(file, "#SBATCH --job-name=\"test_%dmn_%d_mb\"\n", time_limits[i], memory_sizes[j]);
			fprintf(file, "#SBATCH --partition=compute\n");
			fprintf(file, "hostname\n");
			fprintf(file, "sleep 10\n");

			fclose(file);
			free(file_name);
		}

		free (directory_name); 
	}



	fprintf(stderr, "-- END GENERATION --\n");
	return 0;
}