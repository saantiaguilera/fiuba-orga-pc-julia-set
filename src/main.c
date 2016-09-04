#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <getopt.h>

#include "complex.h"
#include "decoder.h"

#define VERSION "1.0.0"
#define BUFFER_LENGTH 1024

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

void load_new_resolution(int* resolution_height, int* resolution_width, char optarg[]) {
	char* end;
	*resolution_width = strtol(optarg, &end, 10);
	*resolution_height = strtol(&end[1], NULL, 10);
}

int write_image(char output_file[], int resolution_height, 
		int resolution_width, _complex *center, _complex *C, 
		float complex_plane_height, float complex_plane_width) {

	int ret_value = 0;
	_decoder decoder;
	decoder_init(&decoder, resolution_width, resolution_height, 
			complex_plane_width, complex_plane_height, center, C);
	FILE *fp;
	
	if (output_file == NULL) {
		fprintf(stderr, "Error: Archivo de salida no especificado.\n");
		return 1;
	
	} else if (strcmp("-", output_file) == 0) {
		fp = stdout;

	} else {
		fp = fopen(output_file, "wb");
		if (fp == NULL) {
			fprintf(stderr, "Error: No se pudo abrir el archivo de salida.\n");
			return 2;
		}
	}

	if (decoder_decode(&decoder, fp) != 0) {
		fprintf(stderr, "Error: No se pudo generar la imagen.\n");
		ret_value = 3;
	}
    
	if (strcmp("-", output_file) != 0) fclose(fp);

	return ret_value;
}

int main (int argc, char *argv[]) {

	bool help, version, resolution, new_center, new_C, width, height, output;
	help = version = resolution = new_center = new_C = width = height = output = false;
	int resolution_height = DEFAULT_IMAGE_HEIGHT;
	int resolution_width = DEFAULT_IMAGE_WIDTH;
	_complex center;
	complex_init(&center, DEFAULT_RENDER_CENTER_X, DEFAULT_RENDER_CENTER_Y);
	_complex C;
	complex_init(&C, DEFAULT_RATIO_X, DEFAULT_RATIO_Y);
	float complex_plane_height = DEFAULT_RENDER_HEIGHT;
	float complex_plane_width = DEFAULT_RENDER_WIDTH;
	char* output_file = NULL;
	
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
				new_center = true;
				strtoc(&center, optarg);
				break;
			case 'C' :
				new_C = true;
				strtoc(&C, optarg);
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
				output_file = optarg;
                break;
		}
	}
	
	if (version) show_version();
	else if (help) show_help();
	else {
		printf("JULIA SET\n resolution_height = %d\n resolution_width = %d\n"
                " re_center = %f\n im_center = %f\n re_C = %f\n im_C = %f\n"
                " complex_plane_height = %f\n complex_plane_width = %f\n" 
                " output_file = %s\n", resolution_height, resolution_width, 
                center.real, center.img, C.real, C.img, 
                complex_plane_height, complex_plane_width, output_file);

		write_image(output_file, resolution_height, resolution_width, &center,
                &C, complex_plane_height, complex_plane_width);
	}

	return EXIT_SUCCESS;
}
