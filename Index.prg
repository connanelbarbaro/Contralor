*-- PROGRAM FILE -------------------------------------------------------
*         Description : SISTEMA PARA PUB
*           File Name : Index.prg
*              Author : Carvalho Alejandro - HerculeSoft (c) 2007
*   Date Time Created : 08/20/2009 - 16:02
* Date Time updated :>: 02/16/2018 16:43
*             Comment : ORDENAR
*   History Update :>>:
*   02/08/18-02/16/18
*   02/04/18-02/05/18
*   01/26/18-02/02/18
*   03/30/13
*   03/28/13
*   03/12/13
*   06/06/12
*   06/04/12
*   05/28/12-05/29/12 Version Estable
*-----------------------------------------------------------------------
#include "oohg.ch"
#include "Contralor.ch"
//------------------------------------------------------------------------------
Function CreateDBF( oMeter, oLblMen )
     Local cFile := ""
     Local nTotal := 14
     Local nPos := 0
     Local cAlias

     lIsDir( "Error", .T. )
     lIsDir( "Datos", .T. )
     lIsDir( "Soporte", .T. )

//-------------------- TABLA
     ActuMeter( oMeter, @nTotal, @nPos )
     cFile := PathDatos() + "Tabla.DBF"
     if ! file ( cFile )
          dbcreate ( cFile , { { "cClaTAB"   , "C",     2,    0 }, ;
                               { "cCodTAB"   , "C",     4,    0 }, ;
                               { "cIncTAB"   , "C",    10,    0 }, ;
                               { "cDesTAB"   , "C",    40,    0 } } )
          GrabarTAB()
     endif
// DOCENTES
     ActuMeter( oMeter, @nTotal, @nPos )
     cFile := PathDatos() + "DOCENTES.DBF"
     if ! file ( cFile )
         dbcreate ( cFile , { { "cDni"       , "C",    10,    0 }, ;
                               { "cApeNom"   , "C",    30,    0 }, ;
                               { "cDir"      , "C",    30,    0 },;
                               { "cTel"      , "C",    30,    0 },;
                               { "cCel"      , "C",    30,    0 },;
                               { "ccp"       , "C",    4,    0 },;
                               { "cEmail"    , "C",    30,    0 },;
                               { "cCuit"     , "C",    15,    0 },;
                               { "cEcivil"   , "C",     4,    0 },;
                               { "nHijos"    , "N",     2,    0 },;
                               { "cSalario"  , "C",     2,    0 },;
                               { "cTitulo"   , "M",    10,    0 },;
                               { "dFecNac"   , "d",     8,    0 },;
                               { "dFecAnt"   , "d",     8,    0 },;
                               { "cListado"  , "c",     4,    0 },;
                               { "lActivo "  , "L",     1,    0 },;
                               { "cObs"      , "M",    10,    0 } } )
    endif

// CUPOF
     ActuMeter( oMeter, @nTotal, @nPos )
     cFile := PathDatos() + "CUPOF.DBF"
     if ! file ( cFile )
         dbcreate ( cFile , {  { "cCupof"    , "C",    10,    0 }, ;
                               { "cMateria"  , "C",    40,    0 }, ;
                               { "cSigla"    , "C",    10,    0 },;
                               { "cCurso"    , "C",     2,    0 },;
                               { "cDiv"      , "C",     2,    0 },;
                               { "cTipo"     , "C",     5,    0 },;
                               { "cCargaH"   , "N",     5,    0 },;
                               { "cObs"      , "M",    10,    0 },;
                               { "cTurno"    , "c",     5,    0 },;
                               { "cMod"      , "c",     5,    0 },;
                               { "cFuncion"  , "C",    20,    0 } })
    endif
// HORARIO CUPOF
     ActuMeter( oMeter, @nTotal, @nPos )
     cFile := PathDatos() + "HCUPOF.DBF"
     if ! file ( cFile )
         dbcreate ( cFile , {  { "cCupof"    , "C",    10,    0 }, ;
                               { "cDia"      , "C",     2,    0 }, ;
                               { "cDesde"    , "C",     5,    0 },;
                               { "cTipo"     , "C",     5,    0 },;
                               { "cTurno"    , "c",     5,    0 },;
                               { "cHasta"    , "C",     5,    0 }} )
    endif

