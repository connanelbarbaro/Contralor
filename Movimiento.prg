*-- PROGRAM FILE -------------------------------------------------------
*         Description : CONTRALOR
*           File Name : DOCentes.prg
*              Author : Carvalho Alejandro - HerculeSoft (c) 2007
*   Date Time Created : 10/29/2009 - 08:02
* Date Time updated :>: 02/14/2018 15:38
*             Comment : MODULO ABM DOCENTES
*   History Update :>>:
*   02/14/18
*   02/11/18
*   02/09/18
*   02/04/18-02/05/18
*   01/26/18-02/01/18
*-----------------------------------------------------------------------
#include "oohg.ch"
#include "Contralor.ch"

DECLARE WINDOW FrmMov
DECLARE WINDOW FrmMovEdit
//-----------------------------------------------------------------------------
Function Movimiento( lSelect )

     Local cAliasMov
     Local cMov := ""
     Local lGrabar := .F.
     Local bNew := {|| EditMov( _NEW, cAliasMov, cAliasDOC1, cAliasDOC2, cAliasCUPOF, cAliasSRevista ) }
     Local bDel := {|| DelMov( cAliasMov ) }
     Local bEdit:= {|| EditMov( _EDIT, cAliasMov, cAliasDOC1, cAliasDOC2, cAliasCUPOF, cAliasSRevista ) }
     Local bRpt := {|| RptMov( cAliasMov, cAliasTAB ) }
     Local bActu:= {|| Refresh( cAliasMov, "FrmMOV", "BROWSE_1" ) }
     Local bSele:= {|| cMov:= ( cAliasMov )->cMov ,ThisWindow.Release }
     Local bView := ""
     Local bDBG :=""

     Public cAliasDOC1, cAliasCUPOF, cAliasSRevista, cAliasDOC2
     Default lSelect := .F.
     bView:= iif( lSelect, bSele, bEdit )

     cAliasDOC1 := AbrirDBF( "DOCENTES", "DOCdni" )
     cAliasDOC2 := AbrirDBF( "DOCENTES", "DOCdni" )
     cAliasCUPOF := AbrirDBF( "CUPOF", "CUPOFcod" )
     cAliasSRevista := AbrirDBF( "TABLA", "TABdes" )
     ( cAliasSRevista )->( dbsetfilter( {|| ( cAliasSRevista )->cClaTab = str( 8, 2 ) },"( cAliasSRevista )->cClaTab = str( 8, 2 )") )
     ( cAliasSRevista )->( dbgotop() )


     cAliasMov := AbrirDBF( "Movimiento", "MOVdesde" )
     ( cAliasMov )->( DbGotop() )
     ( cAliasMov )->( dbsetrelation( cAliasDOC1, {|| ( cAliasMov )->cDNIs}, "( cAliasMov )->cDNIs"))
     ( cAliasMov )->( dbsetrelation( cAliasCupof, {|| ( cAliasMov )->cCupof}, "( cAliasMov )->cCupof"))
     ( cAliasMov )->( dbsetrelation( cAliasDOC2, {|| ( cAliasMov )->cDNI}, "( cAliasMov )->cDNI"))
     ( cAliasMov )->( DbGoBottom())

     Load Window FrmMov
     Center Window FrmMov
//     FrmMov.Browse_1.ColumnsAutoFit
     Activate Window FrmMov
     CerrarDBF( {cAliasMov, cAliasDOC1, cAliasDOC2, cAliasCUPOF, cAliasSRevista } )

     Return( cMov )

//-----------------------------------------------------------------------------
Function EditMov( nOp, cAliasMov, cAliasDOC1, cAliasDOC2, cAliasCUPOF, cAliasSRevista )

     Load Window FrmMovEdit
     if nOp = _NEW
          FrmMovEdit.cCupof.Value := space( 10 )
          FrmMovEdit.cDocTit.Value := "99999999"
          FrmMovEdit.cDocAlta.Value := "99999999"
          FrmMovEdit.CSitRev.Value := ( cAliasSRevista )->cCodTab
          FrmMovEdit.dFecAlta.Value := date()
          FrmMovEdit.dFecCese.Value := ctod( "  /  /    ")

     else
          FrmMovEdit.cCupof.Value := ( cAliasMov )->cCupof
          FrmMovEdit.cDocTit.Value := ( cAliasMov )->cDNI
          FrmMovEdit.cDocAlta.Value := ( cAliasMov )->cDNIs
          FrmMovEdit.cSitRev.Value := ( cAliasMov )->cSitRev
          FrmMovEdit.dFecAlta.Value := ( cAliasMov )->dDesde
          FrmMovEdit.dFecCese.Value := ( cAliasMov )->dHasta
     endif
     Center Window FrmMovEdit
     Activate Window FrmMovEdit
     return( nil )

