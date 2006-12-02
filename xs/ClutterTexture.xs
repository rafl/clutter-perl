#include "clutterperl.h"

MODULE = Clutter::Texture       PACKAGE = Clutter::Texture      PREFIX = clutter_texture_

ClutterActor *
clutter_texture_new (class, pixbuf=NULL)
        GdkPixbuf_ornull *pixbuf
    CODE:
        if (pixbuf)
                RETVAL = clutter_texture_new_from_pixbuf (pixbuf);
        else
                RETVAL = clutter_texture_new ();
    OUTPUT:
        RETVAL