// MOVIMIENTO
     ActuMeter( oMeter, @nTotal, @nPos )
     cFile := PathDatos() + "MOVIMIENTO.DBF"
     if ! file ( cFile )
          dbcreate ( cFile , { { "cDNI"      , "C",    10,    0 }, ;
                               { "cDNIS"     , "C",    10,    0 }, ;
                               { "cCupof"    , "C",    10,    0 }, ;
                               { "dDesde"    , "d",     8,    0 },;
                               { "dHasta"    , "d",     8,    0 },;
                               { "cSitRev"   , "C",     5,    0 },;
                               { "lActivo"   , "L",     1,    0 }} )
    endif

// TURNO
     ActuMeter( oMeter, @nTotal, @nPos )
     cFile := PathDatos() + "TURNO.DBF"
     if ! file ( cFile )
          dbcreate ( cFile , { { "nHora"     , "N",    1,    0 }, ;
                               { "cDesde"    , "C",    10,    0 }, ;
                               { "cHasta"    , "C",    10,    0 }, ;
                               { "cRecreo"   , "C",    10,    0 }} )
     endif
// INASISTENCIA
     ActuMeter( oMeter, @nTotal, @nPos )
     cFile := PathDatos() + "AUSENCIAS.DBF"
     if ! file ( cFile )
          dbcreate ( cFile , { { "dFecha"    , "D",     8,    0 }, ;
                               { "cDNI"      , "C",    10,    0 }, ;
                               { "lEstado"   , "L",     1,    0 }} )  // .F. sin justificar
     endif
 // LICENCIAS
     ActuMeter( oMeter, @nTotal, @nPos )
     cFile := PathDatos() + "LICENCIAS.DBF"
     if ! file ( cFile )
          dbcreate ( cFile , { { "dDesde"    , "D",     8,    0 }, ;
                               { "dHasta"    , "D",     8,    0 }, ;
                               { "cDNI"      , "C",    10,    0 }, ;
                               { "cArt"      , "C",     4,    0 }, ;
                               { "cInc"      , "C",    10,    0 }} )
     endif



   return ( NIL )

//------------------------------------------------------------------------------
Function Ordenar( oMeter, oLblMen )
     Local cCDX
     Local nTotal := 6
     Local nPos := 0

/*
01 - CODIGO POSTALES
02 - LISTADO
03 - MODULOS
04 - ESTADO CIVIL
05 - MODALIDAD
06 - TIPO DOCUMENTO
07 - SEXO
08 - SITUACION DE REVISTA
09 - MOVIEMINTO ALTA
10 - MOVIMIENTO
11 - MOVIMIENTO CESE
12 - LICENCIAS
13 - TURNO
*/

     if DBFindex ( "Tabla", @cCDX, @oMeter, oLblMen, @nTotal, @nPos )
          index on cClaTAB + cCodTAB tag TABcod to ( cCDX ) for !deleted()
          index on cCodTAB+cIncTAB+cDesTAB tag TABdes to ( cCDX ) for !deleted()
          index on cCodTAB tag TABlic1 to ( cCDX ) for !deleted() .and. cClaTAB= "12" UNIQUE
          index on cIncTAB tag TABlic2 to ( cCDX ) for !deleted() .and. cClaTAB= "12"
          close all
     Endif

     if DBFindex ( "Docentes", @cCDX, @oMeter, oLblMen, @nTotal, @nPos )
          index on cDNI tag docdni to ( cCDX ) for !deleted() UNIQUE
          index on cApeNom tag DOCnom to ( cCDX ) for !deleted()

          close all
     Endif

     if DBFindex ( "Cupof", @cCDX, @oMeter, oLblMen, @nTotal, @nPos )
          index on cCupof tag CupofCod to ( cCDX ) for !deleted()  UNIQUE
          index on cMateria tag CupofMateria to ( cCDX ) for !deleted()
          close all
     Endif

     if DBFindex ( "HCupof", @cCDX, @oMeter, oLblMen, @nTotal, @nPos )
          index on cCupof tag HCupof to ( cCDX ) for !deleted()
          index on cDIA tag HCupofDIA to ( cCDX ) for !deleted()
          close all
     Endif
     if DBFindex ( "Movimiento", @cCDX, @oMeter, oLblMen, @nTotal, @nPos )
          index on cCupof tag MOVcupof to ( cCDX ) for !deleted()
          index on cDNIs tag MOVdnis to ( cCDX ) for !deleted()
          index on dtoc(dDesde) tag MOVdesde to ( cCDX ) for !deleted()
          index on cCupof tag MOVactivo to ( cCDX ) for !deleted() .and. lActivo = .T.
          index on cDNIs tag MOVtit to ( cCDX ) for !deleted()  .and. lActivo = .T. .and. nSitRev = 1
          index on cDNI+cCupof tag MOVsup to ( cCDX ) for !deleted()  .and. nSitRev = 4
          close all
     Endif

     if DBFindex ( "Ausencias", @cCDX, @oMeter, oLblMen, @nTotal, @nPos )
          index on cdni+DTOC( DFECHA) tag AUSfecha to ( cCDX ) for !deleted() .and. lEstado = .F.
          close all
     Endif

     if DBFindex ( "Licencias", @cCDX, @oMeter, oLblMen, @nTotal, @nPos )
          index on DTOC( dDesde ) tag LICfecha to ( cCDX ) for !deleted()
          close all
     Endif

   return ( NIL )

