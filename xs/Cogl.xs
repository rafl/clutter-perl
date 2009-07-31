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

