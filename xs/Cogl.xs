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

#include "clutterperl-private.h"

/* taken from Glib/GType.xs */
void
cogl_perl_set_isa (const char *child_package,
                   const char *parent_package)
{
        char *child_isa_full;
        AV *isa;

        New (0, child_isa_full, strlen(child_package) + 5 + 1, char);
        child_isa_full = strcpy (child_isa_full, child_package);
        child_isa_full = strcat (child_isa_full, "::ISA");
        isa = get_av (child_isa_full, TRUE); /* create on demand */
        Safefree (child_isa_full);

        av_push (isa, newSVpv (parent_package, 0));
}

gpointer
cogl_perl_object_from_sv (SV *sv, const char *package)
{
        if (!SvOK (sv) || !SvROK (sv) || !sv_derived_from (sv, package))
                croak("Cannot convert scalar %p to an object of type %s",
                      sv, package);
        return INT2PTR (void *, SvIV ((SV *) SvRV (sv)));
}

SV *
cogl_perl_object_to_sv (gpointer object, const char *package)
{
        SV *sv = newSV (0);
        sv_setref_pv(sv, package, object);
        return sv;
}

gpointer
cogl_perl_struct_from_sv (SV *sv, const char *package)
{
        if (!SvOK (sv) || !SvROK (sv) || !sv_derived_from (sv, package))
                croak("Cannot convert scalar %p to a struct of type %s",
                      sv, package);
        return INT2PTR (void *, SvIV ((SV *) SvRV (sv)));
}

SV *
cogl_perl_struct_to_sv (gpointer object, const char *package)
{
        SV *sv = newSV (0);
        sv_setref_pv(sv, package, object);
        return sv;
}

MODULE = Clutter::Cogl  PACKAGE = Clutter::Cogl PREFIX = cogl_

=for enum CoglFeatureFlags
=cut

=for enum CoglBufferBit
=cut

=for enum CoglFogMode
=cut

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
Retrieves the size of the current viewport
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
drawing material in a highly optimizied fashion
=cut
void
cogl_rectangle (class=NULL, float x1, float y1, float x2, float y2)
    C_ARGS:
        x1, y1, x2, y2

=for apidoc
Draws a series of rectangles in the same way that Clutter::Cogl::rectangle()
does. In some situations it can give a significant performance boost to use
this function rather than calling Clutter::Cogl::rectangle() separately for
each rectangle.

The I<vertices> array reference should point to an array of floating point
values. Each group of 4 values corresponds to the parameters x1, y1, x2, and
y2, and have the same meaning as in Clutter::Cogl::rectangle().
=cut
void
cogl_rectangles (class=NULL, SV *vertices)
    PREINIT:
        AV *av;
        gfloat *v;
        guint i, n_rects;
    CODE:
        if (!gperl_sv_is_array_ref (vertices))
                croak ("vertices must be a reference to an array of array "
                       "references, containing 4 coordinates; e.g.: "
                       "[ [ x1, y1, x2, y2 ], [ x1, y1, x2, y2] ]");
        av = (AV *) SvRV (vertices);
        n_rects = av_len (av);
        if (n_rects < 1)
                croak ("vertices array is empty");
        v = gperl_alloc_temp (sizeof (gfloat) * n_rects * 4);
        for (i = 0; i < n_rects; i++) {
                SV **svp = av_fetch (av, i, 0);
                AV *inner = (AV *) *svp;
                if (!gperl_sv_is_array_ref (*svp) || (av_len (inner) != 4))
                        croak ("vertices must contain array references");
                v[i + 0] = SvNV (*av_fetch (inner, 0, 0));
                v[i + 1] = SvNV (*av_fetch (inner, 1, 0));
                v[i + 2] = SvNV (*av_fetch (inner, 2, 0));
                v[i + 3] = SvNV (*av_fetch (inner, 3, 0));
        }
        cogl_rectangles (v, n_rects);

=for apidoc
Draw a rectangle using the current material and supply texture coordinates
to be used for the first texture layer of the material. To draw the entire
texture pass in I<tx1>=0.0, I<ty1>=0.0, I<tx2>=1.0 and I<ty2>=1.0.
=cut
void
cogl_rectangle_with_texture_coords (class=NULL, x1, y1, x2, y2, tx1, ty1, tx2, ty2)
        float x1
        float y1
        float x2
        float y2
        float tx1
        float ty1
        float tx2
        float ty2
    C_ARGS:
        x1, y1, x2, y2, tx1, ty1, tx2, ty2

void
cogl_rectangles_with_texture_coords (class=NULL, SV *vertices)
    PREINIT:
        AV *av;
        gfloat *v;
        guint i, n_rects;
    CODE:
        if (!gperl_sv_is_array_ref (vertices))
                croak ("vertices must be a reference to an array of array "
                       "references, containing 8 coordinates; e.g.: "
                       "[ [ x1, y1, x2, y2, tx1, ty1, tx2, ty2 ], "
                       "[ x1, y1, x2, y2, tx1, ty1, tx2, ty2 ] ]");
        av = (AV *) SvRV (vertices);
        n_rects = av_len (av);
        if (n_rects < 1)
                croak ("vertices array is empty");
        v = gperl_alloc_temp (sizeof (gfloat) * n_rects * 8);
        for (i = 0; i < n_rects; i++) {
                SV **svp = av_fetch (av, i, 0);
                AV *inner = (AV *) *svp;
                if (!gperl_sv_is_array_ref (*svp) || (av_len (inner) != 8))
                        croak ("vertices must contain array references");
                v[i + 0] = SvNV (*av_fetch (inner, 0, 0));
                v[i + 1] = SvNV (*av_fetch (inner, 1, 0));
                v[i + 2] = SvNV (*av_fetch (inner, 2, 0));
                v[i + 3] = SvNV (*av_fetch (inner, 3, 0));
                v[i + 4] = SvNV (*av_fetch (inner, 4, 0));
                v[i + 5] = SvNV (*av_fetch (inner, 5, 0));
                v[i + 6] = SvNV (*av_fetch (inner, 6, 0));
                v[i + 7] = SvNV (*av_fetch (inner, 7, 0));
        }
        cogl_rectangles_with_texture_coords (v, n_rects);

