#define VERSION     "1.0"
#define EMAIL       "HerculeSoft@gmail.com"

#define CRLF        chr( 10 ) + chr( 13 )
#define _AVISO      "Aviso Del Sistema"

#define _NEW         1
#define _DEL         2
#define _EDIT        3
#define _VIEW        4
#define _PRN         5
#define bColor      { || IIF( ORDKEYNO()  % 2 =00, BLUE , ORANGE ) }
#define _LPP 50


// printdata(nlin,ncol,data,cfont,nsize,lbold,acolor,calign,nlen,litalic) CLASS TPRINTBASE
// selprinter(lselect,lpreview,llandscape,npapersize,,,-2)
// oprint:setpreviewsize( 1 )  /// tamaño del preview  1 menor,2 mas grande ,3 mas...

#Define CLR_LGRAY   RGB(230,230,230)
#Define CLR_LGREEN  RGB(190,215,190)

#define clrAmarillo {255,255,200}
#define clrRojo     {255,0,0}
#define clrAzul     {0,0,255}
#define clrNegro    {0,0,0}
#define clrBlanco   {255,255,255}
#define clrBack     {255,255,200}
#define clrNormal   {255,255,255}
#define cFormat     "999,999,999.99"


#define _DFECHA   120
#define _NCANT     50
#define _NIMPORTE 120
#define _CCODIGO   60
#define _NWIDTH   170

#define _PICIMPORTE     "99999999.99"
#define _PICCANTIDAD    "99999"

#Define CLR_LGRAY   RGB(230,230,230)
#Define CLR_LGREEN  RGB(190,215,190)

#define _D   BROWSE_JTFY_RIGHT
#define _I   BROWSE_JTFY_LEFT
#define _C   BROWSE_JTFY_CENTER


