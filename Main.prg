*-- PROGRAM FILE -------------------------------------------------------
*         Description : SISTEMA PARA MARCELO WEBER
*           File Name : Main.prg
*              Author : Carvalho Alejandro - HerculeSoft (c) 2007
*   Date Time Created : 10/29/2009 - 08:02
* Date Time updated :>: 02/16/2018 10:48
*             Comment : MODULO PRINCIPAL
*   History Update :>>:
*   02/15/18-02/16/18
*   02/04/18-02/05/18
*   02/02/18
*   01/31/18
*   01/26/18
*   03/12/13
*   06/11/12
*   06/07/12
*   06/02/12
*   05/28/12-05/30/12 Version Estable
*-----------------------------------------------------------------------
#include "oohg.ch"
#include "Contralor.ch"

/*
Ma¤ana Hasta las 12:00
Tarde  Desde las 12:00 hasta 17:30

Cargos
     Jerarquicos
     Base




*/




//-----------------------------------------------------------------------------
Function Main()
     Local _nAltoPantalla := getDesktopHeight()
     Local _nAnchoPantalla := getDesktopWidth()
     Local oWndMain, oMeter, oLblMen


     SET CENTURY ON
     SET DELETED ON
     SET INTERACTIVECLOSE ON
     SET NAVIGATION EXTENDED
     REQUEST DBFCDX
     RDDSETDEFAULT( "DBFCDX" )
     SET BROWSESYNC ON
     SET DATE TO FRENCH
     SET DECIMALS TO 2

     SET TOOLTIPSTYLE BALLOON
     SET TOOLTIPBACKCOLOR  { 255, 255, 255 }
     SET TOOLTIPFORECOLOR  { 0, 0, 255 }



     DEFINE WINDOW Frm_WndMain oBj oWndMain ;
                   AT 0, 0 WIDTH _nAnchoPantalla HEIGHT _nAltoPantalla ;
                   TITLE "Contralor Docente" ;
                   ICON "PUB" MDI FONT "Arial" SIZE 10 BACKCOLOR { 212, 208, 251 }

     DEFINE TOOLBAR TbarMain BUTTONSIZE 20, 20 FONT "Arial" SIZE 9 RIGHTTEXT
     BUTTON BtnExit ;
            PICTURE "EXIT" ;
            CAPTION "Salir" ;
            ACTION ThisWindow.Release ;
            TOOLTIP "Salir"

     BUTTON BtnCLI  ;
            PICTURE "B_CLI" ;
            CAPTION "Docentes" ;
            ACTION Docentes() ;
            TOOLTIP "Actualizar Docentes"

     BUTTON BtnCupof  ;
            PICTURE "EDIT" ;
            CAPTION "Cupof" ;
            ACTION Cupof() ;
            TOOLTIP "Actualizar Cupof"

     BUTTON BtnTAB ;
            PICTURE "EDIT" ;
            CAPTION "Tablas" ;
            ACTION Tablas() ;
            TOOLTIP "Actualizar o Consultar Tablas"

     BUTTON BtnFAC ;
            PICTURE "B_FAC" ;
            CAPTION "Ausencia" ;
            ACTION Ausencia() ;
            TOOLTIP "Crear e Imprimir Facturas"

     BUTTON BtnLIC ;
            PICTURE "B_FAC" ;
            CAPTION "Licencias" ;
            ACTION Licencias() ;
            TOOLTIP "Crear e Imprimir Facturas"

     BUTTON main_calc ;
            CAPTION 'Calculadora' ;
            TOOLTIP 'Calculadora' ;
            PICTURE "B_CALC" ;
            ACTION shellexecute( 0, 'open', 'calc.exe' ) ;

     BUTTON main_excel ;
            CAPTION 'Excel' ;
            TOOLTIP 'Excel' ;
            PICTURE 'B_EXCEL' ;
            ACTION shellexecute( 0, 'open', 'excel.exe',,, 1 ) ;

     DEFINE MAIN MENU
     POPUP '&Archivo'
     ITEM '&Docentes' ACTION DOCentes()
     SEPARATOR
     ITEM '&Cupof' ACTION Cupof()
     SEPARATOR
     ITEM 'ABM &Tablas Generales' ACTION Tablas()
     SEPARATOR
     ITEM '&Salir' ACTION ThisWindow.release
END POPUP
POPUP '&Movimiento'
ITEM 'Movimiento Docente' ACTION Movimiento()
END POPUP
POPUP 'Informes'
ITEM 'Personal con DNI' ACTION RptDocDNI()
ITEM 'Notificacion Personal ( TODOS )' ACTION RptDocDNI()
ITEM 'Notificacion Personal ( TITULAR )' ACTION RptTNoti()
ITEM 'Suplentes del Personal' ACTION RptSup()
SEPARATOR
ITEM 'Asistencia Individual Docente' ACTION EnDesarrollo()
ITEM 'Inasistencia sin Justificar Docente' ACTION EnDesarrollo()
SEPARATOR
ITEM 'Asistencia Docente x Dia' ACTION RptDocxDia()
END POPUP
POPUP '&Herramientas'
ITEM "Configuracion" ACTION cfg()
ITEM '&Chequeo Sistema' ACTION MsgMeter ( "Chekeando Sistema", "Aviso Del Sistema", { | oMeter, oLblMen | CreateDBF( oMeter, oLblMen ) } )
ITEM '&Ordenar archivos' ACTION MsgMeter ( "Ordenando", "Aviso Del Sistema", { | oMeter, oLblMen | Ordenar( oMeter, oLblMen ) } )
END POPUP
POPUP 'A&yuda'
ITEM '&Acerca de...' ACTION About()
END POPUP

END MENU

DEFINE STATUSBAR
STATUSITEM "HerculeSoft (c) 2018" + Left( FileInfo( exename() ), 21 )
KEYBOARD
DATE
CLOCK
END STATUSBAR
END WINDOW
Frm_WndMain.Maximize
MsgMeter ( "Chekeando Sistema", "Aviso Del Sistema", { | oMeter, oLblMen | CreateDBF( oMeter, oLblMen ) } )
// MsgMeter ( "Ordenando", "Aviso Del Sistema", { | oMeter, oLblMen | Ordenar( oMeter, oLblMen ) } )
// MsgMeter ( "Chekeando Suplentes", "Aviso Del Sistema", { | oMeter, oLblMen | lActivo( oMeter, oLblMen ) } )

ACTIVATE WINDOW Frm_WndMain
Return Nil

//-----------------------------------------------------------------------------
Function About()

     Load Window FrmAbout
     Center Window FrmAbout
     FrmAbout.Label_1.Value := "Contralor"
     FrmAbout.Label_2.Value := "Docente"
     FrmAbout.Label_3.Value := " 0.0.1"
     FrmAbout.Label_4.Value := "Fecha Del Ejecutable : " + Left( FileInfo( exename() ) , 18 )
     FrmAbout.Label_5.Value := "CopyRight (c) HerculeSoft 2018"
     Activate Window FrmAbout