void
cogl_polygon (class=NULL, SV *vertices, gboolean use_color)
    PREINIT:
        AV *av;
        CoglTextureVertex *v;
        gint n_vertices, i;
    CODE:
        if (!gperl_sv_is_array_ref (vertices))
                croak ("vertices must be a reference to an array of texture vertices");
        av = (AV *) SvRV (vertices);
        n_vertices = av_len (av) + 1;
        if (n_vertices < 1)
                croak ("vertices array is empty");
        v = gperl_alloc_temp (sizeof (CoglTextureVertex) * n_vertices);
        for (i = 0; i < n_vertices; i++) {
                SV **svp = av_fetch (av, i, 0);
                cogl_perl_texture_vertex_from_sv (*svp, v + i);
        }
        cogl_polygon (v, n_vertices, use_color);

=for apidoc
Sets whether depth testing is enabled. If it is disabled then the
order that actors are layered on the screen depends solely on the
order specified using Clutter::Actor::raise() and Clutter::Actor::lower(),
otherwise it will also take into account the actor's depth.

Depth testing is disabled by default.
=cut
void cogl_set_depth_test_enabled (class, gboolean enabled);
    C_ARGS:
        enabled

gboolean cogl_get_depth_test_enabled (class);
    C_ARGS:
        /* void */

=for apidoc
Sets whether textures positioned so that their backface is showing
should be hidden. This can be used to efficiently draw two-sided
textures or fully closed cubes without enabling depth testing. This
only affects calls to the Clutter::Cogl::rectangle* family of functions
and Clutter::Cogl::VertexBuffer::draw*.

Backface culling is disabled by default.
=cut
void cogl_set_backface_culling_enabled (class, gboolean enabled);
    C_ARGS:
        enabled

gboolean cogl_get_backface_culling_enabled (class);
    C_ARGS:
        /* void */

=for apidoc
=for arg fog_color (CoglColor)
Enables fogging. Fogging causes vertices that are further away from the eye
to be rendered with a different color. The color is determined according to
the chosen fog mode; at its simplest the color is linearly interpolated so
that vertices at I<z_near> are drawn fully with their original color and
vertices at I<z_far> are drawn fully with I<fog_color>. Fogging will remain
enabled until you call Clutter::Cogl::disable_fog().

B<Note>: The fogging functions only work correctly when primitives use
unmultiplied alpha colors. By default Cogl will premultiply textures
and Clutter::Cogl::set_source_color() will premultiply colors, so unless you
explicitly load your textures requesting an unmultiplied internal format
and use Clutter::Cogl::Material::set_color() you can only use fogging with
fully opaque primitives. This might improve in the future when we can depend
on fragment shaders.
=cut
void
cogl_set_fog (class, fog_color, mode, density, z_near, z_far)
        SV *fog_color
        CoglFogMode mode
        float density
        float z_near
        float z_far
    PREINIT:
        CoglColor color;
    CODE:
        cogl_perl_color_from_sv (fog_color, &color);
        cogl_set_fog (&color, mode, density, z_near, z_far);

void cogl_disable_fog (class);
    C_ARGS:
        /* void */

=for apidoc
=for arg color (CoglColor)
Clears all the auxiliary buffers identified in the I<buffers mask>, and if
that includes the color buffer then the specified I<color> is used.
=cut
void cogl_clear (class, SV *color, CoglBufferBit buffers);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_perl_color_from_sv (color, &c);
        cogl_clear (&c, buffers);

=for apidoc
This function sets the source material that will be used to fill subsequent
geometry emitted via the cogl API.

B<Note>: in the future we may add the ability to set a front facing material,
and a back facing material, in which case this function will set both to the
same.
=cut
void cogl_set_source (class, CoglHandle material);
    C_ARGS:
        material

=for apidoc
=for arg color (CoglColor)
This is a convenience function for creating a solid fill source material
from the given I<color>. This color will be used for any subsequent drawing
operation.

The I<color> will be premultiplied by Cogl, so the color should be
non-premultiplied. For example: use (1.0, 0.0, 0.0, 0.5) for
semi-transparent red.
=cut
void cogl_set_source_color (class, SV *color);
    PREINIT:
        CoglColor c;
    CODE:
        cogl_perl_color_from_sv (color, &c);
        cogl_set_source_color (&c);

=for apidoc
This is a convenience function for creating a material with the first
layer set to I<texture> and setting that material as the source with
Clutter::Cogl::set_source()

B<Note>: There is no interaction between calls to
Clutter::Cogl::set_source_color and Clutter::Cogl::set_source_texture().
If you need to blend a texture with a color then you can create a simple
material like this:

    $material = Clutter::Cogl::Material->new ();
    $material->set_color (material, (0xff, 0x00, 0x00, 0x80));
    $material->set_layer (material, 0, texture);
    Clutter::Cogl->set_source ($material);

=cut
void cogl_set_source_texture (class, CoglHandle texture);
    C_ARGS:
        texture