//------------------------------------------------------------------------------
Static Func DBFindex ( cDBF, cCDX, oMeter, oLblMen, nTotal, nPos )

     oLblMen:Value := "Ordenando " + cDBF
     cDBF := PathDatos() + cDBF
     cCDX := cDBF + ".cdx"

     ActuMeter( oMeter, @nTotal, @nPos )
     If ! file ( cDBF + ".dbf" )
          return ( .F. )
     Endif
     use ( cDBF ) new exclusive
     If ! neterr()
          pack
          if file ( cCDX )
               ferase( cCDX )
          endif
          return ( .T. )
     Endif
     return ( .F. )

Function GrabarTAB()
/*
     1 - Ciudades
     2 - LISTADO
     3 - TIPO
     4 - estado Civil

*/

     Local aDatos := {}, nPos, cAliasTAB

// CODIGO POSTALES
     aadd(aDatos, { "1", "2800", "Zarate - Lima" })
     aadd(aDatos, { "1", "2804", "Campana" })
     aadd(aDatos, { "1", "2804", "Campana" })
     aadd(aDatos, { "1", "9999", "[ Sin Descripcion ]" })
// LISTADO
     aadd(aDatos, { "2", "0001", "Listado Oficial" })
     aadd(aDatos, { "2", "0002", "Listado 108 A" })
     aadd(aDatos, { "2", "0003", "Listado 108 B" })
     aadd(aDatos, { "2", "0004", "Listado de Emergencia" })
     aadd(aDatos, { "2", "0005", "Listado Superior" })
     aadd(aDatos, { "2", "9999", "[ Sin Descripcion ]" })
// TIPO
     aadd(aDatos, { "3", "0001", "Modulos" })
     aadd(aDatos, { "3", "0002", "Horas Catedras" })
     aadd(aDatos, { "3", "0003", "Cargo" })
     aadd(aDatos, { "3", "9999", "[ Sin Descripcion ]" })