//-----------------------------------------------------------------------------
Function SaveMov( nOp, cAliasMov )


     IF nOp = _NEW
          ( cAliasMov )->( dbAppend() )
     ENDIF

    ( cAliasMov )->( dbrlock() )
    ( cAliasMov )->cCupof := FrmMovEdit.cCupof.Value
    ( cAliasMov )->cDNI := FrmMovEdit.cDocTit.Value
    ( cAliasMov )->cDNIS := FrmMovEdit.cDocAlta.Value
    ( cAliasMov )->cSitRev := FrmMovEdit.cSitRev.Value
    ( cAliasMov )->dDesde := FrmMovEdit.dFecAlta.Value
    ( cAliasMov )->dHasta := FrmMovEdit.dFecCese.Value
     ( cAliasMov )->lActivo := .T.
     ( cAliasMov )->( dbcommit() )
     ( cAliasMov )->( dbUnlock() )
     FrmMovEdit.Release()
     Refresh( cAliasMov, "FrmMov", "BROWSE_1" )
     RETURN NIL

//-----------------------------------------------------------------------------
Function DelMov( cAliasMov )
// 1 Yes
// 2 NO
// 0 CANCEL
     if MsgYesNoCancel( "Desea Borrar Este Registro ?", "Aviso Del Sistema" ) = 1
          ( cAliasMov )->( RLOCK() )
          ( cAliasMov )->( DBDELETE() )
          ( cAliasMov )->( dbcommit() )
          ( cAliasMov )->( dbUnlock() )
          Refresh( cAliasMov, "FrmMov", "BROWSE_1" )
     endif
     RETURN NIL

//-----------------------------------------------------------------------------
Function RptMov( cAliasMov, cAliasTAB, cPrinter )

     Local nLin := 999
     Local oPrint
     Local aPos := { 1, 8, 40, 80 }
     Local cTit := "Listado de Materia"
     Local aHead := { { "", "Mov" }, { "", "Materia" }, { "", "" }, { "", "" } }
     Local cEmpresa := Empresa()
     Local lLandscape := .T. // impresion horizontal llanscape=.F. impresion Vertical
     Local nDatos := 0, nPag := 0

     ( cAliasMov )->( dbeval( { || nDatos+= 1 } ) )
     IF IniPrint( @oPrint, lLandscape  )
          ( cAliasMov )->( dbgotop() )
          do while ! ( cAliasMov )->( eof() )
               HeadRpt( oPrint, @nLin, cTit, aHead, aPos, lLandscape, @nDatos, @nPag )
               oPrint:printdata( nLin, aPos[ 1 ], " " + ( cAliasMov )->cMov,"Courier New", 12 )
               oPrint:printdata( nLin, aPos[ 2 ], (cAliasMov )->capenom,"Courier New", 12 )
               oPrint:printdata( nLin, aPos[ 3 ], ( cAliasMov )->cDir,"Courier New", 12 )
//               oPrint:printdata( nLin, aPos[ 4 ], RptCiudad( cAliasTAB, ( cAliasMov )->cCp ),"Courier New", 12 )
               ( cAliasMov )->( DbSkip() )
           enddo
           FooterRpt( oPrint, lLandscape, nDatos, @nPag )
           oPrint:enddoc()
           oPrint:RELEASE()
      endif

     Refresh( cAliasMov, "FrmMov", "Browse_1" )
     return nil

Function MovBuscar( cAliasMOV, cAliasCupof, cAliasDOC1)
     Local cOrd := ( cAliasMOV )->( OrdName() )

     FrmMovEdit.cCupof.value := Cupof( .T.)
     FrmMovEdit.cCupof.Refresh
     ( cAliasCUPOF )->( dbsetOrder( "CUPOFcod" ) )
     IF ( cAliasCUPOF )->( dbseek( FrmMovEdit.cCupof.Value ) )
          FrmMovEdit.cMateria.value := ( cAliasCUPOF )->cMateria
          FrmMovEdit.cMateria.Refresh()
     endif
     ( cAliasMOV )->( Dbsetorder( "MOVcupof" ) )
     ( cAliasMOV )->( DbSetFilter( {|| (cAliasMOV)->cCupof=FrmMovEdit.cCupof.value},"(cAliasMOV)->cCupof=FrmMovEdit.cCupof.value")  )



     ( cAliasMOV )->( Dbsetorder( cOrd ) )
     return( nil )


Function Fmov1( cAlias ,cTag, uVar )
     return( ( cAlias )->cApeNom )





