*-- PROGRAM FILE -------------------------------------------------------
*         Description : CONTRALOR
*           File Name : DOCentes.prg
*              Author : Carvalho Alejandro - HerculeSoft (c) 2007
*   Date Time Created : 10/29/2009 - 08:02
* Date Time updated :>: 02/12/2018 14:06
*             Comment : MODULO ABM DOCENTES
*   History Update :>>:
*   02/11/18-02/12/18
*   02/04/18-02/08/18
*   02/02/18
*   01/26/18-01/31/18
*-----------------------------------------------------------------------
#include "oohg.ch"
#include "Contralor.ch"

DECLARE WINDOW FrmDOC
DECLARE WINDOW FrmDocEdit
//-----------------------------------------------------------------------------
Function DOCentes( lSelect )
     Local cAliasDOC, cAliasDNI, cAliasCP, cAliasEcivil, cAliasTsexo, cAliasListado, cAliasMov, cAliasAus
     Local cDNI := ""
     Local bNew := {|| EditDOC( _NEW, cAliasDOC, cAliasDNI, cAliasCP, cAliasEcivil, cAliasTsexo, cAliasListado, cAliasMov, cAliasAus ) }
     Local bDel := {|| DelDOC( cAliasDOC ) }
     Local bEdit:= {|| EditDOC( _EDIT, cAliasDOC, cAliasDNI, cAliasCP, cAliasEcivil, cAliasTsexo, cAliasListado, cAliasMov, cAliasAus  ) }
     Local bRpt := {|| RptDOC( cAliasDOC ) }
     Local bActu:= {|| Refresh( cAliasDOC, "FrmDOC", "BROWSE_1" ) }
     Local bSele:= {|| cDNI:= ( cAliasDOC )->cDNI ,ThisWindow.Release }
     Local bView := ""

     pUBLIC cAliasCupof
     Default lSelect := .F.
     bView:= iif( lSelect, bSele, bEdit )

     cAliasDOC := AbrirDBF( "DOCentes", "DOCnom" )
     cAliasDNI := AbrirDBF( "TABLA", "TABdes" )
     ( cAliasDNI ) ->( dbsetfilter( { || cClaTAB = Str(  6 ,2 ) }, "cClaTAB = Str(  6 ,2 )" ) )
     ( cAliasDNI ) ->( dbgotop() )

     cAliasCP := AbrirDBF( "TABLA", "TABdes" )
     ( cAliasCP ) ->( dbsetfilter( { || cClaTAB = Str(  1 ,2 ) }, "cClaTAB = Str(  1 ,2 )" ) )
     ( cAliasCP ) ->( dbgotop() )

     cAliasListado := AbrirDBF( "TABLA", "TABdes" )
     ( cAliasListado ) ->( dbsetfilter( { || cClaTAB = Str(  2 ,2 ) }, "cClaTAB = Str(  2 ,2 )" ) )
     ( cAliasListado ) ->( dbgotop() )

     cAliasEcivil := AbrirDBF( "TABLA", "TABdes" )
     ( cAliasEcivil ) ->( dbsetfilter( { || cClaTAB = Str(  4 ,2 ) }, "cClaTAB = Str(  4 ,2 )" ) )
     ( cAliasEcivil ) ->( dbgotop() )

     cAliasTsexo := AbrirDBF( "TABLA", "TABdes" )
     ( cAliasTsexo ) ->( dbsetfilter( { || cClaTAB = Str(  7 ,2 ) }, "cClaTAB = Str(  7 ,2 )" ) )
     ( cAliasTsexo ) ->( dbgotop() )

     cAliasCupof :=AbrirDBF( "CUPOF", "CUPOFcod" )

     cAliasMov :=AbrirDBF( "Movimiento", "MOVdnis" )
     ( cAliasMov )->( dbsetrelation( cAliasCupof, {|| ( cAliasMov )->cCupof}, "( cAliasMov )->cCupof"))

     cAliasAus :=AbrirDBF( "Licencias", "LICfecha" )


     Load Window FrmDOC
     Center Window FrmDOC
     //FrmDOC.Browse_1.ColumnsAutoFit
     Activate Window FrmDOC
     CerrarDBF( {cAliasDOC, cAliasDNI, cAliasCP, cAliasEcivil, cAliasTsexo, cAliasListado, cAliasMov, cAliasAus } )

     Return( cDNI )

