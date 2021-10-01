/*************************************************************************************
 * SND_TC.H
 * 
 * Include Library routs for SNDH music playback
 *
 * [c] 2021 NoExtra-Team
 *************************************************************************************
 */
#ifndef	INCLUDED_SND_TC._H
#define	INCLUDED_SND_TC._H

/* ###################################################################################
#  PROTOTYPES
################################################################################### */

void Sndh_SetParameters( void * iSndhTune_File , int iSndhTune_Freq , int iSndhTune_Number );
void Sndh_ReplayStart( void );
void Sndh_ReplayStop( void );
long SuperOn( void );
void SuperOff( long adr );

/* ################################################################################ */

#endif	/* INCLUDED_SND_TC._H */