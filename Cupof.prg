*-- PROGRAM FILE -------------------------------------------------------
*         Description : CONTRALOR
*           File Name : DOCentes.prg
*              Author : Carvalho Alejandro - HerculeSoft (c) 2007
*   Date Time Created : 10/29/2009 - 08:02
* Date Time updated :>: 02/14/2018 09:26
*             Comment : MODULO ABM DOCENTES
*   History Update :>>:
*   02/13/18-02/14/18
*   02/11/18
*   02/08/18-02/09/18
*   02/04/18
*   01/26/18-02/02/18
*-----------------------------------------------------------------------
#include "oohg.ch"
#include "Contralor.ch"

DECLARE WINDOW FrmCupof
DECLARE WINDOW FrmCupofEdit
//-----------------------------------------------------------------------------
Function Cupof( lSelect )

     Local cAliasCUPOF, cAliasHcupof, cAliasTipo, cAliasTurno,cAliasMov, cAliasMOD
     Local cCupof := ""
     Local lGrabar := .F.
     Local bNew := { || EditCUPOF( _NEW, lGrabar, cAliasCUPOF, cAliasHcupof, cAliasTipo, cAliasTurno, cAliasDoc1, cAliasMov, cAliasMOD ) }
     Local bDel := { || DelCUPOF( cAliasCUPOF ) }
     Local bEdit := { || EditCUPOF( _EDIT, lGrabar, cAliasCUPOF, cAliasHcupof, cAliasTipo, cAliasTurno, cAliasDoc1, cAliasMov, cAliasMOD ) }
     Local bRpt := { || RptCUPOF( cAliasCUPOF, cAliasTAB ) }
     Local bActu := { || Refresh( cAliasCUPOF, "FrmCUPOF", "BROWSE_1" ) }
     Local bSele := { || cCupof := ( cAliasCUPOF ) ->cCupof , ThisWindow.Release }
     Local bView := ""

     Public cAliasDoc1

     Default lSelect := .F.
     bView := iif( lSelect, bSele, bEdit )

     cAliasTurno := AbrirDBF( "TABLA", "TABdes" )
     ( cAliasTurno )->( dbsetfilter( {|| ( cAliasTurno )->cClaTab = str( 13, 2 ) } ) )
     ( cAliasTurno )->( dbgotop() )

     cAliasCUPOF := AbrirDBF( "Cupof", "CupofCOD" )
     cAliasHcupof := AbrirDBF( "HCupof", "HCupof"  )

     cAliasTipo := AbrirDBF( "TABLA", "TABdes" )
     ( cAliasTipo )->( dbsetfilter( {|| ( cAliasTipo )->cClaTab = str( 3, 2 ) } ) )
     ( cAliasTipo )->( dbgotop() )

     cAliasMOD := AbrirDBF( "TABLA", "TABdes" )
     ( cAliasMOD )->( dbsetfilter( {|| ( cAliasMOD )->cClaTab = str( 5, 2 ) } ) )
     ( cAliasMOD )->( dbgotop() )

     cAliasDOC1 := AbrirDBF( "DOCENTES", "DOCdni" )
     cAliasMov := AbrirDBF( "Movimiento", "MOVactivo" )
     ( cAliasMov )->( dbsetrelation( cAliasDOC1, {|| ( cAliasMov )->cDNIs}, "( cAliasMov )->cDNIs"))
     ( cAliasMov )->( DbGotop() )

     Load Window FrmCupof
     Center Window FrmCupof
     FrmCupof.lTodo.value = .T.
     FrmCupof.Browse_1.setfocus()
     Activate Window FrmCupof
     CerrarDBF( { cAliasCUPOF, cAliasHcupof, cAliasTipo, cAliasTurno, cAliasMOD } )

     Return( cCupof )

//-----------------------------------------------------------------------------
Function EditCUPOF( nOp, lGrabar, cAliasCUPOF, cAliasHcupof, cAliasTipo, cAliasTurno, cAliasDoc1, cAliasMov, cAliasMOD )

     Load Window FrmCupofEdit
     if nOp = _NEW
          FrmCupofEdit.txtCupof.value = "0"
          FrmCupofEdit.txtMateria.value = space( 30 )
          FrmCupofEdit.txtSigla.value = space( 10 )
//          FrmCupofEdit.cmbTipo.Value = "9999"
          FrmCupofEdit.txtTiempo.value = 0
//          FrmCupofEdit.cmbCurso.Value = "9999"
//          FrmCupofEdit.cmbDivision.Value = "9999"
          FrmCupofEdit.txtFuncion.value = space( 10 )
