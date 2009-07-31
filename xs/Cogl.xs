/* Clutter.
 *
 * Perl bindings for the OpenGL based 'interactive canvas' library.
 *
 * Clutter Authored By Matthew Allum  <mallum@openedhand.com>
 * Perl bindings by Emmanuele Bassi  <ebassi@openedhand.com>
 * 
 * Copyright (C) 2006 OpenedHand
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#include "clutterperl.h"

SV *
newSVCoglHandle (CoglHandle handle)
{
  HV *stash, *hnd = newHV ();

  if (handle == COGL_INVALID_HANDLE)
    return &PL_sv_undef;

  sv_magic ((SV *) hnd, 0, PERL_MAGIC_ext, (const char *) handle, 0);

  stash = gv_stashpv ("Clutter::Cogl::Handle", TRUE);

  return sv_bless ((SV *) newRV_noinc ((SV *) hnd), stash);
}

CoglHandle
SvCoglHandle (SV *sv)
{
  MAGIC *mg;

  if (!gperl_sv_is_defined (sv) || !SvROK (sv) || !(mg = mg_find (SvRV (sv), PERL_MAGIC_ext)))
    return COGL_INVALID_HANDLE;

  return (CoglHandle) mg->mg_ptr;
}

void
coglperl_sv_to_color (SV *sv, CoglColor *color)
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
coglperl_color_to_sv (CoglColor *color)
{
  return &PL_sv_undef;
}

static void
read_texture_vertex (SV *sv, CoglTextureVertex *vertex)
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
        coglperl_sv_to_color (*s, &vertex->color);
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
        coglperl_sv_to_color (*s, &vertex->color);
    }
  else
    croak ("A texture vertex must be a reference to a hash "
           "containing the keys 'x', 'y', 'z', 'tx', 'ty' "
           "and 'color', or a reference to an array containing "
           "the same information in the order: x, y, z, tx, ty, "
           "color");
}

SV *
newSVCoglTextureVertex (CoglTextureVertex *vertex)
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
  hv_store (hv, "color", 5, coglperl_color_to_sv (&vertex->color), 0);

  stash = gv_stashpv ("Clutter::Cogl::TextureVertex", TRUE);

  return sv_bless ((SV *) newRV_noinc ((SV *) hv), stash);
}

CoglTextureVertex *
SvCoglTextureVertex (SV *sv)
{
  CoglTextureVertex *vertex;
  
  vertex = gperl_alloc_temp (sizeof (CoglTextureVertex));
  read_texture_vertex (sv, vertex);

  return vertex;
}

MODULE = Clutter::Cogl  PACKAGE = Clutter::Cogl::Handle

=for position DESCRIPTION

=head1 DESCRIPTION

B<Clutter::Cogl::Handle> is an opaque data type that is used to
store a handle to a GL or GLES resource. A handle can point to a
texture, or a shader program, or an offscreen buffer.

The nature and contents of the handle are completely shielded
from the Perl developer; a handle can only be used with the
Clutter::Cogl functions.

=cut

=for apidoc
Checks whether the passed I<handle> is valid or not
=cut
gboolean
is_valid (CoglHandle handle)
    CODE:
        RETVAL = (handle != COGL_INVALID_HANDLE) ? TRUE : FALSE;
    OUTPUT:
        RETVAL

=for apidoc
Whether the given I<handle> references an existing texture object
=cut
gboolean
is_texture (CoglHandle handle)
    CODE:
        RETVAL = cogl_is_texture (handle);
    OUTPUT:
        RETVAL

=for apidoc
Whether the given I<handle> references an existing shader object
=cut
gboolean
is_shader (CoglHandle handle)
    CODE:
        RETVAL = cogl_is_shader (handle);
    OUTPUT:
        RETVAL

=for apidoc
Whether the given I<handle> references an existing program object
=cut
gboolean
is_program (CoglHandle handle)
    CODE:
        RETVAL = cogl_is_program (handle);
    OUTPUT:
        RETVAL

=for apidoc
Whether the given I<handle> references an existing offscreen
buffer object
=cut
gboolean
is_offscreen (CoglHandle handle)
    CODE:
        RETVAL = cogl_is_offscreen (handle);
    OUTPUT:
        RETVAL

void
DESTROY (SV *sv)
    PREINIT:
        CoglHandle handle = COGL_INVALID_HANDLE;
    CODE:
        handle = SvCoglHandle (sv);
        if (handle != COGL_INVALID_HANDLE)
          cogl_handle_unref (handle);
        sv_unmagic (sv, PERL_MAGIC_ext);

MODULE = Clutter::Cogl  PACKAGE = Clutter::Cogl::Texture PREFIX = cogl_texture_

BOOT:
        gperl_set_isa ("Clutter::Cogl::TextureHandle",
                       "Clutter::Cogl::Handle");

SV *
cogl_texture_new_with_size (class=NULL, width, height, flags, internal_format)
        guint width
        guint height
        CoglTextureFlags flags
        CoglPixelFormat internal_format
    PREINIT:
        CoglHandle handle = COGL_INVALID_HANDLE;
    CODE:
        /* we own the handle */
        handle = cogl_texture_new_with_size (width, height,
                                             flags,
                                             internal_format);
        RETVAL = newSVCoglHandle (handle);
        sv_setref_pv (RETVAL, "Clutter::Cogl::TextureHandle", (void *) handle);
    OUTPUT:
        RETVAL