//-----------------------------------------------------------------------------
Function EditDOC( nOp, cAliasDOC, cAliasDNI, cAliasCP, cAliasEcivil, cAliasTsexo, cAliasListado, cAliasMov, cAliasAus  )

     ( cAliasMOV )->( DbSetFilter( {|| (cAliasMOV)->cDNIs=( cAliasDOC )->cDNI},"(cAliasMOV)->cDNIs=( cAliasDOC )->cDNI")  )
     ( cAliasAUS )->( DbSetFilter( {|| (cAliasAUS)->cDNI=( cAliasDOC )->cDNI},"(cAliasAUS)->cDNI=( cAliasDOC )->cDNI")  )

     Load Window FrmDocEdit
     if nOp = _NEW
          FrmDocEdit.txtDNI.value = 0
          FrmDocEdit.txtApeNom.value = space( 30 )
          FrmDocEdit.txtDir.value = space( 30 )
          FrmDocEdit.cmbCP.value = 9999
          FrmDocEdit.txtTel.value = space( 30 )
          FrmDocEdit.txtCel.value = space( 30 )
          FrmDocEdit.txtEmail.value = space( 30 )
          FrmDocEdit.txtCUIT.value = 0
          FrmDocEdit.EditObs.value = ""
          FrmDocEdit.cmbEcivil.value = 9
          FrmDocEdit.txtHijos.value = 0
          FrmDocEdit.dFecnac.value = date()
          FrmDocEdit.cmbSalario.value = 9
          FrmDocEdit.cmbListado.value = 9
          FrmDocEdit.dFecAnt.value = date()
          FrmDocEdit.EditTitulos.value = ""
          FrmDocEdit.cmbTDoc.VALUE = 9
          FrmDocEdit.cmbtsexo.VALUE = 9
     else
          FrmDocEdit.txtDNI.value = ( cAliasDOC )->cDNI
          FrmDocEdit.txtApeNom.value = ( cAliasDOC )->cApeNom
          FrmDocEdit.txtDir.value = ( cAliasDOC )->cDir
          FrmDocEdit.cmbCP.value = Alltrim ( ( cAliasDOC )->cCp )
          FrmDocEdit.txtTel.value = ( cAliasDOC )->cTel
          FrmDocEdit.txtCel.value = ( cAliasDOC )->cCel
          FrmDocEdit.txtEmail.value = ( cAliasDOC )->cEmail
          FrmDocEdit.txtCUIT.value = ( cAliasDOC )->cCUIT
          FrmDocEdit.EditObs.value = ( cAliasDOC )->cObs
          FrmDocEdit.cmbEcivil.value = ( cAliasDOC )->cEcivil
          FrmDocEdit.txtHijos.value = ( cAliasDOC )->nHijos
          FrmDocEdit.dFecnac.value = ( cAliasDOC )->dFecNac
          FrmDocEdit.cmbSalario.value = val( ( cAliasDOC )->cSalario )
          FrmDocEdit.cmbListado.value = ( cAliasDOC )->cListado
          FrmDocEdit.dFecAnt.value = ( cAliasDOC )->dFecAnt
          FrmDocEdit.EditTitulos.value =( cAliasDOC )->cTitulo
          FrmDocEdit.cmbTDoc.VALUE = ( cAliasDOC )->CTDOC
          FrmDocEdit.cmbtsexo.VALUE = ( cAliasDOC )->CTSEXO

     endif
//     FrmDocEdit.txtDNI.Enabled = iif( nOp = _NEW, .T., .F. )
     FrmDocEdit.cmbTDoc.SetFocus()
     Center Window FrmDocEdit
     Activate Window FrmDocEdit
     return( nil )

