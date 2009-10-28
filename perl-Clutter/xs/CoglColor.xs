#include "clutter-perl-private.h"

void
cogl_perl_color_from_sv (SV *sv, CoglColor *color)
{
        AV *a;
        SV **s;
        gfloat red_f, green_f, blue_f, alpha_f;
        guint8 red_b, green_b, blue_b, alpha_b;
        gboolean use_bytes = FALSE;

        a = (AV *) SvRV (sv);

        if ((s = av_fetch (a, 0, 0)) && gperl_sv_is_defined (*s)) {
                /* the first element tells us the format */
                if (!looks_like_number (*s))
                        croak ("A Clutter::Cogl color must be a reference "
                               "to an array of 4 numbers");

                if (SvIOK (*s)) {
                        use_bytes = TRUE;
                }
                else if (SvNOK (*s)) {
                        use_bytes = FALSE;
                }
                else {
                        croak ("A Clutter::Cogl color must be a reference "
                               "to an array of either 4 integers in the "
                               "[0, 255] range or 4 floating point values "
                               "in the [0, 1] range");
                }

                if (use_bytes)
                        red_b = CLAMP (SvUV (*s), 0, 255);
                else
                        red_f = CLAMP (SvNV (*s), 0.0, 1.0);
        }

        if ((s = av_fetch (a, 1, 0)) && gperl_sv_is_defined (*s)) {
                if (!looks_like_number (*s))
                        croak ("A Clutter::Cogl color must be a reference "
                               "to an array of 4 numbers");

                if (use_bytes)
                        green_b = CLAMP (SvUV (*s), 0, 255);
                else
                        green_f = CLAMP (SvNV (*s), 0.0, 1.0);
        }

        if ((s = av_fetch (a, 2, 0)) && gperl_sv_is_defined (*s)) {
                if (use_bytes)
                        blue_b = CLAMP (SvUV (*s), 0, 255);
                else
                        blue_f = CLAMP (SvNV (*s), 0.0, 1.0);
        }

        if ((s = av_fetch (a, 3, 0)) && gperl_sv_is_defined (*s)) {
                if (use_bytes)
                        alpha_b = CLAMP (SvUV (*s), 0, 255);
                else
                        alpha_f = CLAMP (SvNV (*s), 0.0, 1.0);
        }

        if (use_bytes) {
                cogl_color_set_from_4ub (color,
                                         red_b,
                                         green_b,
                                         blue_b,
                                         alpha_b);
        }
        else {
                cogl_color_set_from_4f (color,
                                        red_f,
                                        green_f,
                                        blue_f,
                                        alpha_f);
        }
}

SV *
cogl_perl_color_to_sv (const CoglColor *color)
{
        AV *av;

        if (color == NULL)
                return &PL_sv_undef;

        av = newAV ();

        /* for the perl side we use the [0, 1] interval */
        av_store (av, 0, newSVnv (cogl_color_get_red_float (color)));
        av_store (av, 1, newSVnv (cogl_color_get_green_float (color)));
        av_store (av, 2, newSVnv (cogl_color_get_blue_float (color)));
        av_store (av, 3, newSVnv (cogl_color_get_alpha_float (color)));

        return newRV_noinc ((SV *) av);
}

SV *
newSVCoglColor (CoglColor *color)
{
  return cogl_perl_color_to_sv (color);
}

CoglColor *
SvCoglColor (SV *sv)
{
  CoglColor *color;

  color = gperl_alloc_temp (sizeof (CoglColor));
  cogl_perl_color_from_sv (sv, color);

  return color;
}

MODULE = Clutter::Cogl::Color   PACKAGE = Clutter::Cogl::Color

=for object Clutter::Cogl::Color - COGL Color representation
=cut

=for position DESCRIPTION

=head1 DESCRIPTION

Colors in COGL are described as arrays of four values, one for each
channel of the RGBA representation.

The values can either be expressed as a byte value, going from 0 to
255, or as normalized floating point values, between 0 and 1.

=cut

=for apidoc
=for signature (red, green, blue, alpha) = Clutter::Cogl::Color->premultiply ($color)
=for arg color (CoglColor)
Converts a non-premultiplied color to a pre-multiplied color. For
example, semi-transparent red is (1.0, 0, 0, 0.5) when non-premultiplied
and (0.5, 0, 0, 0.5) when premultiplied.
=cut
SV *
premultiply (class, SV *color)
    PREINIT:
        CoglColor c;
    CODE:
        cogl_perl_color_from_sv (color, &c);
        cogl_color_premultiply (&c);
        RETVAL = cogl_perl_color_to_sv (&c);
    OUTPUT:
        RETVAL