// estado civil
     aadd(aDatos, { "4", "0001", "Soltero" })
     aadd(aDatos, { "4", "0002", "Casado" })
     aadd(aDatos, { "4", "0003", "Divorciado" })
     aadd(aDatos, { "4", "0004", "Viudo" })
     aadd(aDatos, { "4", "0005", "Otro" })
     aadd(aDatos, { "4", "9999", "[ Sin Descripcion ]" })
     aadd(aDatos, { "0", "0001", "Si" })
     aadd(aDatos, { "0", "0002", "No" })
     cAliasTAB := AbrirDBF( "TABLA" )
     FOR nPos = 1 to 15
          ( cAliasTAB )->( dbAppend() )
          ( cAliasTAB )->( RLock() )
          ( cAliasTAB )->cClaTAB := aDatos[ nPos, 1 ]
          ( cAliasTAB )->cCodTAB := aDatos[ nPos, 2 ]
          ( cAliasTAB )->cDesTAB := aDatos[ nPos, 3 ]
          ( cAliasTAB )->( dbcommit() )
          ( cAliasTAB )->( dbUnlock() )
     next nPos
     CerrarDBF( { cAliasTAB } )
     RETURN NIL

Static Function GrabarCFG()
     Local cAliasCFG
/*
     cAliasCFG := AbrirDBF( "CFG" )
     ( cAliasCFG )->( dbAppend() )
     ( cAliasCFG )->( RLock() )
     ( cAliasCFG )->cRsCFG := "Su Empresa"
     ( cAliasCFG )->cNomCFG := "Su Nombre"
     ( cAliasCFG )->cCUITCFG := "99-99999999-9"
     ( cAliasCFG )->cIVACFG := "9999"
     ( cAliasCFG )->cIBcfg := "99-99999999-9"
     ( cAliasCFG )->CFiniCFG := DTOS( date() )
     ( cAliasCFG )->cDirCFG := "Domicilio"
     ( cAliasCFG )->cCpCFG := "9999"
     ( cAliasCFG )->cTelCFG := "011-9999-99999"
     ( cAliasCFG )->cFaxCFG := "011-9999-99999"
     ( cAliasCFG )->cEmailCFG := "xxxxxxxxxxxx@xxxxxx.com"
     ( cAliasCFG )->cWeb := "www.xxxxxxxxxxxx.com"
     ( cAliasCFG )->( dbUnlock() )
     ( cAliasCFG )->( dbcommit() )
     CerrarDBF( { cAliasCFG } )
*/
     Return( NIL )


Function lActivo( oMeter, oLblMen )
     Local cAliasMOV, cAliasDOC
     Local nTotal := 0
     Local nPos := 0
     LOcal nDatos := 0

/*
     cAliasDOC := AbrirDBF( "Docentes", "DOCnom" )
     cAliasMov := AbrirDBF( "Movimiento", "CupofCOD" )
     nTotal := ( cAliasDOC )->( LastREc() )
     ( cAliasDOC )->( dbgotop() )
     do while !( cAliasDOC )->( eof())
          nPos = nPos + 1
          ActuMeter( oMeter, @nTotal, @nPos )
          ( cAliasMov )->( dbclearfilter() )
          ( cAliasMov )->( dbsetfilter( {|| cDNIS = ( cAliasDOC )->cdni .and. lActivo = .F. } ) )
          ( cAliasMov )->( dbgotop() )
          nDatos := 0
          ( cAliasMOV )->( dbeval( { || nDatos+= 1 } ) )
          ( cAliasDOC )->( dbrlock() )
          if nDatos > 0
               ( cAliasDOC )->lActivo := .T.
          else
               ( cAliasDOC )->lActivo := .F.
          endif
          ( cAliasDOC )->( dbcommit() )
          ( cAliasDOC )->( dbUnlock() )
          ( cAliasDOC )->( dbskip() )
     enddo
     CerrarDBF( {cAliasMOV, cAliasDOC } )
     return( nil )
*/
     cMOv := ""
     cAliasMov :=AbrirDBF( "Movimiento", "MOVdnis" )
     nTotal := ( cAliasMov )->( LastREc() )
     ( cAliasMov )->( dbgotop() )
     do while !( cAliasMov )->( eof() )
          ActuMeter( oMeter, @nTotal, @nPos )

          ( cAliasMov )->( dbrlock() )
          cMov =alltrim( ( cAliasMov )->cSitRev )
          ( cAliasMov )->cSitRev = cMov
          ( cAliasMov )->( dbcommit() )
          ( cAliasMov )->( dbUnlock() )
          ( cAliasMov )->( dbskip() )
     enddo
     CerrarDBF( {cAliasMOV } )
