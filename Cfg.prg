#include "oohg.ch"

//-----------------------------------------------------------------------------
Function Cfg()

     Load Window FrmCfg
     Center Window FrmCfg
     CargarDatos()

     Activate Window FrmCfg
     Return( nil )


//-----------------------------------------------------------------------------
Function CargarDatos()

     Local cSection := "Escuela"
     Local aItem := { "Escuela", "Distrito", "Organizacion", "Escuela", "Establecimiento", "Domicilio", "Telefono", "Correo", "Categoria",;
     "Turno", "Desfavorable" }
     Local aDatos := array( Len( aItem ) )

// leer datos
     BEGIN INI FILE "Contralor.ini"
          For i = 1 to Len( aItem )
               GET aDatos[ i ] SECTION cSection ENTRY aItem[ i ] DEFAULT aItem[ i ]
          next i
     END INI




// Grabar Datos

     BEGIN INI FILE "Contralor.ini"
          For i = 1 to Len( aItem )
               SET SECTION cSection ENTRY aItem[ i ] TO aDatos[ i ]
          next i
   END INI

   RETURN NIL
Function GrabarCFG()
     Return nil
