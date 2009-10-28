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

#include "clutter-perl-private.h"

MODULE = Clutter::Texture PACKAGE = Clutter::Texture PREFIX = clutter_texture_

=for object Clutter::Texture - An actor for displaying and manipulating images
=cut

=for enum ClutterTextureFlags
=cut

=for enum ClutterTextureQuality
=cut

ClutterActor *
clutter_texture_new (class, filename=NULL)
        const gchar_ornull *filename
    CODE:
        if (filename) {
                GError *error = NULL;

                RETVAL = clutter_texture_new_from_file (filename, &error);
                if (error)
                        gperl_croak_gerror (NULL, error);
        }
        else
                RETVAL = clutter_texture_new ();
    OUTPUT:
        RETVAL

ClutterActor *
clutter_texture_new_from_actor (SV *class, ClutterActor *actor)
    C_ARGS:
        actor

=for apidoc
=for signature (width, height) = $texture->get_base_size
=cut
void
clutter_texture_get_base_size (ClutterTexture *texture)
    PREINIT:
        gint width, height;
    PPCODE:
        clutter_texture_get_base_size (texture, &width, &height);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (width)));
	PUSHs (sv_2mortal (newSViv (height)));

void
clutter_texture_set_filter_quality (ClutterTexture *texture, ClutterTextureQuality filter_quality)

ClutterTextureQuality
clutter_texture_get_filter_quality (ClutterTexture *texture)

gint
clutter_texture_get_max_tile_waste (ClutterTexture *texture)

=for apidoc __gerror__
=cut
gboolean
clutter_texture_set_from_rgb_data (texture, data, has_alpha, width, height, rowstride, bpp, flags)
        ClutterTexture *texture
        SV *data
        gboolean has_alpha
        gint width
        gint height
        gint rowstride
        gint bpp
        ClutterTextureFlags flags
    PREINIT:
        GError *error;
    CODE:
        if (!data || !SvPOK (data))
                croak ("expecting a packed string for pixel data");
        error = NULL;
        RETVAL = clutter_texture_set_from_rgb_data (texture,
                                                    (const guchar *) SvPV_nolen (data),
                                                    has_alpha,
                                                    width, height,
                                                    rowstride, bpp,
                                                    flags,
                                                    &error);
        if (error)
                gperl_croak_gerror (NULL, error);
    OUTPUT:
        RETVAL

=for apidoc __gerror__
=cut
gboolean
clutter_texture_set_area_from_rgb_data (texture, data, has_alpha, x, y, width, height, rowstride, bpp, flags)
        ClutterTexture *texture
        SV *data
        gboolean has_alpha
        gint x
        gint y
        gint width
        gint height
        gint rowstride
        gint bpp
        ClutterTextureFlags flags
    PREINIT:
        GError *error;
    CODE:
        if (!data || !SvPOK (data))
                croak ("expecting a packed string for pixel data");
        error = NULL;
        RETVAL = clutter_texture_set_area_from_rgb_data (texture,
                                                         (const guchar *) SvPV_nolen (data),
                                                         has_alpha,
                                                         x, y,
                                                         width, height,
                                                         rowstride, bpp,
                                                         flags,
                                                         &error);
        if (error)
                gperl_croak_gerror (NULL, error);
    OUTPUT:
        RETVAL

=for apidoc __gerror__
=cut
gboolean
clutter_texture_set_from_yuv_data (texture, data, width, height, flags)
        ClutterTexture *texture
        SV *data
        gint width
        gint height
        ClutterTextureFlags flags
    PREINIT:
        GError *error;
    CODE:
        error = NULL;
        RETVAL = clutter_texture_set_from_yuv_data (texture,
                                                    (const guchar *) SvPV_nolen (data),
                                                    width, height,
                                                    flags,
                                                    &error);
        if (error)
                gperl_croak_gerror (NULL, error);
    OUTPUT:
        RETVAL

=for apidoc __gerror__
=cut
gboolean
clutter_texture_set_from_file (texture, filename)
        ClutterTexture *texture
        const gchar *filename
    PREINIT:
        GError *error = NULL;
    CODE:
        RETVAL = clutter_texture_set_from_file (texture, filename, &error);
        if (error)
                gperl_croak_gerror (NULL, error);
    OUTPUT:
        RETVAL

CoglHandle
clutter_texture_get_cogl_texture (ClutterTexture *texture)

void
clutter_texture_set_cogl_texture (ClutterTexture *texture, CoglHandle tex)

