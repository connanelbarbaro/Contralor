*-- PROGRAM FILE -------------------------------------------------------
*         Description : FACTURACION
*           File Name : Funciones.prg
*              Author : Carvalho Alejandro - HerculeSoft (c) 2007
*   Date Time Created : 08/11/2009 - 23:48
* Date Time updated :>: 02/12/2018 17:34
*             Comment : FUNCIONES VARIAS
*   History Update :>>:
*   02/10/18-02/12/18
*   02/04/18-02/07/18
*   01/31/18-02/02/18
*   01/28/18-01/29/18
*   01/26/18
*   06/12/12-06/14/12
*   06/04/12-06/06/12
*   05/28/12-05/29/12 Version Estable
*-----------------------------------------------------------------------
#include "oohg.ch"
#include "Contralor.ch"
#include "fILEIO.ch"
//---------------------------------------------------------------------------------------------------------------------------------------
Function Stod( cFecha )
     return( ctod( Right( cFecha, 2 ) + "/" + substr( cFecha, 5, 2 ) + "/" + left( cFecha, 4 ) ) )

//---------------------------------------------------------------------------------------------------------------------------------------
Function Nocero( uVal )
     return( IIF( uVal = 0, "", uVal ) )

//---------------------------------------------------------------------------------------------------------------------------------------
Function EnDesarrollo()
     return( MsgStop( "MODULO EN DESARROLLO", "AVISO DEL SISTEMA" ) )

//---------------------------------------------------------------------------------------------------------------------------------------
Function IniPrint( oPrint, lLandscape )
/*
     ::selprinter(lselect,lpreview,llandscape,npapersize,cprinterx)

     Inicializa impresora,
     lselect=  .T.  muestra cuadro de dialogo para seleccionar impresora
     lselect=  .F.  toma impresora por defecto
     lpreview= .T. muestra preliminar antes de imprimir
     lpreview= .F.  no muestra preliminar
     llandscape= .T. impresion horizontal
     llanscape=.F.   impresion vertical
     npapersize =  tama¤o del papel segun standares del hbprinter
     cprinterx =  nombre de la impresora si se quiere hacer una impresion directa
     sin que sea la impresora por defecto o la seleccione por dialogo.
*/

     oPrint := tprint( "HBPRINTER" )
     oPrint:init()
     oPrint:selprinter( .T. , .T., llandscape, DMPAPER_LETTER  )
     if oPrint:lprerror
          oPrint:release()
          MsgStop( "Error En Impresora. Verifique", "Aviso Del Sistema" )
          return( .F. )
     endif
     oPrint:begindoc()
     oPrint:setpreviewsize( 1 )
     return( .T. )

//---------------------------------------------------------------------------------------------------------------------------------------
Function HeadRpt( oPrint, nLin, cTit, aHead, aPos, lLandscape, nDatos, nPag )
     Local nLen := Len( aHead )
     Local nReg := iif( lLandscape, 40, 55 )
     Local nPos := iif( lLandscape, 105, 80 )

     nLin ++
     if nLin > nReg
          IF nLin <= 999
               FooterRpt( oPrint, lLandscape, nDatos, @nPag )
          endif
          oPrint:beginpage()
          oPrint:settmargin( 2 )
          oPrint:printdata( 0, nPos - 11, Dtoc( date() ),"Courier New", 12, .T. )
          oPrint:printdata( 1, nPos - 11, Time(),"Courier New", 12, .T. )
          oPrint:printdata( 0, 5, "Escuela","Courier New", 12, .T. )
          oPrint:printdata( 1, 5, cTit,"Courier New", 12, .T. )
          oprint:printline( 4,0,4, nPos )

          for nPos = 1 to nLen
               oPrint:printdata( 3, aPos[ nPos ], aHead[ nPos ][ 2 ] ,"Courier New", 12, .T. )
          next
          nLin :=5
     endif
     return( nil )

//---------------------------------------------------------------------------------------------------------------------------------------
Function FooterRpt( oPrint, lLandscape, nDatos, nPag )
     Local nlinea := iif( lLandscape, 42, 57 )
     Local nPos := iif( lLandscape, 105, 80 )
     Local nTotPag := Int( nDatos / ( nLinea - 3 )  ) + 1

     nPag++
     oprint:printline( nlinea, 0, nlinea, nPos )
     nlinea++
     oPrint:printdata( nlinea, 1, "Pagina " + strzero( nPag, 3 ) + " / " + strzero( nTotPag, 3 ) ,"Courier New", 12, .T. )
     oPrint:endpage()
     return( NIL )

//---------------------------------------------------------------------------------------------------------------------------------------
Function Refresh( cAlias, cWin, cBrw )

     ( cAlias )->( dbgotop() )
     Sp( cWin, cBrw, "value", ( cAlias )->( recno() ) )
     dm( cWin, cBrw, "SetFocus" )
     dm( cWin, cBrw, "Refresh" )
     DO EVENTS
     return( nil )

//---------------------------------------------------------------------------------------------------------------------------------------
// APLICAR UN METODO
// domethod(Ventana,'Browse_1','setfocus')
Function dm( uPar1, uPar2, uPar3 )

     Return( domethod ( uPar1, uPar2, uPar3 ) )

//---------------------------------------------------------------------------------------------------------------------------------------
// EXTRAER UN DATO
// GetProperty(cWindow,'TCosto','Value')
Function Gp( uPar1, uPar2, uPar3 )
     Return( GetProperty ( uPar1, uPar2, uPar3 ) )

