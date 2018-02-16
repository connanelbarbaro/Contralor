*-- PROGRAM FILE -------------------------------------------------------
*         Description :
*           File Name : Prueba.prg
*              Author : Carvalho Alejandro - HerculeSoft (c) 2012
*   Date Time Created : 02/01/2018 - 17:07
* Date Time updated :>: 02/02/2018 08:19
*             Comment :
*   History Update :>>:
*   02/01/18-02/02/18
*-----------------------------------------------------------------------

#include "oohg.ch"
#include "dbstruct.ch"

FUNCTION Prueba()

   LOCAL k, aRows[ 15, 8 ]

   SET DATE BRITISH
   SET CENTURY ON

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 558 ;
      HEIGHT 460 ;
      TITLE 'Grid con Checkboxes' ;
      MAIN

      DEFINE STATUSBAR
         STATUSITEM 'El Poder de OOHG !!!'
      END STATUSBAR

      FOR k :=1 TO 15
          aRows[k] := { STR( HB_RANDOMINT( 99 ), 2), ;
                        HB_RANDOMINT( 100 ), ;
                        DATE() + RANDOM( HB_RANDOMINT() ), ;
                        'Refer ' + STR( HB_RANDOMINT( 10 ), 2 ), ;
                        HB_RANDOMINT( 10000 ) }
      NEXT k

      @ 10,10 GRID Grid_1 OBJ oGrid ;
         WIDTH 520 ;
         HEIGHT 330 ;
         HEADERS { 'Hora', 'Horario','Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes' } ;
         WIDTHS { 60, 80, 100, 120, 140 } ;
         ITEMS aRows ;
         COLUMNCONTROLS { {'TEXTBOX', 'NUMERIC', '999999'} ,;
                          { 'TEXTBOX', 'NUMERIC', '999999'} , ;
                          { 'TIMEPICKER', 'DATE'}, ;
                          { 'TEXTBOX', 'CHARACTER'}, ;
                          { 'TEXTBOX', 'NUMERIC', '999,999,999.99' } } ;
         FONT 'COURIER NEW' SIZE 10 ;
         EDIT INPLACE

      @ 360,10 LABEL lbl_1 ;
         VALUE 'Pruebe el menú contextual. Use el mouse o la ' + ;
               'barra espaciadora para tildar/destildar los ítems.' ;
         AUTOSIZE



      ON KEY ESCAPE ACTION Form_1.Release()
   END WINDOW

   CENTER WINDOW Form_1
   ACTIVATE WINDOW Form_1

RETURN NIL

FUNCTION CheckAllItems( oGrid )
   LOCAL i

   FOR i := 1 TO oGrid:ItemCount
      oGrid:CheckItem( i, .T. )
   NEXT i

RETURN NIL

FUNCTION UncheckAllItems( oGrid )
   LOCAL i

   FOR i := 1 TO oGrid:ItemCount
      oGrid:CheckItem( i, .F. )
   NEXT i

RETURN NIL

FUNCTION ItemsChecked( oGrid )
   LOCAL i, aItems := {}

   FOR i := 1 TO oGrid:ItemCount
      IF oGrid:CheckItem( i )
         AADD( aItems, i )
      ENDIF
   NEXT i

   IF LEN( aItems ) > 0
      AutoMsgBox( aItems )
   ELSE
      AutoMsgBox( 'Ningún ítem está tildado !!!' )
   ENDIF

RETURN NIL

/*
 * EOF
 */