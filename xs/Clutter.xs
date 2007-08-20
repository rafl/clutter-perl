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


MODULE = Clutter	PACKAGE = Clutter	PREFIX = clutter_

=for object Clutter::version
=cut

BOOT:
#include "register.xsh"
#include "boot.xsh"
	gperl_handle_logs_for ("Clutter");
        gperl_handle_logs_for ("ClutterGst");

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

=for apidoc
=for signature modules = Clutter->SUPPORTED_MODULES

Return the list of supported integration libraries. The Clutter Perl bindings
can be compiled against the various integration libraries that compose the
Clutter suite; this method can be used to know what degree of support the
Perl bindings have. This function will return an array of strings:

=over

=item o core (Core support, will always be returned)

=item o gst (Clutter::Gst support)

=item o cairo (Clutter::Texture::Cairo actor)

=item o gtk (Gtk2::ClutterEmbed widget)

=back

=cut
void
SUPPORTED_MODULES (class)
    PPCODE:
        XPUSHs (sv_2mortal (newSVpv ("core", 0)));
#ifdef CLUTTERPERL_GST
        XPUSHs (sv_2mortal (newSVpv ("gst", 0)));
#endif
#ifdef CLUTTERPERL_CAIRO
        XPUSHs (sv_2mortal (newSVpv ("cairo", 0)));
#endif
#ifdef CLUTTERPERL_GTK
        XPUSHs (sv_2mortal (newSVpv ("gtk", 0)));
#endif

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

#ifndef CLUTTERPERL_GST

# /* in case we are not building Clutter without the GStreamer support
#  * we need a stub for clutter_gst_init(), to warn the user if the
#  * Clutter module was imported using the '-gst-init' parameter or if
#  * there's an explicit call to Clutter::Gst->init()
#  */

ClutterInitError
clutter_gst_init_dummy (class=NULL)
    ALIAS:
        Clutter::Gst::init = 0
    PREINIT:
        GPerlArgv *pargv;
    CODE:
        PERL_UNUSED_VAR (ax);
        pargv = gperl_argv_new ();
        g_warning ("Clutter was built without the support for GStreamer");
        RETVAL = clutter_init (&pargv->argc, &pargv->argv);
        gperl_argv_update (pargv); 
        gperl_argv_free (pargv);
    OUTPUT:
        RETVAL

#endif /* CLUTTERPERL_GST */

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
clutter_get_debug_enabled (class)
    C_ARGS:
        /* void */

gboolean
clutter_get_show_fps (class)
    C_ARGS:
        /* void */

gulong
clutter_get_timestamp (void)
    C_ARGS:
        /* void */
