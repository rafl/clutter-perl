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

MODULE = Clutter::Texture PACKAGE = Clutter::Texture PREFIX = clutter_texture_

=for enum ClutterTextureFlags
=cut

ClutterActor *
clutter_texture_new (class, pixbuf=NULL, actor=NULL)
        GdkPixbuf_ornull *pixbuf
        ClutterActor_ornull *actor
    CODE:
        if (pixbuf)
                RETVAL = clutter_texture_new_from_pixbuf (pixbuf);
        else if (actor)
                RETVAL = clutter_texture_new_from_actor (actor);
        else
                RETVAL = clutter_texture_new ();
    OUTPUT:
        RETVAL

=for apidoc
=for apidoc __gerror__
=cut
void
clutter_texture_set_pixbuf (ClutterTexture *texture, GdkPixbuf *pixbuf)
    PREINIT:
        GError *error = NULL;
    CODE:
        clutter_texture_set_pixbuf (texture, pixbuf, &error);
        if (error)
                gperl_croak_gerror (NULL, error);

GdkPixbuf_ornull *
clutter_texture_get_pixbuf (ClutterTexture* texture)

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

=for apidoc
=for signature (n_x_tiles, n_y_tiles) = $texture->get_n_tiles
=cut
void
clutter_texture_get_n_tiles (ClutterTexture *texture)
    PREINIT:
        gint n_x_tiles, n_y_tiles;
    PPCODE:
        clutter_texture_get_n_tiles (texture, &n_x_tiles, &n_y_tiles);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (n_x_tiles)));
	PUSHs (sv_2mortal (newSViv (n_y_tiles)));

=for apidoc Clutter::Texture::get_x_tile_detail
=for signature (pos, size, waste) = $texture->get_x_tile_detail ($x_index)
=for arg x_index (integer)
=for arg index (__hide__)
=cut

=for apidoc Clutter::Texture::get_y_tile_detail
=for signature (pos, size, waste) = $texture->get_y_tile_detail ($y_index)
=for arg y_index (integer)
=for arg index (__hide__)
=cut

void
clutter_texture_get_x_tile_detail (ClutterTexture *texture, gint index)
    ALIAS:
        Clutter::Texture::get_y_tile_detail = 1
    PREINIT:
        gint pos, size, waste;
    PPCODE:
        if (ix == 0) {
	  clutter_texture_get_x_tile_detail (texture, index,
			  		     &pos,
					     &size,
					     &waste);
        }
        else if (ix == 1) {
	  clutter_texture_get_y_tile_detail (texture, index,
			  		     &pos,
					     &size,
					     &waste);
        }
        else {
          pos = size = waste = -1;
	  g_assert_not_reached ();
	}
	
	EXTEND (SP, 3);
	PUSHs (sv_2mortal (newSViv (pos)));
	PUSHs (sv_2mortal (newSViv (size)));
	PUSHs (sv_2mortal (newSViv (waste)));

gboolean
clutter_texture_has_generated_tiles (ClutterTexture *texture)

gboolean
clutter_texture_is_tiled (ClutterTexture *texture)

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
