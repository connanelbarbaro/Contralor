*-- PROGRAM FILE -------------------------------------------------------
*         Description : SISTEMA PARA MARCELO WEBER
*           File Name : TABLA.prg
*              Author : Carvalho Alejandro - HerculeSoft (c) 2007
*   Date Time Created : 10/29/2009 - 08:02
* Date Time updated :>: 02/13/2018 19:03
*             Comment : MODULO ABM TABLAS
*                        1 - Codigos Postales
*                        2 - Formas de Pago
*                        3 - Bancos
*                        4 - Tipos de IVA
*                        5 - Unidades de Medida
*                        6 - Tarjetas de Credito
*   History Update :>>:
*   05/28/12 Version Estable
*-----------------------------------------------------------------------
#include "oohg.ch"
#include "Contralor.ch"

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
13 - Turno
*/

//-----------------------------------------------------------------------------
Function Tablas( nPos )
     Local cAliasTAB := "", cCodTAB := ""
     Local bNew := { || EditTAB( _NEW, cAliasTAB ) }
     Local bDel := { || DelTAB( cAliasTAB ) }
     Local bEdit := { || EditTAB( _EDIT, cAliasTAB ) }
     Local bRpt := { || RptTABLA( cAliasTAB ) }
     Local bRefresh := { || TabRefresh( cAliasTAB ) }
     Local bExit := { || ThisWindow.Release }
     Local bView := { || MsgStop( "Funcion Deshabilitada", "Aviso Del Sistema" ) }
     Local aTabla := { }

     cAliasTAB := AbrirDBF( "TABLA",  "TABdes"  )

     Load Window FrmTabla
     Center Window FrmTabla
     TABcargar()
     FrmTabla.cmbTabla.Value := 1
//     TabRefresh( cAliasTAB )
     Activate Window FrmTabla
     CerrarDBF( { cAliasTAB } )
     Return( nil )

//-----------------------------------------------------------------------------
Function TabRefresh( cAliasTAB )

     ( cAliasTAB ) ->( dbsetfilter( { || ( cAliasTAB ) ->cClaTAB = Str(  FrmTabla.cmbTabla.Value, 2 ) }, "( cAliasTAB )->cClaTAB = Str(  FrmTabla.cmbTabla.Value,2 )" ) )
     if FrmTabla.cmbTabla.value = 12
          FrmTabla.Browse_2.Show()
          FrmTabla.Browse_1.Hide()
          Refresh( cAliasTAB, "FrmTabla", "Browse_2" )
     else
          FrmTabla.Browse_2.Hide()
          FrmTabla.Browse_1.Show()
          Refresh( cAliasTAB, "FrmTabla", "Browse_1" )
     endif
     return( nil )

//-----------------------------------------------------------------------------
Function EditTab( nOp, cAliasTAB  )

     Load Window FrmTablaEdit
     IF FrmTabla.cmbTabla.Value = 12
          FrmTablaEdit.label_1.value := "Art / Inc"
          FrmTablaEdit.txtiNC.sHOW()
          if nOp = _NEW
               FrmTablaEdit.txtiNC.value = space( 5 )
          ELSE
               FrmTablaEdit.txtiNC.value = ( cAliasTAB ) ->cIncTAB
          endif
     endif

     if nOp = _NEW
          FrmTablaEdit.txtcod.value = space( 5 )
          FrmTablaEdit.txtdesc.value = space( 35 )
     else
          FrmTablaEdit.txtcod.value = ( cAliasTAB ) ->cCodTAB
          FrmTablaEdit.txtdesc.value = ( cAliasTAB ) ->cDesTAB
          FrmTablaEdit.txtCOD.Enabled = .F.
     endif
     Center Window FrmTablaEdit
     Activate Window FrmTablaEdit

     return( nil )

