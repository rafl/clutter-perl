#include "clutter-gtk-perl.h"

MODULE = Gtk2::Clutter::Viewport        PACKAGE = Gtk2::Clutter::Viewport       PREFIX = gtk_clutter_viewport_

ClutterActor_noinc *
gtk_clutter_viewport_new (class=NULL, h_adjust=NULL, v_adjust=NULL, z_adjust=NULL)
        GtkAdjustment_ornull *h_adjust
        GtkAdjustment_ornull *v_adjust
        GtkAdjustment_ornull *z_adjust
    C_ARGS:
        h_adjust, v_adjust, z_adjust

void
gtk_clutter_viewport_get_origin (GtkClutterViewport *viewport, OUTLIST gfloat x, OUTLIST gfloat y, OUTLIST gfloat z)
