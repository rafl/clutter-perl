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

#ifndef COGL_TYPE_PIXEL_FORMAT
#define COGL_TYPE_PIXEL_FORMAT  (coglperl_pixel_format_get_type ())

static GType
coglperl_pixel_format_get_type (void)
{
  static GType gtype = 0;

  if (G_UNLIKELY (gtype == 0))
    {
      const GEnumValue values[] = {
        { COGL_PIXEL_FORMAT_ANY, "COGL_PIXEL_FORMAT_ANY", "any" },
        { COGL_PIXEL_FORMAT_A_8, "COGL_PIXEL_FORMAT_A_8", "a-8" },
        { COGL_PIXEL_FORMAT_RGB_565, "COGL_PIXEL_FORMAT_RGB_565", "rgb-565" },
        { COGL_PIXEL_FORMAT_RGBA_4444, "COGL_PIXEL_FORMAT_RGBA_4444", "rgba-4444" },
        { COGL_PIXEL_FORMAT_RGBA_5551, "COGL_PIXEL_FORMAT_RGBA_5551", "rgba-5551" },
        { COGL_PIXEL_FORMAT_YUV, "COGL_PIXEL_FORMAT_YUV", "yuv" },
        { COGL_PIXEL_FORMAT_G_8, "COGL_PIXEL_FORMAT_G_8", "g-8" },
        { COGL_PIXEL_FORMAT_RGB_888, "COGL_PIXEL_FORMAT_RGB_888", "rgb-888" },
        { COGL_PIXEL_FORMAT_BGR_888, "COGL_PIXEL_FORMAT_BGR_888", "bgr-888" },
        { COGL_PIXEL_FORMAT_RGBA_8888, "COGL_PIXEL_FORMAT_RGBA_8888", "rgba-8888" },
        { COGL_PIXEL_FORMAT_BGRA_8888, "COGL_PIXEL_FORMAT_BGRA_8888", "bgra-8888" },
        { COGL_PIXEL_FORMAT_ARGB_8888, "COGL_PIXEL_FORMAT_ARGB_8888", "argb-8888" },
        { COGL_PIXEL_FORMAT_ABGR_8888, "COGL_PIXEL_FORMAT_ABGR_8888", "abgr-8888" },
        { COGL_PIXEL_FORMAT_RGBA_8888_PRE, "COGL_PIXEL_FORMAT_RGBA_8888_PRE", "rgba-8888-pre" },
        { COGL_PIXEL_FORMAT_BGRA_8888_PRE, "COGL_PIXEL_FORMAT_BGRA_8888_PRE", "bgra-8888-pre" },
        { COGL_PIXEL_FORMAT_ARGB_8888_PRE, "COGL_PIXEL_FORMAT_ARGB_8888_PRE", "argb-8888-pre" },
        { COGL_PIXEL_FORMAT_ABGR_8888_PRE, "COGL_PIXEL_FORMAT_ABGR_8888_PRE", "abgr-8888-pre" },
        { COGL_PIXEL_FORMAT_RGBA_4444_PRE, "COGL_PIXEL_FORMAT_RGBA_4444_PRE", "rgba-4444-pre" },
        { COGL_PIXEL_FORMAT_RGBA_5551_PRE, "COGL_PIXEL_FORMAT_RGBA_5551_PRE", "rgba-5551-pre" },
        { 0, NULL, NULL }
      };

      gtype = g_enum_register_static (g_intern_static_string ("CoglPixelFormat"),
                                      values);
    }

  return gtype;
}

#endif /* COGL_TYPE_PIXEL_FORMAT */

SV *
newSVCoglPixelFormat (CoglPixelFormat format)
{
  return gperl_convert_back_enum (COGL_TYPE_PIXEL_FORMAT, format);
}

CoglPixelFormat
SvCoglPixelFormat (SV *sv)
{
  return gperl_convert_enum (COGL_TYPE_PIXEL_FORMAT, sv);
}

#ifndef COGL_TYPE_FEATURE_FLAGS
#define COGL_TYPE_FEATURE_FLAGS (coglperl_feature_flags_get_type ())