//          FrmCupofEdit.cmbTurno.Value = "9999"
     else
          FrmCupofEdit.txtCupof.value = ( cAliasCUPOF ) ->cCupof
          FrmCupofEdit.txtMateria.value = ( cAliasCUPOF ) ->cMateria
          FrmCupofEdit.txtSigla.Value = ( cAliasCUPOF ) ->cSigla
          FrmCupofEdit.cmbTipo.Value = ( cAliasCUPOF ) ->cTipo
          FrmCupofEdit.txtTiempo.value = ( cAliasCUPOF ) ->cCargaH
          FrmCupofEdit.cmbCurso.Value = ( cAliasCUPOF ) ->cCurso
          FrmCupofEdit.cmbDivision.Value = ( cAliasCUPOF ) ->cDiv
          FrmCupofEdit.txtFuncion.value = ( cAliasCUPOF ) ->cFuncion
          FrmCupofEdit.cmbTurno.Value = ( cAliasCUPOF ) ->cTurno
     endif
     FrmCupofEdit.HH1.value := 7
     FrmCupofEdit.mm1.value := 30
     FrmCupofEdit.HH2.value := FrmCupofEdit.HH1.value + iif( FrmCupofEdit.txtTiempo.value = 1, 1, 2)
     FrmCupofEdit.mm2.value := 30
     FrmCupofEdit.cmbDia.value := 1
     FrmCupofEdit.txtCupof.Enabled = iif( nOp = _NEW, .T., .F. )
     ( cAliasMov )->( dbsetfilter( {|| cCupof = FrmCupofEdit.txtCupof.value  }) )
     ( cAliasHcupof )->( dbsetfilter( {|| ccupof =FrmCupofEdit.txtCupof.value } ) )
     Refresh( cAliasHcupof, "FrmCupofEdit", "BROWSE_1" )
     Refresh( cAliasMOV, "FrmCupofEdit", "BROWSE_2" )
     FrmCupofEdit.txtCupof.SetFocus()
     Center Window FrmCupofEdit
     Activate Window FrmCupofEdit
     return( nil )

//-----------------------------------------------------------------------------
Function SaveCupof( nOp, cAliasCUPOF )


     IF nOp = _NEW
          ( cAliasCUPOF ) ->( dbAppend() )
     ENDIF
     ( cAliasCUPOF ) ->( dbrlock() )
     ( cAliasCUPOF ) ->cCupof := FrmCupofEdit.txtCupof.value
     ( cAliasCUPOF ) ->cMateria := FrmCupofEdit.txtMateria.value
     ( cAliasCUPOF ) ->cSigla := FrmCupofEdit.txtSigla.Value
     ( cAliasCUPOF ) ->cTipo := FrmCupofEdit.cmbTipo.Value
     ( cAliasCUPOF ) ->cCargaH := FrmCupofEdit.txtTiempo.value
     ( cAliasCUPOF ) ->cCurso := FrmCupofEdit.cmbCurso.Value
     ( cAliasCUPOF ) ->cDiv := FrmCupofEdit.cmbDivision.Value
     ( cAliasCUPOF ) ->cFuncion := FrmCupofEdit.txtFuncion.value
     ( cAliasCUPOF ) ->cTurno := FrmCupofEdit.cmbTurno.Value
     ( cAliasCUPOF ) ->cMod := FrmCupofEdit.cmbMod.Value
     ( cAliasCUPOF ) ->( dbcommit() )
     ( cAliasCUPOF ) ->( dbUnlock() )
     FrmCupofEdit.Release()
     Refresh( cAliasCUPOF, "FrmCupof", "BROWSE_1" )
     RETURN NIL

//-----------------------------------------------------------------------------
Function DelCUPOF( cAliasCUPOF )
// 1 Yes
// 2 NO
// 0 CANCEL
     if MsgYesNoCancel( "Desea Borrar Este Registro ?", "Aviso Del Sistema" ) = 1
          ( cAliasCUPOF ) ->( RLOCK() )
          ( cAliasCUPOF ) ->( DBDELETE() )
          ( cAliasCUPOF ) ->( dbcommit() )
          ( cAliasCUPOF ) ->( dbUnlock() )
          Refresh( cAliasCUPOF, "FrmCupof", "BROWSE_1" )
     endif
     RETURN NIL

