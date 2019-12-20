/**
 * Diese Datei enthält grundlegende Definitionen für die Verwendung von DLLs.
 * Dabei wird von den eigentlichen Betriebssystemenen (Linux und Windows)
 * abstrahiert.
 *
 * Definiert wird:
 * - DLLHandle: Datentyp für DLL-Handles (zum Laden einer DLL)
 * - DLLEXPORT: Deklaration zum Exportieren einer Variable/Funktion/Klasse
 *              in einer DLL
 * - DLLIMPORT: Deklaration zum Importieren einer Variable/Funktion/Klasse
 *              aus einer DLL
 */
#ifndef DEFS_H_
#define DEFS_H_


#ifndef B4_MSVC
/****************** LINUX ******************/

/* ein DLL-Handle ist hier ein void-Zeiger */
typedef void*	DLLHandle;

#if __GNUC__ >= 4
#define DLLEXPORT __attribute__ ((visibility ("default")))
#else
#define DLLEXPORT
#endif

/* explizite Deklarationen zum Import sind nicht notwendig */
#define DLLIMPORT

#else
/****************** WINDOWS ******************/

#if defined __cplusplus && defined _AFXDLL && !defined _WINDOWS_
#include <afx.h>	// asc: afxtempl.h soll nicht explizit angezogen werden!
#else
#include <windows.h>
#endif

/*
 * Windows definiert einen eigenen Datentyp für Handles (effektiv aber auch
 * nur ein void-Zeiger)
 */
typedef HINSTANCE	DLLHandle;

/* Deklarationen zum Export und Import von Variablen, Funktionen und Klassen */
#define DLLEXPORT __declspec(dllexport)
#define DLLIMPORT __declspec(dllimport)


/*********************************************/
#endif


/*
 * Hier folgen die Deklarationen für einzelne Module bzw. Modulgruppen.
 */
/* Core-DLL */
#ifdef B4_DISABLE_DLL
#define B4_COREDLL_EXPORT
#else
#ifdef BUILDING_COREDLL
#define B4_COREDLL_EXPORT	DLLEXPORT
#else
#define B4_COREDLL_EXPORT	DLLIMPORT
#endif
#endif	/* B4_DISABLE_DLL */

/* Dialog / NT-GUI */
#ifdef B4_DISABLE_DLL
#define B4_DIALOG_EXPORT
#define B4_NTGUI_EXPORT
#else
#ifdef BUILDING_DIALOG
#define B4_DIALOG_EXPORT	DLLEXPORT
#else
#define B4_DIALOG_EXPORT	DLLIMPORT
#endif
#ifdef BUILDING_NTGUI
#define B4_NTGUI_EXPORT		DLLEXPORT
#else
#define B4_NTGUI_EXPORT		DLLIMPORT
#endif
#endif	/* B4_DISABLE_DLL */

/* EDA */
#ifdef B4_DISABLE_DLL
#define B4_EDA_EXPORT
#else
#ifdef BUILDING_EDA
#define B4_EDA_EXPORT   DLLEXPORT
#else
#define B4_EDA_EXPORT   DLLIMPORT
#endif
#endif  /* B4_DISABLE_DLL */


#endif /*DEFS_H_*/
