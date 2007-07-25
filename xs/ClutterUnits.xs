#include "clutterperl.h"

MODULE = Clutter::Units         PACKAGE = Clutter::Units

gint32
FROM_INT (class=NULL, gint value)
    CODE:
        RETVAL = CLUTTER_UNITS_FROM_INT (value);
    OUTPUT:
        RETVAL

gint
TO_INT (class=NULL, gint32 units)
    CODE:
        RETVAL = CLUTTER_UNITS_TO_INT (units);
    OUTPUT:
        RETVAL

gint32
FROM_FLOAT (class=NULL, gdouble value)
    CODE:
        RETVAL = CLUTTER_UNITS_FROM_FLOAT (value);
    OUTPUT:
        RETVAL

gdouble
TO_FLOAT (class=NULL, gint32 units)
    CODE:
        RETVAL = CLUTTER_UNITS_TO_FLOAT (units);
    OUTPUT:
        RETVAL