//-----------------------------------------------------------------------------
Function RptCUPOF( cAliasCUPOF, cAliasTAB, cPrinter )

     Local nLin := 999
     Local oPrint
     Local aPos := { 1, 8, 40, 80 }
     Local cTit := "Listado de Materia"
     Local aHead := { { "", "Cupof" }, { "", "Materia" }, { "", "" }, { "", "" } }
     Local cEmpresa := Empresa()
     Local lLandscape := .T. // impresion horizontal llanscape=.F. impresion Vertical
     Local nDatos := 0, nPag := 0

     ( cAliasCUPOF ) ->( dbeval( { || nDatos += 1 } ) )
     IF IniPrint( @oPrint, lLandscape  )
          ( cAliasCUPOF ) ->( dbgotop() )
          do while ! ( cAliasCUPOF ) ->( eof() )
               HeadRpt( oPrint, @nLin, cTit, aHead, aPos, lLandscape, @nDatos, @nPag )
               oPrint:printdata( nLin, aPos[ 1 ], " " + ( cAliasCUPOF ) ->cCupof, "Courier New", 12 )
               oPrint:printdata( nLin, aPos[ 2 ], ( cAliasCUPOF ) ->capenom, "Courier New", 12 )
               oPrint:printdata( nLin, aPos[ 3 ], ( cAliasCUPOF ) ->cDir, "Courier New", 12 )
//               oPrint:printdata( nLin, aPos[ 4 ], RptCiudad( cAliasTAB, ( cAliasCUPOF )->cCp ),"Courier New", 12 )
               ( cAliasCUPOF ) ->( DbSkip() )
          enddo
          FooterRpt( oPrint, lLandscape, nDatos, @nPag )
          oPrint:enddoc()
          oPrint:RELEASE()
     endif

     Refresh( cAliasCUPOF, "FrmCupof", "Browse_1" )
     return nil

//-----------------------------------------------------------------------------
Function EditHcupof( lGrabar, Btn, cAliasHCupof )


// Grabar      Btn_1          Btn_2
// .T.         Grabar         Camcelar
// .F.         Agregar        Borrar

     if Btn = 1
          // Grabar
          ( cAliasHCupof ) ->( dbAppend() )
          ( cAliasHCupof ) ->( dbrlock() )
          ( cAliasHCupof ) ->cCupof := FrmCupofEdit.txtCupof.value
          ( cAliasHCupof ) ->cDia := str( FrmCupofEdit.cmbDia.value, 2 )
          ( cAliasHCupof ) ->cDesde := str( FrmCupofEdit.HH1.value, 2 ) + ":" + str( FrmCupofEdit.mm1.value, 2 )
          ( cAliasHCupof ) ->cHasta := str( FrmCupofEdit.HH2.value, 2 ) + ":" + str( FrmCupofEdit.mm2.value, 2 )
          ( cAliasHCupof ) ->cTurno := if( FrmCupofEdit.HH1.value < 12, "M", if( FrmCupofEdit.HH1.value < 18, "T", "N" ) )
          ( cAliashCUPOF ) ->cTipo := FrmCupofEdit.cmbTipo.Value
          ( cAliasHCupof ) ->( dbcommit() )
          ( cAliasHCupof ) ->( dbUnlock() )
     Else
          // Borrar
          ( cAliasHCupof ) ->( RLOCK() )
          ( cAliasHCupof ) ->( DBDELETE() )
          ( cAliasHCupof ) ->( dbcommit() )
          ( cAliasHCupof ) ->( dbUnlock() )
     endif
     Refresh( cAliasHCupof, "FrmCupofEdit", "BROWSE_1" )
     Return( nil )


Function FiltroCupof( cAliasCupof, nCambio )
     ( cAliasCupof )->( dbclearFilter() )
     If  FrmCupof.lTodo.value = .F.
          do case
          case nCambio = 1
               FrmCupof.cmbDiv.Value := 99
               ( cALiasCupof )->( dbsetfilter( {|| cTipo = FrmCupof.cmbTipo.Value .and. cCurso = FrmCupof.cmbCurso.Value } ) )
          case nCambio = 2
               ( cALiasCupof )->( dbsetfilter( {|| cTipo = FrmCupof.cmbTipo.Value .and. cCurso = FrmCupof.cmbCurso.Value .and. cDiv = FrmCupof.cmbDiv.Value } ) )
          Case nCambio = 3
               FrmCupof.cmbCurso.Value := 99
               FrmCupof.cmbDiv.Value := 99
               ( cALiasCupof )->( dbsetfilter( {|| ( cAliasCupof )->cTipo = FrmCupof.cmbTipo.Value }))
          endcase
     endif

     Refresh( cAliasCupof, "FrmCupof", "BROWSE_1" )
     return nil

Function CUPactu( nOp )
     if nOP = 1    // Hora
          FrmCupofEdit.HH2.value = FrmCupofEdit.HH1.value + iif( FrmCupofEdit.txtTiempo.value = 1, 1, 2)
     else          // Minutos
          FrmCupofEdit.mm2.value = FrmCupofEdit.mm1.value
     endif
     FrmCupofEdit.HH2.refresh()
     FrmCupofEdit.MM2.refresh()
     return nil

