#include "clutterperl-private.h"

void
cogl_perl_texture_vertex_from_sv (SV *sv, CoglTextureVertex *vertex)
{
  SV **s;

  if (gperl_sv_is_hash_ref (sv))
    {
      HV *h = (HV *) SvRV (sv);

      if ((s = hv_fetch (h, "x", 1, 0)) && gperl_sv_is_defined (*s))
        vertex->x = SvNV (*s);

      if ((s = hv_fetch (h, "y", 1, 0)) && gperl_sv_is_defined (*s))
        vertex->y = SvNV (*s);

      if ((s = hv_fetch (h, "z", 1, 0)) && gperl_sv_is_defined (*s))
        vertex->z = SvNV (*s);

      if ((s = hv_fetch (h, "tx", 2, 0)) && gperl_sv_is_defined (*s))
        vertex->tx = SvNV (*s);

      if ((s = hv_fetch (h, "ty", 2, 0)) && gperl_sv_is_defined (*s))
        vertex->ty = SvNV (*s);

      if ((s = hv_fetch (h, "color", 5, 0)) && gperl_sv_is_array_ref (*s))
        cogl_perl_color_from_sv (*s, &vertex->color);
    }
  else if (gperl_sv_is_array_ref (sv))
    {
      AV *a = (AV *) SvRV (sv);

      if ((s = av_fetch (a, 0, 0)) && gperl_sv_is_defined (*s))
        vertex->x = SvNV (*s);

      if ((s = av_fetch (a, 1, 0)) && gperl_sv_is_defined (*s))
        vertex->y = SvNV (*s);

      if ((s = av_fetch (a, 2, 0)) && gperl_sv_is_defined (*s))
        vertex->z = SvNV (*s);

      if ((s = av_fetch (a, 3, 0)) && gperl_sv_is_defined (*s))
        vertex->tx = SvNV (*s);

      if ((s = av_fetch (a, 4, 0)) && gperl_sv_is_defined (*s))
        vertex->ty = SvNV (*s);

      if ((s = av_fetch (a, 5, 0)) && gperl_sv_is_array_ref (*s))
        cogl_perl_color_from_sv (*s, &vertex->color);
    }
  else
    croak ("A texture vertex must be a reference to a hash "
           "containing the keys 'x', 'y', 'z', 'tx', 'ty' "
           "and 'color', or a reference to an array containing "
           "the same information in the order: x, y, z, tx, ty, "
           "color");

#if NOISY
  g_debug ("vertex: { %.2f, %.2f, %.2f; %.2f, %.2f; { %.2f, %.2f, %.2f, %.2f } }",
           vertex->x, vertex->y, vertex->z,
           vertex->tx, vertex->ty,
           cogl_color_get_red_float (&vertex->color),
           cogl_color_get_green_float (&vertex->color),
           cogl_color_get_blue_float (&vertex->color),
           cogl_color_get_alpha_float (&vertex->color));
#endif /* NOISY */
}

SV *
cogl_perl_texture_vertex_to_sv (const CoglTextureVertex *vertex)
{
  HV *stash, *hv = newHV ();

  if (!vertex)
    return &PL_sv_undef;

  /* model coordinates; we store them into floats to avoid exposing
   * fixed point values in the bindings
   */
  hv_store (hv, "x", 1, newSVnv (vertex->x), 0);
  hv_store (hv, "y", 1, newSVnv (vertex->y), 0);
  hv_store (hv, "z", 1, newSVnv (vertex->z), 0);

  /* texture coordinates */
  hv_store (hv, "tx", 2, newSVnv (vertex->tx), 0);
  hv_store (hv, "ty", 2, newSVnv (vertex->ty), 0);

  /* color */
  hv_store (hv, "color", 5, cogl_perl_color_to_sv (&vertex->color), 0);

  stash = gv_stashpv ("Clutter::Cogl::TextureVertex", TRUE);

  return sv_bless ((SV *) newRV_noinc ((SV *) hv), stash);
}

SV *
newSVCoglTextureVertex (CoglTextureVertex *vertex)
{
  return cogl_perl_texture_vertex_to_sv (vertex);
}