MODULE = Clutter::Cogl  PACKAGE = Clutter::Cogl PREFIX = cogl_

=for position DESCRIPTION

B<Clutter::Cogl> is an abstraction API over GL and GLES, and it is
used internally by Clutter to allow portability between platforms.

The Clutter::Cogl API is low-level and it is meant to be used
only when creating new L<Clutter::Actor> classes.

Clutter::Cogl tries to provide an API that is nicer and more
understandable than the raw OpenGL API (as exposed, for instance,
by the Perl OpenGL wrapper module).

=cut

=for apidoc
Retrieves all the features supported by Cogl on the current
platform
=cut
CoglFeatureFlags
cogl_get_features (class=NULL)
    C_ARGS:
        /* void */

=for apidoc
Checks whether the given I<features> are available.
=cut
gboolean
cogl_features_available (class=NULL, CoglFeatureFlags features)
    C_ARGS:
        features

=for
Checks whether I<name> occurs in the list of extensions inside I<ext>
=cut
gboolean
cogl_check_extension (class=NULL, const gchar *name, const gchar *ext)
    C_ARGS:
        name, ext

=for apidoc
Replaces the current projection matrix with a perspective matrix
based on the provided values
=cut
void
cogl_perspective (class=NULL, float fovy, float aspect, float z_near, float z_far)
    C_ARGS:
        fovy, aspect, z_near, z_far

=for apidoc
Replaces the current projection matrix with a perspective matrix
for the given viewing frustum
=cut
void
cogl_frustum (class=NULL, left, right, bottom, top, z_near, z_far)
        float left
        float right
        float bottom
        float top
        float z_near
        float z_far
    C_ARGS:
        left, right, bottom, top, z_near, z_far

=for apidoc
Replaces the current projection matrix with a parallel projection
matrix
=cut
void
cogl_ortho (class=NULL, left, right, bottom, top, z_near, z_far)
        float left
        float right
        float bottom
        float top
        float z_near
        float z_far
    C_ARGS:
        left, right, bottom, top, z_near, z_far

=for apidoc
Replace the current viewport with the given values.
=cut
void
cogl_viewport (class=NULL, guint width, guint height)
    C_ARGS:
        width, height

=for apidoc
Stores the current model-view matrix on the matrix stack. The matrix
can later be restored with Clutter::Cogl-E<gt>pop_matrix()
=cut
void
cogl_push_matrix (class=NULL)
    C_ARGS:
        /* void */

=for apidoc
Restore the current model-view matrix from the matrix stack
=cut
void
cogl_pop_matrix (class=NULL)
    C_ARGS:
        /* void */

=for apidoc
Multiplies the current model-view matrix by one that scales the I<x>,
I<y> and I<z> axes by the given values
=cut
void
cogl_scale (class=NULL, float x, float y, float z)
    C_ARGS:
        x, y, z

=for apidoc
Multiplies the current model-view matrix by one that translates the
model along all three axes according to the given values
=cut
void
cogl_translate (class=NULL, float x, float y, float z)
    C_ARGS:
        x, y, z

=for apidoc
Multiplies the current model-view matrix by one that rotates the
model around the vertex specified by I<x>, I<y> and I<z>. The rotation
follows the right-hand thumb rule so for example rotating by 10
degrees about the vertex (0, 0, 1) causes a small counter-clockwise
rotation
=cut
void
cogl_rotate (class=NULL, float angle, float x, float y, float z)
    C_ARGS:
        angle, x, y, z

=for apidoc
=for signature (x, y, width, height) = Clutter::Cogl->get_viewport
=cut
void
cogl_get_viewport (class=NULL)
    PREINIT:
        float v[4];
    PPCODE:
        cogl_get_viewport (v);
        EXTEND (SP, 4);
        PUSHs (sv_2mortal (newSVnv (v[0]))); /* x */
        PUSHs (sv_2mortal (newSVnv (v[1]))); /* y */
        PUSHs (sv_2mortal (newSVnv (v[2]))); /* width */
        PUSHs (sv_2mortal (newSVnv (v[3]))); /* height */

=for apidoc
Fills a rectangle at the given coordinates with the current
drawing color in a highly optimizied fashion
=cut
void
cogl_rectangle (class=NULL, float x1, float y1, float x2, float y2)
    C_ARGS:
        x1, y1, x2, y2

##=for apidoc
##=cut
##void
##cogl_texture_polygon (class=NULL, CoglHandle handle, SV *vertices, gboolean use_color)
##    PREINIT:
##        AV *av;
##        CoglTextureVertex *v;
##        gint n_vertices, i;
##    CODE:
##        if (!gperl_sv_is_array_ref (vertices))
##          croak ("vertices must be a reference to an array of texture vertices");
##        av = (AV *) SvRV (vertices);
##        n_vertices = av_len (av);
##        if (n_vertices < 1)
##          croak ("vertices array is empty");
##        v = gperl_alloc_temp (sizeof (CoglTextureVertex) * n_vertices);
##        for (i = 0; i < n_vertices; i++) {
##          SV **svp = av_fetch (av, i, 0);
##          read_texture_vertex (*svp, v + i);
##        }
##        cogl_texture_polygon (handle, n_vertices, v, use_color);

