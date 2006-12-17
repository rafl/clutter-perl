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
clutterperl_call_method (GType       gtype,
                         const char *method,
                         gint        flags)
{
        HV *stash;
        GV *slot;

        stash = gperl_object_stash_from_type (gtype);
        slot = gv_fetchmethod (stash, method);

        if (slot && GvCV (slot)) {
                call_sv ((SV *) GvCV (slot), flags);
        }
}

static void
clutterperl_media_set_uri (ClutterMedia *media,
			   const gchar  *uri)
{
        dSP;
        ENTER;
        SAVETMPS;
        PUSHMARK (SP);

        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVGObject (G_OBJECT (media))));
        PUSHs (sv_2mortal (newSVGChar (uri)));

        PUTBACK;
        
        clutterperl_call_method (G_OBJECT_TYPE (media),
                                 "SET_URI",
                                 G_VOID | G_DISCARD);

        FREETMPS;
        LEAVE;
}

static const gchar *
clutterperl_media_get_uri (ClutterMedia *media)
{
        SV *ret_sv;
        dSP;
        ENTER;
        SAVETMPS;
        PUSHMARK (SP);

        PUSHs (sv_2mortal (newSVGObject (G_OBJECT (media))));

        PUTBACK;

        clutterperl_call_method (G_OBJECT_TYPE (media),
                                 "GET_URI",
                                 G_SCALAR);
        SPAGAIN;
        
        ret_sv = POPs;
        SvREFCNT_inc (ret_sv);
        
        PUTBACK;
        FREETMPS;
        LEAVE;

        sv_2mortal (ret_sv);
        return SvGChar (ret_sv);
}

static void
clutterperl_media_set_playing (ClutterMedia *media,
			       gboolean      playing)
{
        dSP;
        ENTER;
        SAVETMPS;
        PUSHMARK (SP);

        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVGObject (G_OBJECT (media))));
        PUSHs (sv_2mortal (newSVuv (playing)));

        PUTBACK;
        
        clutterperl_call_method (G_OBJECT_TYPE (media),
                                 "SET_PLAYING",
                                 G_VOID | G_DISCARD);

        FREETMPS;
        LEAVE;
}

static gboolean
clutterperl_media_get_playing (ClutterMedia *media)
{
        gboolean retval;
        dSP;
        ENTER;
        SAVETMPS;
        PUSHMARK (SP);

        PUSHs (sv_2mortal (newSVGObject (G_OBJECT (media))));

        PUTBACK;

        clutterperl_call_method (G_OBJECT_TYPE (media),
                                 "GET_PLAYING",
                                 G_SCALAR);
        SPAGAIN;
        
        {
                SV * sv_ret = POPs;
                retval = SvTRUE (sv_ret);
        }
        
        PUTBACK;
        FREETMPS;
        LEAVE;

        return retval;
}

static void
clutterperl_media_set_position (ClutterMedia *media,
				gint          position)
{
        dSP;
        ENTER;
        SAVETMPS;
        PUSHMARK (SP);

        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVGObject (G_OBJECT (media))));
        PUSHs (sv_2mortal (newSViv (position)));

        PUTBACK;
        
        clutterperl_call_method (G_OBJECT_TYPE (media),
                                 "SET_POSITION",
                                 G_VOID | G_DISCARD);

        FREETMPS;
        LEAVE;
}

static gint
clutterperl_media_get_position (ClutterMedia *media)
{
        gint retval;
        dSP;
        ENTER;
        SAVETMPS;
        PUSHMARK (SP);

        PUSHs (sv_2mortal (newSVGObject (G_OBJECT (media))));

        PUTBACK;

        clutterperl_call_method (G_OBJECT_TYPE (media),
                                 "GET_POSITION",
                                 G_SCALAR);
        SPAGAIN;
        
        retval = POPi;
        
        PUTBACK;
        FREETMPS;
        LEAVE;

        return retval;
}

static void
clutterperl_media_set_volume (ClutterMedia *media,
                              gdouble       volume)
{
        dSP;
        ENTER;
        SAVETMPS;
        PUSHMARK (SP);

        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVGObject (G_OBJECT (media))));
        PUSHs (sv_2mortal (newSVnv (volume)));

        PUTBACK;
        
        clutterperl_call_method (G_OBJECT_TYPE (media),
                                 "SET_VOLUME",
                                 G_VOID | G_DISCARD);

        FREETMPS;
        LEAVE;
}

