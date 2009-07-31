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

static void
clutterperl_media_init (ClutterMediaIface *iface)
{
}

MODULE = Clutter::Media		PACKAGE = Clutter::Media	PREFIX = clutter_media_

=for position DESCRIPTION

=head1 DESCRIPTION

FIXME

=cut

=for position post_methods

=head1 CREATING A CUSTOM MEDIA OBJECT

  package MyMedia;
  use Clutter;
  use Glib::Object::Subclass
      'Glib::Object',
      interfaces => [ qw( Clutter::Media ) ],
      ;

=cut

=for apidoc __hide__
=cut
void
_ADD_INTERFACE (class, const char *target_class)
    CODE:
    {
        static const GInterfaceInfo iface_info = {
                (GInterfaceInitFunc) clutterperl_media_init,
                NULL,
                NULL,
        };
        GType gtype = gperl_object_type_from_package (target_class);
        g_type_add_interface_static (gtype, CLUTTER_TYPE_MEDIA, &iface_info);
    }

void
clutter_media_set_uri (ClutterMedia *media, const gchar *uri)

const gchar *
clutter_media_get_uri (ClutterMedia *media)

void
clutter_media_set_playing (ClutterMedia *media, gboolean playing)

gboolean
clutter_media_get_playing (ClutterMedia *media)

void
clutter_media_set_progress (ClutterMedia *media, gdouble progress)

gdouble
clutter_media_get_progress (ClutterMedia *media)

void
clutter_media_set_audio_volume (ClutterMedia *media, gdouble volume)

gdouble
clutter_media_get_audio_volume (ClutterMedia *media)

gboolean
clutter_media_get_can_seek (ClutterMedia *media)

gdouble
clutter_media_get_buffer_fill (ClutterMedia *media)

gdouble
clutter_media_get_duration (ClutterMedia *media)

void
clutter_media_set_filename (ClutterMedia *media, const gchar *filename)

