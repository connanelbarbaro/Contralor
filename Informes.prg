*-- PROGRAM FILE -------------------------------------------------------
*         Description :
*           File Name : Informes.prg
*              Author : Carvalho Alejandro - HerculeSoft (c) 2012
*   Date Time Created : 02/11/2018 - 10:20
* Date Time updated :>: 02/16/2018 10:06
*             Comment :
*   History Update :>>:
*   02/11/18-02/16/18
*-----------------------------------------------------------------------
#include "oohg.ch"
#include "Contralor.ch"
Function RptDocDNI()

     Local nLin := 999
     Local oPrint
     Local aPos := { , 33 }
     Local cTit := "Listado de Docente"
     Local aHead := { { "", "   DNI" }, { "", "DOCente" } }
     Local cEmpresa := Empresa()
     Local lLandscape := .T. // impresion horizontal llanscape=.F. impresion Vertical
     Local nDatos := 0, nPag := 0, nDatos2 := 0
     Local cAliasDOC, cAliasMOV

     cAliasDOC := AbrirDBF( "DOCENTES", "DOCnom" )
     cAliasMOV := AbrirDBF( "MOVIMIENTO", "MOVactivo" )
     ( cAliasDOC )->( dbeval( { || nDatos += 1 } ) )
     if nDatos > 0
          IF IniPrint( @oPrint, lLandscape  )
               ( cAliasDOC ) ->( dbgotop() )
               do while !( cAliasDOC )->( eof() )
                    nDatos2 := 0
                   ( cAliasMOV )->( dbsetfilter( {|| cDNIs = ( cAliasDOC )->cDNI .and. lActivo =.T. } ) )
                    ( cAliasMOV )->( dbeval( { || nDatos2 += 1 } ) )
                    if nDatos > 0
                         HeadRpt( oPrint, @nLin, cTit, aHead, aPos, lLandscape, @nDatos, @nPag )
                         oPrint:printdata( nLin, aPos[ 1 ], ( cAliasDOC )->capenom, "Courier New", 12 )
                         oPrint:printdata( nLin, aPos[ 2 ], ( cAliasDOC )->cDNI, "Courier New", 12 )
                    endif
                    ( cAliasDOC )->( dbskip() )
               enddo
               FooterRpt( oPrint, lLandscape, nDatos, @nPag )
               oPrint:enddoc()
               oPrint:RELEASE()
          endif
     endif
     CerrarDBF( { cAliasDOC, cAliasMOV } )
     return nil
//----------------------------------------------------------------------------------------------------------------------------------
Function RptTNoti()
// NOTIFICACION SOLO PERSONAL TITULAR

     Local nLin := 999
     Local oPrint
     Local aPos := { 0, 33, 41, 60 }
     Local cTit := "Notificacion Docente Titulares"
     Local aHead := { { "", "Docente" }, { "", "DNI" }, { "", "Firma" }, { "", "Fecha" } }
     Local cEmpresa := Empresa()
     Local lLandscape := .T. // impresion horizontal llanscape=.T. impresion Vertical
     Local nDatos := 0, nPag := 0
     Local cAliasDOC, cAliasMOV, nDatos2 := 0


     cAliasDOC := AbrirDBF( "DOCENTES", "DOCnom" )
     cAliasMOV := AbrirDBF( "MOVIMIENTO", "MOVcupof" )
     ( cAliasDOC )->( dbeval( { || nDatos += 1 } ) )
     if nDatos > 0
          IF IniPrint( @oPrint, lLandscape  )
               ( cAliasDOC )->( dbgotop() )
               do while !( cAliasDOC )->( eof() )
                    nDatos2 = 0
                    ( cAliasMOV )->( dbclearFilter() )
                    ( cAliasMOV )->( dbsetfilter( {|| cDNIs = ( cAliasDOC )->cDni .and. nSitRev = 1 } ) )
                    ( cAliasMOV )->( dbeval( { || nDatos2 += 1 } ) )
                    if nDatos2 > 0
                         HeadRpt( oPrint, @nLin, cTit, aHead, aPos, lLandscape, @nDatos, @nPag )
                         oPrint:printdata( nLin, aPos[ 1 ], ( cAliasDOC ) ->capenom + " " + ( cAliasDOC ) ->cDni , "Courier New", 12 )
                         oPrint:printline( nLin + 1, aPos[ 3 ], nLin + 1, aPos[ 3 ] + 10 )
                         oPrint:printline( nLin + 1, aPos[ 4 ], nLin + 1, aPos[ 4 ] + 10 )
                    endif
                    ( cAliasDOC )->( dbskip() )
               enddo
               oPrint:endpage()
               oPrint:enddoc()
               oPrint:RELEASE()
          endif
     endif
     CerrarDBF( { cAliasDOC, cAliasMOV } )
     return nil