static gdouble
clutterperl_media_get_volume (ClutterMedia *media)
{
        gdouble retval;
        dSP;
        ENTER;
        SAVETMPS;
        PUSHMARK (SP);

        PUSHs (sv_2mortal (newSVGObject (G_OBJECT (media))));

        PUTBACK;

        clutterperl_call_method (G_OBJECT_TYPE (media),
                                 "GET_VOLUME",
                                 G_SCALAR);
        SPAGAIN;
        
        retval = POPn;
        
        PUTBACK;
        FREETMPS;
        LEAVE;

        return retval;
}

static gboolean
clutterperl_media_can_seek (ClutterMedia *media)
{
        gboolean retval;
        dSP;
        ENTER;
        SAVETMPS;
        PUSHMARK (SP);

        PUSHs (sv_2mortal (newSVGObject (G_OBJECT (media))));

        PUTBACK;

        clutterperl_call_method (G_OBJECT_TYPE (media),
                                 "CAN_SEEK",
                                 G_SCALAR);
        SPAGAIN;
        
        {
                SV * sv_ret = POPs;
                retval = SvTRUE (sv_ret);
        }
        
        PUTBACK;
        FREETMPS;
        LEAVE;

        return retval;
}

static gint
clutterperl_media_get_buffer_percent (ClutterMedia *media)
{
        gint retval;
        dSP;
        ENTER;
        SAVETMPS;
        PUSHMARK (SP);

        PUSHs (sv_2mortal (newSVGObject (G_OBJECT (media))));

        PUTBACK;

        clutterperl_call_method (G_OBJECT_TYPE (media),
                                 "GET_BUFFER_PERCENT",
                                 G_SCALAR);
        SPAGAIN;
        
        retval = POPi;
        
        PUTBACK;
        FREETMPS;
        LEAVE;

        return retval;
}

static gint
clutterperl_media_get_duration (ClutterMedia *media)
{
        gint retval;
        dSP;
        ENTER;
        SAVETMPS;
        PUSHMARK (SP);

        PUSHs (sv_2mortal (newSVGObject (G_OBJECT (media))));

        PUTBACK;

        clutterperl_call_method (G_OBJECT_TYPE (media),
                                 "GET_DURATION",
                                 G_SCALAR);
        SPAGAIN;
        
        retval = POPi;
        
        PUTBACK;
        FREETMPS;
        LEAVE;

        return retval;
}

static void
clutterperl_media_init (ClutterMediaInterface *iface)
{
  iface->set_uri = clutterperl_media_set_uri;
  iface->get_uri = clutterperl_media_get_uri;
  iface->set_playing = clutterperl_media_set_playing;
  iface->get_playing = clutterperl_media_get_playing;
  iface->set_position = clutterperl_media_set_position;
  iface->get_position = clutterperl_media_get_position;
  iface->set_volume = clutterperl_media_set_volume;
  iface->get_volume = clutterperl_media_get_volume;
  iface->can_seek = clutterperl_media_can_seek;
  iface->get_buffer_percent = clutterperl_media_get_buffer_percent;
  iface->get_duration = clutterperl_media_get_duration;
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

=head2 VIRTUAL METHODS

In order to create a Clutter::Media object, an implementation of the following
methods is required:

=over

=item SET_URI ($media, $uri)

=item uri = GET_URI ($media)

=item SET_PLAYING ($media, $is_playing)

=item is_playing = GET_PLAYING ($media)

=item SET_POSITION ($media, $position)

=item position = GET_POSITION ($media)

=item SET_VOLUME ($media, $volume)

=item volume = GET_VOLUME ($media)

=item boolean = CAN_SEEK ($media)

=item double = GET_BUFFER_PERCENT ($media)

=item duration = GET_DURATION ($media)

=back

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
clutter_media_set_position (ClutterMedia *media, gint position)

gint
clutter_media_get_position (ClutterMedia *media)

void
clutter_media_set_volume (ClutterMedia *media, gdouble volume)

gdouble
clutter_media_get_volume (ClutterMedia *media)

gint
clutter_media_get_buffer_percent (ClutterMedia *media)

gint
clutter_media_get_duration (ClutterMedia *media)

void
clutter_media_set_filename (ClutterMedia *media, const gchar *filename)

