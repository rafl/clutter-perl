#include "clutter-gtk-perl.h"

MODULE = Gtk2::Clutter::Viewport        PACKAGE = Gtk2::Clutter::Viewport       PREFIX = gtk_clutter_viewport_

ClutterActor_noinc *
gtk_clutter_viewport_new (class=NULL, h_adjust=NULL, v_adjust=NULL, z_adjust=NULL)
        GtkAdjustment_ornull *h_adjust
        GtkAdjustment_ornull *v_adjust
        GtkAdjustment_ornull *z_adjust
    C_ARGS:
        h_adjust, v_adjust, z_adjust

=for apidoc
=for signature (x, y, z) = $viewport->get_origin
=cut
void
gtk_clutter_viewport_get_origin (GtkClutterViewport *viewport)
    PREINIT:
        gfloat x, y, z;
    PPCODE:
        x = y = z = 0;
        gtk_clutter_viewport_get_origin (viewport, &x, &y, &z);
        EXTEND (SP, 3);
        PUSHs (sv_2mortal (newSVnv (x)));
        PUSHs (sv_2mortal (newSVnv (y)));
        PUSHs (sv_2mortal (newSVnv (z)));