//-----------------------------------------------------------------------------
Function SaveDOC( nOp, cAliasDOC )

     IF nOp = _NEW
          ( cAliasDOC )->( dbAppend() )
     ENDIF
     ( cAliasDOC )->( RLock() )
     ( cAliasDOC )->cDNI := FrmDocEdit.txtDNI.value
     ( cAliasDOC )->cApeNom := FrmDocEdit.txtApeNom.value
     ( cAliasDOC )->cDir := FrmDocEdit.txtDir.value
     ( cAliasDOC )->cCp := FrmDocEdit.cmbCP.value
     ( cAliasDOC )->cTel := FrmDocEdit.txtTel.value
     ( cAliasDOC )->cCel := FrmDocEdit.txtCel.value
     ( cAliasDOC )->cEmail := FrmDocEdit.txtEmail.value
     ( cAliasDOC )->cCUIT := FrmDocEdit.txtCUIT.value
     ( cAliasDOC )->cObs := FrmDocEdit.EditObs.value
     ( cAliasDOC )->cEcivil := FrmDocEdit.cmbEcivil.value
     ( cAliasDOC )->nHijos := FrmDocEdit.txtHijos.value
     ( cAliasDOC )->dFecNac := FrmDocEdit.dFecnac.value
     ( cAliasDOC )->cSalario := alltrim( str(FrmDocEdit.cmbSalario.value ) )
     ( cAliasDOC )->cListado := FrmDocEdit.cmbListado.value
     ( cAliasDOC )->dFecAnt := FrmDocEdit.dFecAnt.value
     ( cAliasDOC )->cTitulo := FrmDocEdit.EditTitulos.value
     ( cAliasDOC )->CTDOC := frmDocEdit.cmbTDoc.VALUE
     ( cAliasDOC )->CTSEXO :=FrmDocEdit.cmbtsexo.VALUE


     ( cAliasDOC )->( dbcommit() )
     ( cAliasDOC )->( dbUnlock() )
     FrmDocEdit.Release()
     Refresh( cAliasDOC, "FrmDOC", "BROWSE_1" )
     RETURN NIL

//-----------------------------------------------------------------------------
Function DelDOC( cAliasDOC )
// 1 Yes
// 2 NO
// 0 CANCEL
     if MsgYesNoCancel( "Desea Borrar Este Registro ?", "Aviso Del Sistema" ) = 1
          ( cAliasDOC )->( RLOCK() )
          ( cAliasDOC )->( DBDELETE() )
          ( cAliasDOC )->( dbcommit() )
          ( cAliasDOC )->( dbUnlock() )
          Refresh( cAliasDOC, "FrmDOC", "BROWSE_1" )
     endif
     RETURN NIL

//-----------------------------------------------------------------------------
Function RptDOC( cAliasDOC )

     Local nLin := 999
     Local oPrint
     Local aPos := { 1, 15 }
     Local cTit := "Listado de Docente"
     Local aHead := { { "", "    DNI" }, { "", "DOCente" } }
     Local cEmpresa := Empresa()
     Local lLandscape := .T. // impresion horizontal llanscape=.F. impresion Vertical
     Local nDatos := 0, nPag := 0

     ( cAliasDOC )->( dbeval( { || nDatos+= 1 } ) )
     IF IniPrint( @oPrint, lLandscape  )
          ( cAliasDOC )->( dbgotop() )
          do while ! ( cAliasDOC )->( eof() )
               HeadRpt( oPrint, @nLin, cTit, aHead, aPos, lLandscape, @nDatos, @nPag )
               oPrint:printdata( nLin, aPos[ 1 ], " " + ( cAliasDOC )->cdni,"Courier New", 12 )
               oPrint:printdata( nLin, aPos[ 2 ], (cAliasDOC )->capenom,"Courier New", 12 )
               ( cAliasDOC )->( dbskip() )
           enddo
           FooterRpt( oPrint, lLandscape, nDatos, @nPag )
           oPrint:enddoc()
           oPrint:RELEASE()
      endif

     Refresh( cAliasDOC, "FrmDOC", "Browse_1" )
     return nil

//-----------------------------------------------------------------------------
Function CodDOC( cAlias )
          Local cCodigo := "0001"
          Local cIndice := ( cAlias )->( ORDNAME() )

          ( cAlias )->( OrdSetFocus( "DOCcod" ) ) ; ( cAlias )->( Dbgobottom() )
          if ! ( cAlias )->( eof() )
               cCodigo := strzero ( val ( ( cAlias )->( cCodDOC ) ) + 1 , 4 )
          endif
          ( cAlias )->( OrdSetFocus( cIndice ) )
          return ( cCodigo )

//-----------------------------------------------------------------------------
Function SelecTAB( cAliasTAB, nOp )
     Local nRecno := Tablas( .T., nOP )

     if !empty( nRecno )
          ( cAliasTAB )->( dbgoto( nrecno ))
          FrmDocEdit.cmbCP.value := ( cAliasTAB )->cCodTAB
     endif
     FrmDocEdit.cmbCP.Refresh()
     return( NIL )

Function NombreDoc( cAlias, cDNI )
     Local cOrd := ( cAlias )->( OrdName() )
     Local cRetorno := "No Encontrado"

     ( cAlias )->( DbSetOrder( "DOCdni" ) )
     if ( cAlias )->( DbSeek( cDNI ))
          cRetorno := ( cAlias )->cApeNom
     endif
     ( cAlias )->( DbSetOrder( cOrd ) )
     return( cRetorno )



