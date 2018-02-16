*-- PROGRAM FILE -------------------------------------------------------
*         Description :
*           File Name : Ausencia.prg
*              Author : Carvalho Alejandro - HerculeSoft (c) 2012
*   Date Time Created : 02/08/2018 - 15:37
* Date Time updated :>: 02/11/2018 07:31
*             Comment :
*   History Update :>>:
*   02/10/18-02/11/18
*   02/08/18
*-----------------------------------------------------------------------
#include "oohg.ch"
#include "Contralor.ch"

Function Ausencia()

     Local cAliasAus, cAliasHor, cAliasDoc1, cAliasMOV, cAliasDoc2
     Local aDoc :={}

     Public cAliasDoc3

     cAliasHOR := AbrirDBF( "HCUPOF", "HCupofDIA" )
     cAliasDOC1 := AbrirDBF( "DOCENTES", "DOCdni" )
     cAliasMOV := AbrirDBF( "MOVIMIENTO", "MOVactivo" )
     ( cAliasMov )->( dbsetrelation( cAliasDOC1, {|| ( cAliasMov )->cDNIs}, "( cAliasMov )->cDNIs"))
     cAliasDOC2 := AbrirDBF( "DOCENTES", "DOCnom" )
     cAliasDOC3 := AbrirDBF( "DOCENTES", "DOCdni" )
     cAliasAUS := AbrirDBF( "AUSENCIAS", "AUSfecha" )
     ( cAliasAUS )->( dbsetrelation( cAliasDOC3, {|| (cAliasAUS)->cdni}, "(cAliasAUS)->cdni" ) )

     Load Window FrmAusencia
     Center Window FrmAusencia
     FrmAusencia.dFecha.value := ctod( "  /  /    ")
     FrmAusencia.cbxDia.Value = 1
     AusFiltro1( cAliasHor, cAliasDoc1, cAliasMOV )
     AusFiltro2( cAliasAus )
     Activate Window FrmAusencia
     CerrarDBF( { cAliasAus, cAliasHor, cAliasDoc1, cAliasMOV, cAliasDoc2 } )
     return

Function AusFiltro1( cAliasHor, cAliasDoc1, cAliasMOV)
     Local cDia := str(FrmAusencia.cbxDia.Value, 2)
     Local cCupof := ""

// FILTRA DOCENTES X DIA DE LA SEMANA

     FrmAusencia.Grid_1.DeleteAllItems()
     ( cAliasHor )->( dbclearFilter() )
     ( cAliasHor )->( dbsetFilter( {||( cAliasHor )->cDia=cDia }, "( cAliasHor )->cDia=cDia" ) )
     ( cAliasHor )->( DbGoTop() )

     DO WHILE !( cAliasHor )->( EOF() )

          ( cAliasMOV )->( dbclearFilter() )
          ( cAliasMOV )->( dbsetFilter( {||( cAliasMOV )->cCupof=( cAliasHor )->cCupof }, "( cAliasMOV )->cCupof=( cAliasHor )->cCupof" ) )
          ( cAliasMOV )->( DbGoTop() )
          DO WHILE !( cAliasMOV )->( EOF() )
               FrmAusencia.Grid_1.AddItem( { (cAliasDoc1)->cDNI, (cAliasDoc1)->cApeNom} )
               ( cAliasMOV )->( dbskip() )
          ENDDO
         ( cAliasHOR )->( dbskip() )
    ENDDO
    FrmAusencia.Grid_1.Refresh()
    RETURN NIL

Function AusGrabar( cAliasAUS, nOp )
     Local cDNI := ""
     Local uA := ""

     IF nOp = 1
          cDNI := FrmAusencia.cbxDoc.Value
     else
          uA := FrmAusencia.Grid_1.item( FrmAusencia.Grid_1.value )
          cDNI := ua[ 1 ]
     endif
     ( cAliasAUS )->( dbAppend() )
     ( cAliasAUS )->dfecha := FrmAusencia.dfecha.value
     ( cAliasAUS )->cDNI := cDNi
     ( cAliasAUS )->lEstado := .F.
     ( cAliasAUS )->( dbcommit() )
     ( cAliasAUS )->( dbUnlock() )
     Refresh( ( cAliasAUS ), "FrmAusencia", "BROWSE_1" )
     RETURN NIL

Function AusFiltro2( cAliasAus )

// FILTRO AUSENCIAS POR DIA
     ( cAliasAus )->( dbclearFilter() )
     ( cAliasAus )->( dbsetFilter( {||( cAliasAus )->dfecha=FrmAusencia.dfecha.value }, "( cAliasAus )->dfecha=FrmAusencia.dfecha.value" ) )
     Refresh( ( cAliasAUS ), "FrmAusencia", "BROWSE_1" )
     Return NIL




