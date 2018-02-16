*-- PROGRAM FILE -------------------------------------------------------
*         Description :
*           File Name : Ausencia.prg
*              Author : Carvalho Alejandro - HerculeSoft (c) 2012
*   Date Time Created : 02/08/2018 - 15:37
* Date Time updated :>: 02/12/2018 13:54
*             Comment :
*   History Update :>>:
*   02/10/18-02/12/18
*   02/08/18
*-----------------------------------------------------------------------
#include "oohg.ch"
#include "Contralor.ch"
// 9
// 10, 30, 10, 3
// 90, 270, 90, 27

Function Licencias()

     Local cAliasAUS, cAliasDOC2, cAliasLic, cAliasLic2

     Local aArt := {}
     Local aInc := {}

     Public cAliasDoc1
     cAliasLic2 := AbrirDBF( "Licencias")
     cAliasLic := AbrirDBF( "TABLA", "TABlic1" )
     (cAliasLic)->( dbeval( { || aadd( aArt, (cAliasLic)->cCodTAB ) } ) )
     (cAliasLic)->( dbsetOrder( "TABlic2" ) )
     cAliasDOC1 := AbrirDBF( "DOCENTES", "DOCdni" )
     cAliasDOC2 := AbrirDBF( "DOCENTES", "DOCnom" )
     cAliasAUS := AbrirDBF( "AUSENCIAS", "AUSfecha")
     ( cAliasAUS )->( dbsetrelation( cAliasDOC1, {|| (cAliasAUS)->cdni}, "(cAliasAUS)->cdni" ) )

     Load Window FrmLicencias
     Center Window FrmLicencias
     LicFecha()
     Activate Window FrmLicencias
     CerrarDBF( { cAliasDoc1, cAliasAUS, cAliasDOC2, cAliasLic } )
     return

Function LicFecha()
     FrmLicencias.dFecha2.Value := FrmLicencias.dFecha1.value + FrmLicencias.nDias.value - 1
     FrmLicencias.dFecha2.Refresh()
     return nil

Function LicFiltro( cAliasLic )

     FrmLicencias.cbxInc.DeleteAllItems()
     (cAliasLic)->( dbgotop())
     do while !(cAliasLic)->( eof() )
          if (cAliasLic)->cClaTAB = str( 12 , 2 ) .and. (cAliasLic)->cCodTAB =FrmLicencias.cbxArt.DisplayValue
               FrmLicencias.cbxInc.AddItem( (cAliasLic)->cIncTAB + " | " + (cAliasLic)->cDesTAB )
          endif
          (cAliasLic)->( dbskip() )
     enddo
     FrmLicencias.cbxInc.value := 1
     FrmLicencias.cbxInc.Refresh()

     return nil

Function LicGrabar( cAliasAUS, cAliasLic2 )

     ( cAliasLic2 )->( dbAppend() )
     ( cAliasLic2 )->( RLock() )
     ( cAliasLic2 )->dDesde := FrmLicencias.dFecha1.value
     ( cAliasLic2 )->dHasta := FrmLicencias.dFecha2.value
     ( cAliasLic2 )->cDNI := FrmLicencias.cbxDoc.value
     ( cAliasLic2 )->cArt := FrmLicencias.cbxArt.Displayvalue
     ( cAliasLic2 )->cInc := Left(FrmLicencias.cbxInc.Displayvalue,10)
     ( cAliasLic2 )->( dbcommit() )
     ( cAliasLic2 )->( dbUnlock() )

     ( cAliasAUS )->( dbgotop() )
     do while !( cAliasAUS )->( eof() )
          if ( cAliasAUS )->cDni = FrmLicencias.cbxDoc.value
               if ( cAliasAUS )->dFecha >= FrmLicencias.dFecha1.value .and. ( cAliasAUS )->dFecha <= FrmLicencias.dFecha2.value
                    ( cAliasAus )->( RLock() )
                    ( cAliasAUS )->lEstado := .T.
                    ( cAliasAUS )->( dbcommit() )
                    ( cAliasAUS )->( dbUnlock() )
               endif
          endif
          ( cAliasAUS )->( dbSKIP() )
     enddo
     ( cAliasAUS )->( dbCLEARFILTER() )
     ( cAliasAUS )->( dbgotop() )
     FrmLicencias.Browse_1.refresh()
     RETURN NIL