static GType
coglperl_feature_flags_get_type (void)
{
  static GType gtype = 0;

  if (G_UNLIKELY (gtype == 0))
    {
      const GFlagsValue values[] = {
        { COGL_FEATURE_TEXTURE_RECTANGLE, "COGL_FEATURE_TEXTURE_RECTANGLE", "texture-rectangle" },
        { COGL_FEATURE_TEXTURE_NPOT, "COGL_FEATURE_TEXTURE_NPOT", "texture-npot" },
        { COGL_FEATURE_TEXTURE_YUV, "COGL_FEATURE_TEXTURE_YUV", "yuv" },
        { COGL_FEATURE_TEXTURE_READ_PIXELS, "COGL_FEATURE_TEXTURE_READ_PIXELS", "read-pixels" },
        { COGL_FEATURE_SHADERS_GLSL, "COGL_FEATURE_SHADERS_GLSL", "shaders-glsl" },
        { COGL_FEATURE_OFFSCREEN, "COGL_FEATURE_OFFSCREEN", "offscreen" },
        { COGL_FEATURE_OFFSCREEN_MULTISAMPLE, "COGL_FEATURE_OFFSCREEN_MULTISAMPLE", "offscreen-multisample" },
        { COGL_FEATURE_OFFSCREEN_BLIT, "COGL_FEATURE_OFFSCREEN_BLIT", "offscreen-blit" },
        { COGL_FEATURE_FOUR_CLIP_PLANES, "COGL_FEATURE_FOUR_CLIP_PLANES", "four-clip-planes" },
        { COGL_FEATURE_STENCIL_BUFFER, "COGL_FEATURE_STENCIL_BUFFER", "stencil-buffer" },
        { 0, NULL, NULL }
      };

      gtype = g_flags_register_static (g_intern_static_string ("CoglFeatureFlags"), values);
    }

  return gtype;
}

#endif /* COGL_TYPE_FEATURE_FLAGS */

SV *
newSVCoglFeatureFlags (CoglFeatureFlags flags)
{
  return gperl_convert_back_flags (COGL_TYPE_FEATURE_FLAGS, flags);
}

CoglFeatureFlags
SvCoglFeatureFlags (SV *sv)
{
  return gperl_convert_flags (COGL_TYPE_FEATURE_FLAGS, sv);
}

#ifndef COGL_TYPE_BUFFER_TARGET
#define COGL_TYPE_BUFFER_TARGET (coglperl_buffer_target_get_type ())

static GType
coglperl_buffer_target_get_type (void)
{
  static GType gtype = 0;

  if (G_UNLIKELY (gtype == 0))
    {
      const GFlagsValue values[] = {
        { COGL_WINDOW_BUFFER, "COGL_WINDOW_BUFFER", "window-buffer" },
        { COGL_MASK_BUFFER, "COGL_MASK_BUFFER", "mask-buffer" },
        { COGL_OFFSCREEN_BUFFER, "COGL_OFFSCREEN_BUFFER", "offscreen-buffer" },
        { 0, NULL, NULL }
      };

      gtype = g_flags_register_static (g_intern_static_string ("CoglBufferTarget"), values);
    }

  return gtype;
}

#endif /* COGL_TYPE_BUFFER_TARGET */

SV *
newSVCoglBufferTarget (CoglBufferTarget flags)
{
  return gperl_convert_back_flags (COGL_TYPE_BUFFER_TARGET, flags);
}

CoglBufferTarget
SvCoglBufferTarget (SV *sv)
{
  return gperl_convert_flags (COGL_TYPE_BUFFER_TARGET, sv);
}


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