Function RptDocxDia()
     Local cAliasHcupof, cAliasTip1, cAliasTip2, cAliasDoc, cAliasCupof, cAliasMOV
     Local aListado := { }

     cAliasDoc := AbrirDBF( "DOCentes", "DOCdni" )
     cAliasMOV := AbrirDBF( "MOVIMIENTO", "MOVactivo" )

     cAliasCupof := AbrirDBF( "Cupof", "CupofCod" )
     cAliasHcupof := AbrirDBF( "Hcupof" )

     cAliasTip1 := AbrirDBF( "TABLA", "TABdes" )
     ( cAliasTip1 ) ->( dbsetfilter( { || cClaTab = str( 3, 2 ) } ) )
     ( cAliasTip1 ) ->( dbgotop() )

     cAliasTip2 := AbrirDBF( "TABLA", "TABdes" )
     ( cAliasTip2 ) ->( dbsetfilter( { || cClaTab = str( 3, 2 ) } ) )
     ( cAliasTip2 ) ->( dbgotop() )

     Load Window FrmAsisxDia
     Center Window FrmAsisxDia
     Activate Window FrmAsisxDia

     Return nil

Function DocxDia( cAliasHcupof, cAliasTip1, cAliasTip2, cAliasDoc, cAliasCupof, cAliasMOV )

     FrmAsisxDia.Grid_1.DeleteAllItems()
// Cargos
     ( cAliasHcupof ) ->( dbclearFilter() )
     ( cAliasHcupof ) ->( dbsetfilter( { || cDia = str( FrmAsisxDia.cmbDia.value, 2 ) .and. cTipo = FrmAsisxDia.cmbTipo1.Value } ) )
     ( cAliasHcupof ) ->( dbgotop() )
     do while ! ( cAliasHcupof ) ->( eof() )
// BUSCAR SIGLA EN CUPOF
          ( cAliasCupof ) ->( dbseek( ( cAliasHcupof ) ->cCupof ) )
          ( cAliasMOV ) ->( dbclearfilter() )
          ( cAliasMOV ) ->( dbsetfilter( { || cCupof = ( cAliasHcupof ) ->cCupof .and. lActivo = .T. } ) )
          ( cAliasMOV ) ->( dbgotop() )
          do while ! ( cAliasMOV ) ->( eof() )
               if ( cAliasDoc ) ->( dbseek( ( cAliasMOV )->cDNIs) )
                    FrmAsisxDia.Grid_1.AddItem( {"C", ( cAliasDoc ) ->cApeNom, ( cAliasCupof ) ->cSigla } )
               endif
               ( cAliasMOV ) ->( dbskip() )
          enddo
          ( cAliasHcupof ) ->( dbskip() )
     enddo
FrmAsisxDia.Grid_1.AddItem( { "", "Turno Ma¤ana", "" } )
// Docentes Turno Ma¤ana
     ( cAliasHcupof ) ->( dbclearFilter() )
     ( cAliasHcupof ) ->( dbsetfilter( { || cDia = str( FrmAsisxDia.cmbDia.value, 2 ) .and. cTipo = FrmAsisxDia.cmbTipo2.Value .and. cTurno = "M" } ) )
     ( cAliasHcupof ) ->( dbgotop() )
     do while ! ( cAliasHcupof ) ->( eof() )
// BUSCAR SIGLA EN CUPOF
          ( cAliasCupof ) ->( dbseek( ( cAliasHcupof ) ->cCupof ) )
          ( cAliasMOV ) ->( dbclearfilter() )
          ( cAliasMOV ) ->( dbsetfilter( { || cCupof = ( cAliasHcupof ) ->cCupof .and. lActivo = .T. } ) )
          ( cAliasMOV ) ->( dbgotop() )
          do while ! ( cAliasMOV ) ->( eof() )
               if ( cAliasDoc ) ->( dbseek( ( cAliasMOV )->cDNIs) )
                    FrmAsisxDia.Grid_1.AddItem( { "M", ( cAliasDoc ) ->cApeNom, ( cAliasCupof ) ->cFuncion } )
               endif
               ( cAliasMOV ) ->( dbskip() )
          enddo
          ( cAliasHcupof ) ->( dbskip() )
     enddo
     FrmAsisxDia.Grid_1.AddItem( { "", "Turno Tarde", "" })
