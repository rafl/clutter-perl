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


#if 0

#define PREP            \
	dSP;            \
	ENTER;          \
	SAVETMPS;       \
	PUSHMARK (SP);  \
	PUSHs (sv_2mortal (newSVGObject (G_OBJECT (cell))));

#define CALL            \
	PUTBACK;        \
	call_sv ((SV *)GvCV (slot), G_VOID|G_DISCARD);

#define FINISH          \
	FREETMPS;       \
	LEAVE;

#define GET_METHOD(method)      \
	HV * stash = gperl_object_stash_from_type (G_OBJECT_TYPE (cell)); \
	GV * slot = gv_fetchmethod (stash, method);

#define METHOD_EXISTS (slot && GvCV (slot))

static void
clutterperl_media_set_uri (ClutterMedia *media,
			   const gchar  *uri)
{
  GET_METHOD ("SET_URI");

  if (METHOD_EXISTS)
    {
      PREP;
      XPUSHs (sv_2mortal (newSVGChar (uri)));
      CALL;
      FINISH;
    }
}

static const gchar *
clutterperl_media_get_uri (ClutterMedia *media)
{
  return NULL;
}

static void
clutterperl_media_set_playing (ClutterMedia *media,
			       gboolean      playing)
{

}

static gboolean
clutterperl_media_get_playing (ClutterMedia *media)
{
  return FALSE;
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
#endif

MODULE = Clutter::Media		PACKAGE = Clutter::Media	PREFIX = clutter_media_

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

double
clutter_media_get_volume (ClutterMedia *media)

gint
clutter_media_get_buffer_percent (ClutterMedia *media)

gint
clutter_media_get_duration (ClutterMedia *media)

void
clutter_media_set_filename (ClutterMedia *media, const gchar *filename)

