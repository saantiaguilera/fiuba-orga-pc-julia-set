#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <getopt.h>

#define VERSION "1.0.0"
#define BUFFER_LENGTH 1024
#define PGM_WIDTH 640
#define PGM_HEIGHT 480
#define COMPLEX_RECT_SIDE 4
#define RE_C 0.285
#define IM_C -0.01


void show_version() {
	printf("v%s\n", VERSION);
}

void show_help() {
	FILE *fp = fopen("julia-set.help", "r");

	char buffer[BUFFER_LENGTH];
	int buflen;
	while ((buflen = fread(buffer, sizeof(char), BUFFER_LENGTH, fp)) > 0)
		puts(buffer);
		
	fclose(fp);
}

void load_new_resolution(long* resolution_height, long* resolution_width, char optarg[]) {
	char* end;
	*resolution_width = strtol(optarg, &end, 10);
	*resolution_height = strtol(&end[1], NULL, 10);
}

void load_new_center(float* re_center, float* im_center, char optarg[]) {

}

void load_new_C(float* re_C, float* im_C, char optarg[]) {

}

int main (int argc, char *argv[]) {
	
	// el horror
	bool help, version, resolution, center, C, width, height, output;
	help = version = resolution = center = C = width = height = output = false;
	long resolution_height = PGM_HEIGHT;
	long resolution_width = PGM_WIDTH;
	float re_center = 0;
	float im_center = 0;
	float re_C = RE_C;
	float im_C = IM_C;
	float complex_plane_height = COMPLEX_RECT_SIDE;
	float complex_plane_width = COMPLEX_RECT_SIDE;
	char* output_file = NULL;
	
	// getopt setup
	int flag = 0;
	struct option opts[] = {
		{"version", no_argument, 0, 'v'},
		{"help", no_argument, 0, 'h'},
		{"resolution", required_argument, 0, 'r'},
		{"center", required_argument, 0, 'c'},
		{"C", required_argument, 0, 'C'},
		{"width", required_argument, 0, 'w'},
		{"height", required_argument, 0, 'H'},
		{"output", required_argument, 0, 'o'}
	};

	while ((flag = getopt_long(argc, argv, "vhr:c:C:w:H:o:", opts, NULL)) != -1) {
		switch (flag) {
			case 'v' :
				version = true;
				break;
			case 'h' :
				help = true;
				break;
			case 'r' :
				resolution = true;
				load_new_resolution(&resolution_height, &resolution_width, optarg);
				break;
			case 'c' :
				center = true;
				load_new_center(&re_center, &im_center, optarg);
				break;
			case 'C' :
				C = true;
				load_new_C(&re_C, &im_C, optarg);
				break;
			case 'w' :
				width = true;
				complex_plane_width = atof(optarg);
				break;
			case 'H' :
				height = true;
				complex_plane_height = atof(optarg);
				break;
			case 'o' :
				output = true;
				output_file = optarg; // Falta chequear si es "-" para que la salida sea stdout
				break;
		}
	}
	
	if (version)
		show_version();
	else if (help)
		show_help();
	else
		printf("JULIA SET\n resolution_height = %lu\n resolution_width = %lu\n re_center = %f\n im_center = %f\n re_C = %f\n im_C = %f\n complex_plane_height = %f\n complex_plane_width = %f\n output_file = %s\n", resolution_height, resolution_width, re_center, im_center, re_C, im_C, complex_plane_height, complex_plane_width, output_file);
		//julia_set(...);

	return EXIT_SUCCESS;
}
