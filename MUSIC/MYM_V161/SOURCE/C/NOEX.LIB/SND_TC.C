/*************************************************************************************
 * SND_TC.C
 * 
 * Include Library routs SNDH music playback
 *
 * [c] 2021 NoExtra-Team
 *************************************************************************************
 */

/* ###################################################################################
#  INCLUDES
################################################################################### */

#include	<TOS.H>
#include	"NOEX.LIB\SND_TC.H"

/* ###################################################################################
#  DATA
################################################################################### */

typedef unsigned int u32;
void * iSndhTune;
u32 iSndhFrequency;
u32 iSndhNumberOfMusic;

/* ###################################################################################
#  PROTOTYPES
################################################################################### */

extern void Asm_SndhPlay( void );
extern void Asm_SndhStop( void );

/* ###################################################################################
#  CODE
################################################################################### */

/*-----------------------------------------------------------------------------------*
* FUNCTION : Sndh_SetParameters ( void * iSndhTune_File , int iSndhTune_Freq , int iSndhTune_Number )
* ACTION   : Set Parameters to play music
* CREATION : 30.09.2021 Zorro2^NoExtra
*-----------------------------------------------------------------------------------*/

void Sndh_SetParameters ( void * iSndhTune_File , int iSndhTune_Freq , int iSndhTune_Number ) {
	iSndhTune          = iSndhTune_File;
	iSndhFrequency     = (u32) iSndhTune_Freq;
	iSndhNumberOfMusic = (u32) iSndhTune_Number;
}

/*-----------------------------------------------------------------------------------*
* FUNCTION : Sndh_ReplayStop ( void )
* ACTION   : Stop music
* CREATION : 30.09.2021 Zorro2^NoExtra
*-----------------------------------------------------------------------------------*/

void Sndh_ReplayStop ( void ) {
	long adr;

	adr = SuperOn();
	Asm_SndhStop();
	SuperOff( adr );
}

/*-----------------------------------------------------------------------------------*
* FUNCTION : Sndh_ReplayStart ( void )
* ACTION   : Replay music
* CREATION : 30.09.2021 Zorro2^NoExtra
*-----------------------------------------------------------------------------------*/

void Sndh_ReplayStart ( void ) {
	long adr;

	adr = SuperOn();
	Asm_SndhPlay();
	SuperOff( adr );
}

/*-----------------------------------------------------------------------------------*
* FUNCTION : SuperOn ( void )
* ACTION   : Supervisormode
* CREATION : 30.09.2021 Zorro2^NoExtra
*-----------------------------------------------------------------------------------*/
long SuperOn( void ) {
	return( Super( (void *) 1L ) ? 0L : Super( (void *) 0L ) );
}


/*-----------------------------------------------------------------------------------*
* FUNCTION : SuperOff ( long adr )
* ACTION   : Usermode
* CREATION : 30.09.2021 Zorro2^NoExtra
*-----------------------------------------------------------------------------------*/
void SuperOff( long adr ) {
	if( adr ) Super( (void *) adr );
}

/* ################################################################################ */
