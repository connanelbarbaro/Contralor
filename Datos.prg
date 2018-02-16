*-- PROGRAM FILE -------------------------------------------------------
*         Description : SISTEMA PARA REMATES DE SALON
*           File Name : Main.prg
*              Author : Carvalho Alejandro - HerculeSoft (c) 2007
*   Date Time Created : 10/29/2009 - 08:02
* Date Time updated :>: 01/27/2018 16:09
*             Comment : MODULO PRINCIPAL
*   History Update :>>:
*   01/27/18
*   06/01/13-06/02/13
*   05/22/13
*-----------------------------------------------------------------------
#include "oohg.ch"
// #include "Pub.ch"

Function Datos( oMeter, oLblMen)

     LOCAL nLineLength := 150, nTabSize := 0, lWrap := .T., cFile := "Libro3.cvs"
     LOCAL nLines, nCurrentLine, cString, J
     Local cAlias
     Local nTotal, nPos := 0

     Local aDatos:= array( 20 )

     cAlias := AbrirDBF( "DOCENTES", .T. )
     zap

     cString = MEMOREAD(cFile)
     nLines := MLCOUNT( cString, nLineLength, nTabSize, lWrap)
     nTotal := nLines
     FOR nCurrentLine := 1 TO nLines
          For J = 1 to 15
               cLinea := MEMOLINE(cString, nLineLength, nCurrentLine, nTabSize, lWrap)
               aDatos[ J ] := Left( cLinea, AT( ";", cLinea )-1 )
          next J

          ( cAliasALU )->( dbAppend() )
          ( cAliasALU )->( RLock() )
          ( cAliasALU )->cID := cID
          ( cAliasALU )->cTipo := cTipo
          ( cAliasALU )->cDNI := cDNI
          ( cAliasALU )->cApenom := cApenom
          ( cAliasALU )->lCargado := lCargado
          ( cAliasALU )->cCurso := cCurso
          ( cAliasALU )->lContrato := lContrato
          ( cAliasALU )->lDNI := lDNI
          ( cAliasALU )->lCUIL := lCUIL
          if AT( "-", cRcuil ) > 0
               ( cAliasALU )->cRDNI := SUBSTR( cRcuil, 4, LEN( cRcuil )-5 )
          else
               ( cAliasALU )->cRDNI := cRcuil
          endif
          ( cAliasALU )->cRapenom := cRapenom
          ( cAliasALU )->cObs := cObs
          ( cAliasALU )->( dbcommit() )
          ( cAliasALU )->( dbUnlock() )
       NEXT
       CerrarDBF( { cAliasALU } )
       RETURN( nil )