//---------------------------------------------------------------------------------------------------------------------------------------
//ASIGNAR UN DATO
// sp(Ventana,'ButtonUtilidad','enabled',.t.)
Function Sp( uPar1, uPar2, uPar3, uPar4 )
     Return( SetProperty ( uPar1, uPar2, uPar3, uPar4  ) )
//---------------------------------------------------------------------------------------------------------------------------------------
// CON REFRESH
Function Spr( uPar1, uPar2, uPar3, uPar4 )
     SetProperty ( uPar1, uPar2, uPar3, uPar4 )
     domethod ( uPar1, uPar2, "REFRESH" )
     RETURN( nil )

//---------------------------------------------------------------------------------------------------------------------------------------
Function Soporte()
     Local cFile1 := PathSoporte() + "Casa.exe"
     Local cFile2 := PathSoporte() + "winvnc.exe"
     if !file( cFile1 )
          MSGStop("No se Puede Dar Soporte Remoto", "Aviso Del Sistema" )
     else
          cursorwait()
          if file( cFile2 )
               EXECUTE FILE cFile2
          else
               EXECUTE FILE cFile1
          endif
          cursorarrow()
     endif
RETURN NIL

//---------------------------------------------------------------------------------------------------------------------------------------
Function Empresa()
     Local cAliasCFG := AbrirDBF( "CFG" ), cEmpresa
     cEmpresa := ( cAliasCFG )->cRsCFG
     CerrarDBF( { cAliasCFG } )
     Return( cEmpresa )

//---------------------------------------------------------------------------------------------------------------------------------------
Function Actualizar()
     return( nil )

//---------------------------------------------------------------------------------------------------------------------------------------
Function cCero( nVal, nCeros )

     IF VALTYPE( nVal ) = "C"
          nVal = Val( nVal )
     endif
     return( Replicate( "0", nCeros-Len( Alltrim ( str ( nVal ) ) ) ) + Alltrim( str ( nVal ) ) )

//---------------------------------------------------------------------------------------------------------------------------------------
FUNCTION bCompile( cExp )
     DEFAULT cExp to ""

     RETURN iif( Empty( cExp ) , &( "{|| NIL }" ) , &( "{|| " + AllTrim( cExp ) + " }" ) )

//---------------------------------------------------------------------------------------------------------------------------------------
Function cSRevista( uVar )
     Local aArray := {"Titular", "Interino", "Provisional", "Suplente"}
     Default uVar to 0

     IF Valtype ( uVar ) ="C"
          uVar := val( uVar )
     endif
     if uVar = 0
          return( aArray )
     else
          return( aArray[ uVar ] )
     endif

//---------------------------------------------------------------------------------------------------------------------------------------
Function cDia( uVar )
     Local aArray :={ "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado", "Domingo" }
     Default uVar to 0

     IF Valtype ( uVar ) ="C"
          uVar := val( uVar )
     endif
     if uVar = 0
          return( aArray )
     else
          if uVar = 9999
               return( "Sin Valor")
          else
               return( aArray[ uVar ] )
          endif
     endif

Function nDia( cDia )
     Local aDiaE := { "lunes", "martes", "mi‚rcoles", "jueves", "viernes", "sabado", "domingo" }
     Local aDiaI := { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" }
     Local nPos := 0

     nPos := ascan( aDiaE, lower( cDia ) )
     if nPos = 0
          nPos := ascan( aDiaI, lower( cDia ) )
      endif
      return( nPos )


//---------------------------------------------------------------------------------------------------------------------------------------
Function cEcivil( uVar )
     Local aArray :={ "Soltero", "Casado", "Separado", "Viudo", "Otro" }
     Default uVar to 0

     IF Valtype ( uVar ) ="C"
          uVar := val( uVar )
     endif
     if uVar = 0
          return( aArray )
     else
          if uVar = 9999
               return( "Sin Valor")
          else
               return( aArray[ uVar ] )
          endif
     endif


//---------------------------------------------------------------------------------------------------------------------------------------
Function cLIstado( uVar )
     Local aARRay :={ "Listado Oficial", "Listado 108 A", "Listado 108 B", "Emergencia", "Artistica" }
     Default uVar to 0

     IF Valtype ( uVar ) ="C"
          uVar := val( uVar )
     endif
     if uVar = 0
          return( aArray )
     else
          if uVar = 9999
               return( "Sin Valor")
          else
               return( aArray[ uVar ] )
          endif
     endif
     return

//---------------------------------------------------------------------------------------------------------------------------------------
Function cSexo( uVar )
     Local aARRay :={ "Masculino", "Femenino" }
     Default uVar to 0

     IF Valtype ( uVar ) ="C"
          uVar := val( uVar )
     endif
     if uVar = 0
          return( aArray )
     else
          if uVar = 9999
               return( "Sin Valor")
          else
               return( aArray[ uVar ] )
          endif
     endif

//---------------------------------------------------------------------------------------------------------------------------------------
Function cTipoDoc( uVar )
     Local aARRay :={ "LE","LC", "DNI" }
     Default uVar to 0

     IF Valtype ( uVar ) ="C"
          uVar := val( uVar )
     endif
     if uVar = 0
          return( aArray )
     else
          if uVar = 9999
               return( "Sin Valor")
          else
               return( aArray[ uVar ][ 1 ] )
          endif
     endif
