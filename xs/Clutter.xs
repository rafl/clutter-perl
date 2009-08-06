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

static gboolean
clutterperl_threads_cb (gpointer data)
{
  GPerlCallback *callback = data;
  GValue ret_value = { 0, };
  gboolean retval = FALSE;

  g_value_init (&ret_value, callback->return_type);

  gperl_callback_invoke (callback, &ret_value);
  
  retval = g_value_get_boolean (&ret_value);
  g_value_unset (&ret_value);

  return retval;
}

MODULE = Clutter        PACKAGE = Clutter::Threads      PREFIX = clutter_threads_

void
clutter_threads_init (class)
    ALIAS:
        enter = 1
        leave = 2
    CODE:
        switch (ix) {
                case 0: clutter_threads_init ();  break;
                case 1: clutter_threads_enter (); break;
                case 2: clutter_threads_leave (); break;
                default:
                        g_assert_not_reached ();
                        break;
        }

guint
clutter_threads_add_idle (class, callback, data=NULL, priority=G_PRIORITY_DEFAULT_IDLE)
        SV *callback
        SV *data
        gint priority
    PREINIT:
        GPerlCallback *cb;
    CODE:
        cb = gperl_callback_new (callback, data, 0, NULL, G_TYPE_BOOLEAN);
        RETVAL = clutter_threads_add_idle_full (priority,
                                                clutterperl_threads_cb,
                                                cb,
                                                (GDestroyNotify) gperl_callback_destroy);
    OUTPUT:
        RETVAL

guint
clutter_threads_add_timeout (class, interval, callback, data=NULL, priority=G_PRIORITY_DEFAULT_IDLE)
        guint interval
        SV *callback
        SV *data
        gint priority
    PREINIT:
        GPerlCallback *cb;
    CODE:
        cb = gperl_callback_new (callback, data, 0, NULL, G_TYPE_BOOLEAN);
        RETVAL = clutter_threads_add_timeout_full (priority,
                                                   interval,
                                                   clutterperl_threads_cb,
                                                   cb,
                                                   (GDestroyNotify) gperl_callback_destroy);
    OUTPUT:
        RETVAL

guint
clutter_threads_add_frame_source (class, fps, callback, data=NULL, priority=G_PRIORITY_DEFAULT_IDLE)
        guint fps
        SV *callback
        SV *data
        gint priority
    PREINIT:
        GPerlCallback *cb;
    CODE:
        cb = gperl_callback_new (callback, data, 0, NULL, G_TYPE_BOOLEAN);
        RETVAL = clutter_threads_add_frame_source_full (priority,
                                                        fps,
                                                        clutterperl_threads_cb,
                                                        cb,
                                                        (GDestroyNotify) gperl_callback_destroy);
    OUTPUT:
        RETVAL

guint
clutter_threads_add_repaint_func (class, SV *callback, SV *data=NULL)
    PREINIT:
        GPerlCallback *cb;
    CODE:
        cb = gperl_callback_new (callback, data, 0, NULL, G_TYPE_BOOLEAN);
        RETVAL = clutter_threads_add_repaint_func (clutterperl_threads_cb,
                                                   cb,
                                                   (GDestroyNotify) gperl_callback_destroy);

void clutter_threads_remove_repaint_func (class, guint func_id);
    C_ARGS:
        func_id

MODULE = Clutter	PACKAGE = Clutter	PREFIX = clutter_

=for object Clutter::version
=cut

BOOT:
#include "register.xsh"
#include "boot.xsh"
	gperl_handle_logs_for ("Clutter");
	gperl_handle_logs_for ("Clutter-X11");
	gperl_handle_logs_for ("Clutter-GLX");
	gperl_handle_logs_for ("Clutter-Win32");
	gperl_handle_logs_for ("Clutter-OSX");
	gperl_handle_logs_for ("Clutter-SDL");
        gperl_handle_logs_for ("Cogl");
        gperl_handle_logs_for ("Cogl-Common");
        gperl_handle_logs_for ("Cogl-GL");

