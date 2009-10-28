#include "clutter-perl-private.h"

MODULE = Clutter::CairoTexture  PACKAGE = Clutter::Cairo        PREFIX = clutter_cairo_

void clutter_cairo_set_source_color (cairo_t *cr, ClutterColor *color);


MODULE = Clutter::CairoTexture  PACKAGE = Clutter::CairoTexture PREFIX = clutter_cairo_texture_

BOOT:
        gperl_set_isa ("Clutter::Cairo::Context", "Cairo::Context");

=for object Clutter::CairoTexture - Texture with Cairo integration
=cut

=for position DESCRIPTION

=head1 SYNOPSIS

    my $texture = Clutter::CairoTexture->new(64, 64);
    my $cr = $texture->create_context();

    # use Cairo API to draw on the Cairo::Context

    # destroys the Context and uploads the contents to the
    # CairoTexture; alternatively, you can let $cr go out
    # of scope
    $cr = undef;

=head1 DESCRIPTION

B<Clutter::CairoTexture> is a L<Clutter::Texture> that displays the contents
of a Cairo::Context. The Clutter::CairoTexture actor will create a
Cairo image surface which will then be uploaded to a GL texture when needed.

Clutter::CairoTexture will provide a Cairo::Context  by using the
Clutter::CairoTexture::create_context() and the
Clutter::CairoTexture::create_context_for_region() methods; you can use the
Cairo API to draw on the context and then destroy the context when done.

As soon as the context is destroyed, the contents of the surface will be
uploaded into the Clutter::CairoTexture actor.

Although a new Cairo::Context is created each time you call the
create_context() or the create_context_for_region() methods, the CairoTexture
will use the same image surface. You can call Clutter::CairoTexturr::clear()
to erase the contents between calls.

B<Warning>: Note that you should never use the code above inside the
Clutter::Actor::PAINT or Clutter::Actor::PICK virtual functions or
signal handlers because it will lead to performance degradation.

=cut

=for position SEE_ALSO

L<Clutter::Texture>, L<Cairo>

=cut

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
