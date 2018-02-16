#include "oohg.ch"

//-----------------------------------------------------------------------------
FUNCTION xlistar( cAlias,;
                  ctag,;
                  ctitulo,;
                  acampos,;
                  atitulos,;
                  cLabel,;
                  cText )
     Local lOk := .F.
     Local cObj, cWin
     cObj :=This.Name
     cWin :=ThisWindow.Name

     ( cAlias )->( ordsetfocus( cTag ) )
     ( cAlias )->( DbGotop() )

     Load Window xListar
     Center Window xListar
     Refresh( cAlias, "xListar", "Browse_1" )
     Activate Window xListar
     if lOk
          spr( "ABM_ART", "Text_1", "value", ( cAlias )->cCodCLI )
     else
          AutoMsgInfo( cWin )
     endif

     Return( nil )