guint
MAJOR_VERSION ()
    ALIAS:
        Clutter::MINOR_VERSION = 1
	Clutter::MICRO_VERSION = 2
    CODE:
        switch (ix) {
		case 0: RETVAL = CLUTTER_MAJOR_VERSION; break;
		case 1: RETVAL = CLUTTER_MINOR_VERSION; break;
		case 2: RETVAL = CLUTTER_MICRO_VERSION; break;
		default:
			RETVAL = 0;
			g_assert_not_reached ();
	}
    OUTPUT:
        RETVAL

=for apidoc
=for signature (MAJOR, MINOR, MICRO) = Clutter->GET_VERSION_INFO
Fetch as a list the version of clutter for which Clutter was built.
=cut
void
GET_VERSION_INFO (class)
    PPCODE:
        EXTEND (SP, 3);
	PUSHs (sv_2mortal (newSViv (CLUTTER_MAJOR_VERSION)));
	PUSHs (sv_2mortal (newSViv (CLUTTER_MINOR_VERSION)));
	PUSHs (sv_2mortal (newSViv (CLUTTER_MICRO_VERSION)));
	PERL_UNUSED_VAR (ax);

gboolean
CHECK_VERSION (class, major, minor, micro)
	int major
	int minor
	int micro
    CODE:
        RETVAL = CLUTTER_CHECK_VERSION (major, minor, micro);
    OUTPUT:
        RETVAL

=for apidoc
=for signature flavour = Clutter->FLAVOUR

Returns the backend (or I<flavour>) against which the underlying C
library was compiled.
=cut
void
FLAVOUR (class)
    PPCODE:
        XPUSHs (sv_2mortal (newSVpv (CLUTTER_FLAVOUR, 0)));
        PERL_UNUSED_VAR (ax);

=for apidoc
=for signature cogl = Clutter->COGL

Returns the OpenGL library used by the underlying C library.
=cut
void
COGL (class)
    PPCODE:
        XPUSHs (sv_2mortal (newSVpv (CLUTTER_COGL, 0)));
        PERL_UNUSED_VAR (ax);

=for object Clutter::main
=cut

ClutterInitError
clutter_init (class=NULL)
    PREINIT:
        GPerlArgv *pargv;
    CODE:
        pargv = gperl_argv_new ();
	RETVAL = clutter_init (&pargv->argc, &pargv->argv);
	gperl_argv_update (pargv);
	gperl_argv_free (pargv);
    OUTPUT:
        RETVAL

void
clutter_main (class)
    C_ARGS:
        /* void */

void
clutter_main_quit (class)
    C_ARGS:
        /* void */

guint
clutter_main_level (class)
    C_ARGS:
        /* void */

gboolean
clutter_get_debug_enabled (class=NULL)
    C_ARGS:
        /* void */

gboolean
clutter_get_show_fps (class=NULL)
    C_ARGS:
        /* void */

gulong
clutter_get_timestamp (class=NULL)
    C_ARGS:
        /* void */

void
clutter_set_motion_events_enabled (class=NULL, gboolean enable)
    C_ARGS:
        enable

gboolean
clutter_get_motion_events_enabled (class=NULL)
    C_ARGS:
        /* void */

void
clutter_set_default_frame_rate (class=NULL, guint frame_rate)
    C_ARGS:
        frame_rate

guint
clutter_get_default_frame_rate (class=NULL)
    C_ARGS:
        /* void */

void
clutter_grab_pointer (class=NULL, ClutterActor *actor)
    C_ARGS:
        actor

void
clutter_ungrab_pointer (class=NULL)
    C_ARGS:
        /* void */

void
clutter_grab_keyboard (class=NULL, ClutterActor *actor)
    C_ARGS:
        actor

void
clutter_ungrab_keyboard (class=NULL)
    C_ARGS:
        /* void */

ClutterActor_ornull *
clutter_get_pointer_grab (class=NULL)
    C_ARGS:
        /* void */

ClutterActor_ornull *
clutter_get_keyboard_grab (class=NULL)
    C_ARGS:
        /* void */