CoglTextureVertex *
SvCoglTextureVertex (SV *sv)
{
  CoglTextureVertex *vertex;
  
  vertex = gperl_alloc_temp (sizeof (CoglTextureVertex));
  cogl_perl_texture_vertex_from_sv (sv, vertex);

  return vertex;
}

MODULE = Clutter::Cogl::Texture PACKAGE = Clutter::Cogl::Texture        PREFIX = cogl_texture_

BOOT:
        cogl_perl_set_isa ("Clutter::Cogl::Texture", "Clutter::Cogl::Handle");


=for position DESCRIPTION

=head1 DESCRIPTION

COGL allows creating and manipulating GL textures using a uniform
API that tries to hide all the various complexities of creating,
loading and manipulating textures.

=cut

=for enum Clutter::Cogl::PixelFormat
=cut

=for enum Clutter::Cogl::TextureFlags
=cut

CoglHandle
cogl_texture_new_with_size (class=NULL, width, height, flags=COGL_TEXTURE_NONE, internal_format=COGL_PIXEL_FORMAT_ANY)
        guint width
        guint height
        CoglTextureFlags flags
        CoglPixelFormat internal_format
    C_ARGS:
        width, height, flags, internal_format

CoglHandle
cogl_texture_new_from_data (class=NULL, width, height, flags=COGL_TEXTURE_NONE, format=COGL_PIXEL_FORMAT_ANY, internal_format=COGL_PIXEL_FORMAT_ANY, rowstride, data)
        guint width
        guint height
        CoglTextureFlags flags
        CoglPixelFormat format
        CoglPixelFormat internal_format
        guint rowstride
        SV *data
    CODE:
        if (!data || !SvPOK (data))
                croak ("expecting a packed string for pixel data");
        RETVAL = cogl_texture_new_from_data (width, height,
                                             flags,
                                             format, internal_format,
                                             rowstride,
                                             (const guchar *) SvPV_nolen (data));
    OUTPUT:
        RETVAL

=for apidoc __gerror__
=cut
CoglHandle
cogl_texture_new_from_file (class=NULL, filename, flags, internal_format)
        const gchar *filename
        CoglTextureFlags flags
        CoglPixelFormat internal_format
    PREINIT:
        GError *error = NULL;
    CODE:
        RETVAL = cogl_texture_new_from_file (filename,
                                             flags,
                                             internal_format,
                                             &error);
        if (error)
                gperl_croak_gerror (NULL, error);
    OUTPUT:
        RETVAL

CoglHandle
cogl_texture_new_from_foreign (class=NULL, gl_handle, gl_target, width, height, x_pot_waste, y_pot_waste, format=COGL_PIXEL_FORMAT_ANY)
        guint gl_handle
        gint gl_target
        guint width
        guint height
        guint x_pot_waste
        guint y_pot_waste
        CoglPixelFormat format
    C_ARGS:
        gl_handle, gl_target, width, height, x_pot_waste, y_pot_waste, format

guint cogl_texture_get_width (CoglHandle handle);

guint cogl_texture_get_height (CoglHandle handle);

CoglPixelFormat cogl_texture_get_format (CoglHandle handle);

guint cogl_texture_get_rowstride (CoglHandle handle);

gint cogl_texture_get_max_waste (CoglHandle handle);

gboolean cogl_texture_is_sliced (CoglHandle handle);

=for apidoc
=for signature (gl_handle, gl_target) = $handle->get_gl_texture
=cut
void
cogl_texture_get_gl_texture (CoglHandle handle)
    PREINIT:
        unsigned int out_gl_handle = 0;
        int out_gl_target = 0;
        gboolean res = FALSE;
    PPCODE:
        res = cogl_texture_get_gl_texture (handle,
                                           &out_gl_handle,
                                           &out_gl_target);
        if (res) {
                EXTEND (SP, 2);
                PUSHs (sv_2mortal (newSVuv (out_gl_handle)));
                PUSHs (sv_2mortal (newSViv (out_gl_target)));
        }

