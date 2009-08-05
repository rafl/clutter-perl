#include "clutterperl-private.h"

MODULE = Clutter::CairoTexture  PACKAGE = Clutter::Cairo        PREFIX = clutter_cairo_

void clutter_cairo_set_source_color (cairo_t *cr, ClutterColor *color);


MODULE = Clutter::CairoTexture  PACKAGE = Clutter::CairoTexture PREFIX = clutter_cairo_texture_

BOOT:
        gperl_set_isa ("Clutter::Cairo::Context", "Cairo::Context");

ClutterActor_noinc *clutter_cairo_texture_new (class, guint width, guint height);
    C_ARGS:
        width, height

SV *clutter_cairo_texture_create_context_for_region (texture, x_offset, y_offset, width, height)
        ClutterCairoTexture *texture
        gint x_offset
        gint y_offset
        gint width
        gint height
    PREINIT:
        cairo_t *cr;
    CODE:
        /* we own the cairo context */
        cr = clutter_cairo_texture_create_region (texture,
                                                  x_offset, y_offset,
                                                  width, height);
        RETVAL = newSV (0);
        sv_setref_pv (RETVAL, "Clutter::Cairo::Context", (void *) cr);
    OUTPUT:
        RETVAL

SV *clutter_cairo_texture_create_context (ClutterCairoTexture *texture);
    PREINIT:
        cairo_t *cr;
    CODE:
        /* we own the cairo context */
        cr = clutter_cairo_texture_create (texture);
        RETVAL = newSV (0);
        sv_setref_pv (RETVAL, "Clutter::Cairo::Context", (void *) cr);
    OUTPUT:
        RETVAL

void clutter_cairo_texture_set_surface_size (ClutterCairoTexture *texture, guint width, guint height);

=for apidoc
=for (width, height) = $texture->get_surface_size
=cut
void clutter_cairo_texture_get_surface_size (ClutterCairoTexture *texture);
    PREINIT:
        guint width, height;
    PPCODE:
        clutter_cairo_texture_get_surface_size (texture, &width, &height);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVuv (width)));
        PUSHs (sv_2mortal (newSVuv (height)));

void clutter_cairo_texture_clear (ClutterCairoTexture *texture);
