/*************************************************************************************
 * PLAY_TC.C
 * 
 * Example Progam to Demonstrates SNDH music playback with Timer C
 *
 * [c] 2021 NoExtra-Team
 *************************************************************************************
 */

/* ###################################################################################
#  INCLUDES
################################################################################### */

#include <STDIO.H>

#include "NOEX.LIB\SND_TC.H"

/* ###################################################################################
#  DEFINES
################################################################################### */
                                                         /* Path to load sndh music */
#define SNDH_FILE "\\MYM_V161\\SOURCE\\C\\MUS\\ROLLOUT.SND"
#define	FREQUENCY 50                                          /* Frequency in Hertz */
#define	NUMOFMUSIC 1                    /* two musics inside the sndh file : 1 or 2 */

/* ###################################################################################
#  PROTOTYPES
################################################################################### */

void exit( int returnCode );
void free( void * pointer );

/* ###################################################################################
#  DATA
################################################################################### */

extern void * malloc();
typedef unsigned char Byte;
Byte * binaryFile;

/* ###################################################################################
#  CODE
################################################################################### */

/*-----------------------------------------------------------------------------------*
* FUNCTION : load_SndhFile( char * filename )
* ACTION   : Load sndh file
* CREATION : 30.09.2021 Zorro2^NoExtra
*-----------------------------------------------------------------------------------*/

int load_SndhFile( char * filename ) {
	FILE * inputFile;
	int inputFileSize;

	if ( ( inputFile=fopen (filename, "rb") ) == NULL )
	{
		fprintf(stderr, "Cannot open file %s\n", filename);
		exit(1);
	}
	fseek(inputFile, 0L, 2);
	inputFileSize = (int) ftell (inputFile);
	rewind(inputFile);
	binaryFile = (Byte *) malloc(inputFileSize);
	if ( binaryFile == NULL )
	{
		fprintf(stderr, "Not enough memory.\n");
		exit(2);
	}
	fread(binaryFile, inputFileSize, 1, inputFile);
	fclose(inputFile);
	return(1);
}

/*-----------------------------------------------------------------------------------*
* FUNCTION : free_mem( void )
* ACTION   : Flush memories
* CREATION : 30.09.2021 Zorro2^NoExtra
*-----------------------------------------------------------------------------------*/

void free_mem( void ) {
	free( (char *) binaryFile );
}

/*-----------------------------------------------------------------------------------*
* FUNCTION : main( void )
* ACTION   : Main program
* CREATION : 30.09.2021 Zorro2^NoExtra
*-----------------------------------------------------------------------------------*/

void main( void ) {
	load_SndhFile(SNDH_FILE);            /* Load sndh Song */
	                                     /* Init sndh Song */
	Sndh_SetParameters( (void *) binaryFile , (int) FREQUENCY, (int) NUMOFMUSIC );
	Sndh_ReplayStart();                  /* Play sndh Song */
	puts ("Press ENTER key to quit..."); /* Print a message */
	getchar();                           /* Wait for <ENTER> Key */
	Sndh_ReplayStop();                   /* Stop sndh Song */
	free_mem();                          /* flush memories */
}

/* ################################################################################ */
