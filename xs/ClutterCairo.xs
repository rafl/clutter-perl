#include "clutterperl.h"

MODULE = Clutter::Texture::Cairo PACKAGE = Clutter::Texture::Cairo PREFIX = clutter_cairo_

BOOT:
        gperl_set_isa ("Clutter::Cairo::Context", "Cairo::Context");

ClutterActor_noinc *
clutter_cairo_new (class, gint width, gint height)
    C_ARGS:
        width, height

SV *
clutter_cairo_create_context (ClutterCairo *texture)
    PREINIT:
        cairo_t *cr;
    CODE:
        /* We own cr. */
        cr = clutter_cairo_create (texture);
        RETVAL = newSV (0);
        sv_setref_pv (RETVAL, "Clutter::Cairo::Context", (void *) cr);
    OUTPUT:
        RETVAL

SV *
clutter_cairo_create_region_context (texture, x_offset, y_offset, width, height)
        ClutterCairo *texture
        gint x_offset
        gint y_offset
        guint width
        guint height
    PREINIT:
        cairo_t *cr;
    CODE:
        /* We own cr. */
        cr = clutter_cairo_create_region (texture,
                                          x_offset, y_offset,
                                          width, height);
        RETVAL = newSV (0);
        sv_setref_pv (RETVAL, "Clutter::Cairo::Context", (void *) cr);
    OUTPUT:
        RETVAL

void
clutter_cairo_surface_resize (texture, width, height)
        ClutterCairo *texture
        guint width
        guint height

void
clutter_cairo_set_source_color (cairo_t *cr, ClutterColor *color)