//-----------------------------------------------------------------------------
Function SaveTAB( nOp, cAliasTAB )

     IF nOp = _NEW
          ( cAliasTAB ) ->( dbAppend() )
     ENDIF
     ( cAliasTAB ) ->( RLock() )
     ( cAliasTAB ) ->cClaTAB := Str( FrmTabla.cmbTabla.value, 2 )
     ( cAliasTAB ) ->cCodTAB := FrmTablaEdit.txtcod.value
     ( cAliasTAB ) ->cDesTAB := FrmTablaEdit.txtdesc.value
     IF FrmTabla.cmbTabla.Value = 12
          ( cAliasTAB ) ->cIncTAB := FrmTablaEdit.txtiNC.value
     endif

     ( cAliasTAB ) ->( dbcommit() )
     ( cAliasTAB ) ->( dbUnlock() )
     FrmTablaEdit.Release()
     TabRefresh( cAliasTAB )
     RETURN NIL

//-----------------------------------------------------------------------------
Function DelTAB( cAliasTAB )
// 1 Yes
// 2 NO
// 0 CANCEL
     if MsgYesNoCancel( "Desea Borrar Este Registro ?", "Aviso Del Sistema" ) = 1
          ( cAliasTAB ) ->( RLOCK() )
          ( cAliasTAB ) ->( DBDELETE() )
          ( cAliasTAB ) ->( dbcommit() )
          ( cAliasTAB ) ->( dbUnlock() )
          TabRefresh( cAliasTAB )
     endif
     RETURN NIL

//-----------------------------------------------------------------------------
Function RptTABLA( cAliasTAB )

     Local nLin := 999
     Local oPrint
     Local aPos := { }, aHead := { }, aCampo := { }
     Local cTit := FrmTabla.cmbTabla.DisplayValue
     Local lLandscape := .T. // impresion horizontal llanscape=.F. impresion Vertical
     Local nDatos := 0, nPag := 0, nTotPAG

     aadd( aHead, { "", iif( FrmTabla.cmbTabla.value = 12, "Art", "Cod." ) } )
     aadd( aHead, { "", iif( FrmTabla.cmbTabla.value = 12, "Inc", "Descripcion" ) } )
     aadd( aHead, { "", iif( FrmTabla.cmbTabla.value = 12, "Descripcion", "" ) } )

     aadd( aPos, 1 )
     aadd( aPos, 8 )
     aadd( aPos, iif( FrmTabla.cmbTabla.value = 12, 18, 8 ) )

     ( cAliasTAB ) ->( dbeval( { || nDatos += 1 } ) )
     if IniPrint( @oPrint, lLandscape  )
          ( cAliasTAB ) ->( dbgotop() )
          do while ! ( cAliasTAB ) ->( eof() )
               HeadRpt( oPrint, @nLin, cTit, aHead, aPos, lLandscape, nDatos, @nPag )
               oPrint:printdata( nLin, aPos[ 1 ], ( cAliasTAB ) ->cCodTAB,, 12 )
               oPrint:printdata( nLin, aPos[ 2 ], iif( FrmTabla.cmbTabla.value = 12, ( cAliasTAB ) ->cIncTAB, "" ),, 12 )
               oPrint:printdata( nLin, aPos[ 3 ], ( cAliasTAB ) ->cDesTAB,, 12 )
               ( cAliasTAB ) ->( DbSkip() )
          enddo
          FooterRpt( oPrint, lLandscape, nDatos, @nPag )
          oPrint:enddoc()
          oPrint:RELEASE()
     endif
     return nil


Function TABcargar()

     FrmTabla.cmbTabla.AddItem( "Codigos Postales" )
     FrmTabla.cmbTabla.AddItem( "Tipo Listados" )
     FrmTabla.cmbTabla.AddItem( "Tipo Carga Horaria" )
     FrmTabla.cmbTabla.AddItem( "Estado Civil" )
     FrmTabla.cmbTabla.AddItem( "Modalidad" )
     FrmTabla.cmbTabla.AddItem( "Tipo de Documento" )
     FrmTabla.cmbTabla.AddItem( "Sexo" )
     FrmTabla.cmbTabla.AddItem( "Sit. de Revista" )
     FrmTabla.cmbTabla.AddItem( "Codigo de Alta" )
     FrmTabla.cmbTabla.AddItem( "Codigo de Movimiento" )
     FrmTabla.cmbTabla.AddItem( "Codigo de Cese" )
     FrmTabla.cmbTabla.AddItem( "Codigo de Licencias" )
     FrmTabla.cmbTabla.AddItem( "Turno" )
     Return nil