static void
read_texture_vertex (SV *sv, CoglTextureVertex *vertex)
{
  SV **s;

  if (gperl_sv_is_hash_ref (sv))
    {
      HV *h = (HV *) SvRV (sv);

      if ((s = hv_fetch (h, "x", 1, 0)) && gperl_sv_is_defined (*s))
        vertex->x = CLUTTER_FLOAT_TO_FIXED (SvNV (*s));

      if ((s = hv_fetch (h, "y", 1, 0)) && gperl_sv_is_defined (*s))
        vertex->y = CLUTTER_FLOAT_TO_FIXED (SvNV (*s));

      if ((s = hv_fetch (h, "z", 1, 0)) && gperl_sv_is_defined (*s))
        vertex->z = CLUTTER_FLOAT_TO_FIXED (SvNV (*s));

      if ((s = hv_fetch (h, "tx", 2, 0)) && gperl_sv_is_defined (*s))
        vertex->tx = CLUTTER_FLOAT_TO_FIXED (SvNV (*s));

      if ((s = hv_fetch (h, "ty", 2, 0)) && gperl_sv_is_defined (*s))
        vertex->ty = CLUTTER_FLOAT_TO_FIXED (SvNV (*s));

      if ((s = hv_fetch (h, "color", 5, 0)) && gperl_sv_is_defined (*s))
        {
          ClutterColor *color = SvClutterColor (*s);

          vertex->color = *color;
        }
    }
  else if (gperl_sv_is_array_ref (sv))
    {
      AV *a = (AV *) SvRV (sv);

      if ((s = av_fetch (a, 0, 0)) && gperl_sv_is_defined (*s))
        vertex->x = CLUTTER_FLOAT_TO_FIXED (SvNV (*s));

      if ((s = av_fetch (a, 1, 0)) && gperl_sv_is_defined (*s))
        vertex->y = CLUTTER_FLOAT_TO_FIXED (SvNV (*s));

      if ((s = av_fetch (a, 2, 0)) && gperl_sv_is_defined (*s))
        vertex->z = CLUTTER_FLOAT_TO_FIXED (SvNV (*s));

      if ((s = av_fetch (a, 3, 0)) && gperl_sv_is_defined (*s))
        vertex->tx = CLUTTER_FLOAT_TO_FIXED (SvNV (*s));

      if ((s = av_fetch (a, 4, 0)) && gperl_sv_is_defined (*s))
        vertex->ty = CLUTTER_FLOAT_TO_FIXED (SvNV (*s));

      if ((s = av_fetch (a, 5, 0)) && gperl_sv_is_defined (*s))
        {
          ClutterColor *color = SvClutterColor (*s);

          vertex->color = *color;
        }
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
  hv_store (hv, "x", 1, newSVnv (CLUTTER_FIXED_TO_FLOAT (vertex->x)), 0);
  hv_store (hv, "y", 1, newSVnv (CLUTTER_FIXED_TO_FLOAT (vertex->y)), 0);
  hv_store (hv, "z", 1, newSVnv (CLUTTER_FIXED_TO_FLOAT (vertex->z)), 0);

  /* texture coordinates */
  hv_store (hv, "tx", 2, newSVnv (CLUTTER_FIXED_TO_FLOAT (vertex->tx)), 0);
  hv_store (hv, "ty", 2, newSVnv (CLUTTER_FIXED_TO_FLOAT (vertex->ty)), 0);

  /* color */
  hv_store (hv, "color", 5, newSVClutterColor (&vertex->color), 0);

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
        if (handle == COGL_INVALID_HANDLE)
          return;
        if (cogl_is_texture (handle))
          cogl_texture_unref (handle);
        else if (cogl_is_shader (handle))
          cogl_shader_unref (handle);
        else if (cogl_is_program (handle))
          cogl_program_unref (handle);
        else if (cogl_is_offscreen (handle))
          cogl_offscreen_unref (handle);
        else
          g_return_if_reached ();
        sv_unmagic (sv, PERL_MAGIC_ext);

MODULE = Clutter::Cogl  PACKAGE = Clutter::Cogl::Texture PREFIX = cogl_texture_

BOOT:
        gperl_set_isa ("Clutter::Cogl::TextureHandle",
                       "Clutter::Cogl::Handle");

SV *
cogl_texture_new_with_size (class=NULL, width, height, max_waste, auto_mipmap, internal_format)
        guint width
        guint height
        gint max_waste
        gboolean auto_mipmap
        CoglPixelFormat internal_format
    PREINIT:
        CoglHandle handle = COGL_INVALID_HANDLE;
    CODE:
        /* we own the handle */
        handle = cogl_texture_new_with_size (width, height,
                                             max_waste,
                                             auto_mipmap,
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
Multiplies the current set matrix with a projection matrix based
on the provided values
=cut
void
cogl_perspective (class=NULL, gdouble fovy, gdouble aspect, gdouble z_near, gdouble z_far)
    CODE:
        cogl_perspective (CLUTTER_FLOAT_TO_FIXED (fovy),
                          CLUTTER_FLOAT_TO_FIXED (aspect),
                          CLUTTER_FLOAT_TO_FIXED (z_near),
                          CLUTTER_FLOAT_TO_FIXED (z_far));

#if CLUTTER_CHECK_VERSION (0, 8, 2)

=for apidoc
Replaces the current projection matrix with a perspective
matrix for the given viewing frustum
=cut
void
cogl_frustum (class=NULL, left, right, bottom, top, z_near, z_far)
        gdouble left
        gdouble right
        gdouble bottom
        gdouble top
        gdouble z_near
        gdouble z_far
    CODE:
        cogl_frustum (CLUTTER_FLOAT_TO_FIXED (left),
                      CLUTTER_FLOAT_TO_FIXED (right),
                      CLUTTER_FLOAT_TO_FIXED (bottom)
                      CLUTTER_FLOAT_TO_FIXED (top)
                      CLUTTER_FLOAT_TO_FIXED (z_near)
                      CLUTTER_FLOAT_TO_FIXED (z_far));

#endif /* CLUTTER_CHECK_VERSION */

=for apidoc
Replaces the current viewport and projection matrix with the given
values. The viewport is placed at the top left corner of the window
with the given I<width> and I<height>. The projection matrix is replaced
with one that has a viewing angle of I<fovy> along the y-axis and a
view scaled according to I<aspect> along the x-axis. The view is
clipped according to I<z_near> and I<z_far> on the z-axis
=cut
void
cogl_setup_viewport (class=NULL, width, height, fovy, aspect, z_near, z_far)
        guint width
        guint height
        gdouble fovy
        gdouble aspect
        gdouble z_near
        gdouble z_far
    CODE:
        cogl_setup_viewport (width, height,
                             CLUTTER_FLOAT_TO_FIXED (fovy),
                             CLUTTER_FLOAT_TO_FIXED (aspect),
                             CLUTTER_FLOAT_TO_FIXED (z_near),
                             CLUTTER_FLOAT_TO_FIXED (z_far));

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
Multiplies the current model-view matrix by one that scales the I<x>
and I<y> axes by the given values
=cut
void
cogl_scale (class=NULL, gdouble x, gdouble y)
    CODE:
        cogl_scale (CLUTTER_FLOAT_TO_FIXED (x),
                    CLUTTER_FLOAT_TO_FIXED (y));

=for apidoc
Multiplies the current model-view matrix by one that translates the
model along all three axes according to the given values
=cut
void
cogl_translate (class=NULL, gdouble x, gdouble y, gdouble z)
    CODE:
        cogl_translatex (CLUTTER_FLOAT_TO_FIXED (x),
                         CLUTTER_FLOAT_TO_FIXED (y),
                         CLUTTER_FLOAT_TO_FIXED (z));

=for apidoc
Multiplies the current model-view matrix by one that rotates the
model around the vertex specified by I<x>, I<y> and I<z>. The rotation
follows the right-hand thumb rule so for example rotating by 10
degrees about the vertex (0, 0, 1) causes a small counter-clockwise
rotation
=cut
void
cogl_rotate (class=NULL, gdouble angle, gint x, gint y, gint z)
    CODE:
        cogl_rotatex (CLUTTER_FLOAT_TO_FIXED (angle), x, y, z);

=for apidoc
=for signature (x, y, width, height) = Clutter::Cogl->get_viewport
=cut
void
cogl_get_viewport (class=NULL)
    PREINIT:
        ClutterFixed v[4];
    PPCODE:
        cogl_get_viewport (v);
        EXTEND (SP, 4);
        PUSHs (sv_2mortal (newSVnv (CLUTTER_FIXED_TO_FLOAT (v[0])))); /* x */
        PUSHs (sv_2mortal (newSVnv (CLUTTER_FIXED_TO_FLOAT (v[1])))); /* y */
        PUSHs (sv_2mortal (newSVnv (CLUTTER_FIXED_TO_FLOAT (v[2])))); /* width */
        PUSHs (sv_2mortal (newSVnv (CLUTTER_FIXED_TO_FLOAT (v[3])))); /* height */

=for apidoc
Specifies a rectangular clipping area for all subsequent drawing
operations. Any drawing commands that extend outside the rectangle
will be clipped so that only the portion inside the rectangle will
be displayed. The rectangle dimensions are transformed by the
current model-view matrix
=cut
void
cogl_clip_set (class=NULL, x_offset, y_offset, width, height)
        gdouble x_offset
        gdouble y_offset
        gdouble width
        gdouble height
    CODE:
        cogl_clip_set (CLUTTER_FLOAT_TO_FIXED (x_offset),
                       CLUTTER_FLOAT_TO_FIXED (y_offset),
                       CLUTTER_FLOAT_TO_FIXED (width),
                       CLUTTER_FLOAT_TO_FIXED (height));

=for apidoc
Removes the current clipping rectangle so that all drawing
operations extend to full size of the viewport again
=cut
void
cogl_clip_unset (class=NULL)
    C_ARGS:
        /* void */

=for apidoc
Sets whether depth testing is enabled. If it is disabled then the
order that actors are layered on the screen depends solely on the
order specified using Clutter::Actor::raise() and Clutter::Actor::lower(),
otherwise it will also take into account the actor's depth. Depth
testing is disabled by default
=cut
void
cogl_enable_depth_test (class=NULL, gboolean enable_test)
    C_ARGS:
        enable_test

=for apidoc
Changes the color of the pen used for filling and stroking primitives
=cut
void
cogl_color (class=NULL, const ClutterColor *color)
    C_ARGS:
        color

=for apidoc
Fills a rectangle at the given coordinates with the current
drawing color in a highly optimizied fashion
=cut
void
cogl_rectangle (class=NULL, gint x, gint y, gint width, gint height)
    C_ARGS:
        x, y, width, height

=for apidoc
Fills the constructed shape using the current drawing color
=cut
void
cogl_path_fill (class=NULL)
    C_ARGS:
        /* void */

=for apidoc
Strokes the constructed shape using the current drawing color
and a width of 1 pixel (regardless of the current transformation
matrix)
=cut
void
cogl_path_stroke (class=NULL)
    C_ARGS:
        /* void */

=for apidoc
Clears the previously constructed shape and begins a new path
contour by moving the pen to the given coordinates
=cut
void
cogl_path_move_to (class=NULL, gdouble x, gdouble y)
    CODE:
        cogl_path_move_to (CLUTTER_FLOAT_TO_FIXED (x),
                           CLUTTER_FLOAT_TO_FIXED (y));

=for apidoc
Clears the previously constructed shape and begins a new path
contour by moving the pen to the given coordinates relative
to the current pen location
=cut
void
cogl_path_rel_move_to (class=NULL, gdouble x, gdouble y)
    CODE:
        cogl_path_rel_move_to (CLUTTER_FLOAT_TO_FIXED (x),
                               CLUTTER_FLOAT_TO_FIXED (y));

=for apidoc
Adds a straight line segment to the current path that ends at the
given coordinates
=cut
void
cogl_path_line_to (class=NULL, gdouble x, gdouble y)
    CODE:
        cogl_path_line_to (CLUTTER_FLOAT_TO_FIXED (x),
                           CLUTTER_FLOAT_TO_FIXED (y));

=for apidoc
Adds a straight line segment to the current path that ends at the
given coordinates relative to the current pen location
=cut
void
cogl_path_rel_line_to (class=NULL, gdouble x, gdouble y)
    CODE:
        cogl_path_rel_line_to (CLUTTER_FLOAT_TO_FIXED (x),
                               CLUTTER_FLOAT_TO_FIXED (y));

=for apidoc
Adds an elliptical arc segment to the current path. A straight line
segment will link the current pen location with the first vertex
of the arc. If you perform a I<move_to> to the arc start just before
drawing it you create a free standing arc.
=cut
void
cogl_path_arc (class=NULL, center_x, center_y, radius_x, radius_y, angle_start, angle_end)
        gdouble center_x
        gdouble center_y
        gdouble radius_x
        gdouble radius_y
        gdouble angle_start
        gdouble angle_end
    CODE:
        cogl_path_arc (CLUTTER_FLOAT_TO_FIXED (center_x),
                       CLUTTER_FLOAT_TO_FIXED (center_y),
                       CLUTTER_FLOAT_TO_FIXED (radius_x),
                       CLUTTER_FLOAT_TO_FIXED (radius_y),
                       CLUTTER_ANGLE_FROM_DEG (angle_start),
                       CLUTTER_ANGLE_FROM_DEG (angle_end));

=for apidoc
Adds a cubic bezier curve segment to the current path with the given
second, third and fourth control points and using current pen location
as the first control point.
=cut
void
cogl_path_curve_to (class=NULL, x1, y1, x2, y2, x3, y3)
        gdouble x1
        gdouble y1
        gdouble x2
        gdouble y2
        gdouble x3
        gdouble y3
    CODE:
        cogl_path_curve_to (CLUTTER_FLOAT_TO_FIXED (x1),
                            CLUTTER_FLOAT_TO_FIXED (y1),
                            CLUTTER_FLOAT_TO_FIXED (x2),
                            CLUTTER_FLOAT_TO_FIXED (y2),
                            CLUTTER_FLOAT_TO_FIXED (x3),
                            CLUTTER_FLOAT_TO_FIXED (y3));

=for apidoc
Adds a cubic bezier curve segment to the current path with the given
second, third and fourth control points and using current pen location
as the first control point. The given coordinates are relative to the
current pen location
=cut
void
cogl_path_rel_curve_to (class=NULL, x1, y1, x2, y2, x3, y3)
        gdouble x1
        gdouble y1
        gdouble x2
        gdouble y2
        gdouble x3
        gdouble y3
    CODE:
        cogl_path_rel_curve_to (CLUTTER_FLOAT_TO_FIXED (x1),
                                CLUTTER_FLOAT_TO_FIXED (y1),
                                CLUTTER_FLOAT_TO_FIXED (x2),
                                CLUTTER_FLOAT_TO_FIXED (y2),
                                CLUTTER_FLOAT_TO_FIXED (x3),
                                CLUTTER_FLOAT_TO_FIXED (y3));

=for apidoc
Closes the path being constructed by adding a straight line segment
to it that ends at the first vertex of the path
=cut
void
cogl_path_close (class=NULL)
    C_ARGS:
        /* void */

=for apidoc
Clears the previously constructed shape and constructs a straight
line shape start and ending at the given coordinates
=cut
void
cogl_path_line (class=NULL, gdouble x1, gdouble y1, gdouble x2, gdouble y2)
    CODE:
        cogl_path_line (CLUTTER_FLOAT_TO_FIXED (x1),
                        CLUTTER_FLOAT_TO_FIXED (y1),
                        CLUTTER_FLOAT_TO_FIXED (x2),
                        CLUTTER_FLOAT_TO_FIXED (y2));

##=for apidoc
##Clears the previously constructed shape and constructs a series of straight
##line segments, starting from the first given vertex coordinate. Each
##subsequent segment stars where the previous one ended and ends at the next
##given vertex coordinate.
##
##I<coords> is a reference to an array containing the X and Y coordinates of
##each vertex.
##
##C<scalar @coords - 1> lines will be constructed.
##=cut
##void
##cogl_path_polyline (class=NULL, SV *coords)

##=for apidoc
##Clears the previously constructed shape and constructs a polygonal
##shape of the given number of vertices.
##
##I<coords> is a reference to an array containing the X and Y coordinates of
##each vertex.
##
##C<scalar @coords> lines will be constructed.
##=cut
##void
##cogl_path_polygon (class=NULL, SV *coords)

=for apidoc
Clears the previously constructed shape and constructs a rectangular
shape at the given coordinates
=cut
void
cogl_path_rectangle (class=NULL, gdouble x, gdouble y, gdouble width, gdouble height)
    CODE:
        cogl_path_rectangle (CLUTTER_FLOAT_TO_FIXED (x),
                             CLUTTER_FLOAT_TO_FIXED (y),
                             CLUTTER_FLOAT_TO_FIXED (width),
                             CLUTTER_FLOAT_TO_FIXED (height));

=for apidoc
Clears the previously constructed shape and constructs an ellipse shape
=cut
void
cogl_path_ellipse (class=NULL, gdouble center_x, gdouble center_y, gdouble radius_x, gdouble radius_y)
    CODE:
        cogl_path_ellipse (CLUTTER_FLOAT_TO_FIXED (center_x),
                           CLUTTER_FLOAT_TO_FIXED (center_y),
                           CLUTTER_FLOAT_TO_FIXED (radius_x),
                           CLUTTER_FLOAT_TO_FIXED (radius_y));

=for apidoc
Clears the previously constructed shape and constructs a rectangular
shape with rounded corners
=cut
void
cogl_path_round_rectangle (class=NULL, x, y, width, height, radius, arc_step)
        gdouble x
        gdouble y
        gdouble width
        gdouble height
        gdouble radius
        gdouble arc_step
    CODE:
        cogl_path_round_rectangle (CLUTTER_FLOAT_TO_FIXED (x),
                                   CLUTTER_FLOAT_TO_FIXED (y),
                                   CLUTTER_FLOAT_TO_FIXED (width),
                                   CLUTTER_FLOAT_TO_FIXED (height),
                                   CLUTTER_FLOAT_TO_FIXED (radius),
                                   CLUTTER_ANGLE_FROM_DEG (arc_step));

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

