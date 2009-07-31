#include "clutterperl.h"

void
cogl_perl_color_from_sv (SV *sv, CoglColor *color)
{
  AV *a;
  SV **s;
  guint8 red, green, blue, alpha;

  a = (AV *) SvRV (sv);

  if (av_len (a) != 4)
    croak ("A Clutter::Cogl color must be a reference to an "
           "array of 4 integers in the [0, 255] interval.");

  if ((s = av_fetch (a, 0, 0)) && gperl_sv_is_defined (*s))
    red = SvUV (*s);

  if ((s = av_fetch (a, 1, 0)) && gperl_sv_is_defined (*s))
    green = SvUV (*s);

  if ((s = av_fetch (a, 2, 0)) && gperl_sv_is_defined (*s))
    blue = SvUV (*s);

  if ((s = av_fetch (a, 3, 0)) && gperl_sv_is_defined (*s))
    alpha = SvUV (*s);

  cogl_color_set_from_4ub (color, red, green, blue, alpha);
}

SV *
cogl_perl_color_to_sv (const CoglColor *color)
{
  AV *av;

  if (color == NULL)
    return &PL_sv_undef;

  av = newAV ();
  av_store (av, 0, newSVuv (cogl_color_get_red_byte (color)));
  av_store (av, 1, newSVuv (cogl_color_get_green_byte (color)));
  av_store (av, 2, newSVuv (cogl_color_get_blue_byte (color)));
  av_store (av, 3, newSVuv (cogl_color_get_alpha_byte (color)));

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