// Docentes Turno Tarde
     ( cAliasHcupof ) ->( dbclearFilter() )
     ( cAliasHcupof ) ->( dbsetfilter( { || cDia = str( FrmAsisxDia.cmbDia.value, 2 ) .and. cTipo = FrmAsisxDia.cmbTipo2.Value .and. cTurno = "T" } ) )
     ( cAliasHcupof ) ->( dbgotop() )
     do while ! ( cAliasHcupof ) ->( eof() )
// BUSCAR SIGLA EN CUPOF
          ( cAliasCupof ) ->( dbseek( ( cAliasHcupof ) ->cCupof ) )
          ( cAliasMOV ) ->( dbclearfilter() )
          ( cAliasMOV ) ->( dbsetfilter( { || cCupof = ( cAliasHcupof ) ->cCupof .and. lActivo = .T. } ) )
          ( cAliasMOV ) ->( dbgotop() )
          do while ! ( cAliasMOV ) ->( eof() )
               if ( cAliasDoc ) ->( dbseek( ( cAliasMOV )->cDNIs) )
                    FrmAsisxDia.Grid_1.AddItem( { "T", ( cAliasDoc ) ->cApeNom, ( cAliasCupof ) ->cFuncion } )
               endif
               ( cAliasMOV ) ->( dbskip() )
          enddo
          ( cAliasHcupof ) ->( dbskip() )
     enddo



     FrmAsisxDia.Grid_1.Refresh()
     return nil

//----------------------------------------------------------------------------------------------------------------------------------
Function RptSup()

     Local nLin := 999
     Local oPrint
     Local aPos := { 0, 15, 50 }
     Local cTit := "Listado de Docente Suplentes"
     Local aHead := { { "", "   DNI" }, { "", "DOCente" } }
     Local cEmpresa := Empresa()
     Local lLandscape := .T. // impresion horizontal llanscape=.F. impresion Vertical
     Local nDatos := 0, nPag := 0, nDatos2 := 0
     Local cAliasDOC, cAliasMOV, cDniTit := "1"

     cAliasDOC := AbrirDBF( "DOCENTES", "DOCdni" )
     cAliasCUPOF := AbrirDBF( "CUPOF", "CupofCod" )
     cAliasMOV := AbrirDBF( "MOVIMIENTO", "MOVsup" )
     ( cAliasMOV )->( dbeval( { || nDatos += 1 } ) )
     if nDatos > 0
          IF IniPrint( @oPrint, lLandscape  )
               ( cAliasMOV )->( dbgotop() )
               do while !( cAliasMOV )->( eof() )
                    HeadRpt( oPrint, @nLin, cTit, aHead, aPos, lLandscape, @nDatos, @nPag )
                    if cDniTit != ( cAliasMOV )->cDNI
                         MsgDbg( ( cAliasMOV )->cDNI )
                         cDniTit := ( cAliasMOV )->cDNI
                         ( cAliasDOC )->( dbseek( cDniTit ) )
                         nLin += 1
                         oPrint:printdata( nLin, aPos[ 1 ], ( cAliasDOC )->cDNI, "Courier New", 12 )
                         oPrint:printdata( nLin, aPos[ 2 ], ( cAliasDOC )->capenom, "Courier New", 12 )
                         nLin += 1
                         oprint:printline( nLin,0,nLin, 80 )
                         nLin += 1
                    endif
/*
                    ( cAliasDOC )->( dbseek( ( cAliasMOV )->cDniS ) )
                    ( cAliasCUPOF )->( dbseek( ( cAliasMOV )->cCupof ) )
                    oPrint:printdata( nLin, aPos[ 1 ], ( cAliasDOC )->cDNI, "Courier New", 12 )
                    oPrint:printdata( nLin, aPos[ 2 ], ( cAliasDOC )->capenom, "Courier New", 12 )
                    oPrint:printdata( nLin, aPos[ 3 ], ( cAliasCUPOF )->cSigla, "Courier New", 12 )
*/
                    ( cAliasMOV )->( dbskip() )
               enddo
               FooterRpt( oPrint, lLandscape, nDatos, @nPag )
               oPrint:enddoc()
               oPrint:RELEASE()
          endif
     endif
     CerrarDBF( { cAliasDOC, cAliasMOV } )
     return nil







