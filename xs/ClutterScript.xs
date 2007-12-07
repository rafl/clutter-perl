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

/* This doesn't belong here.  But currently, this is the only place a GType for
 * GConnectFlags is needed, so adding extra API to Glib doesn't seem justified.
 */
static GType
clutterperl_connect_flags_get_type (void)
{
        static GType etype = 0;
        if (etype == 0) {
                static const GFlagsValue values[] = {
                        { G_CONNECT_AFTER, "G_CONNECT_AFTER", "after" },
                        { G_CONNECT_SWAPPED, "G_CONNECT_SWAPPED", "swapped" },
                        { 0, NULL, NULL }
                };
                etype = g_flags_register_static ("GConnectFlags", values);
        }
        return etype;
}

static GPerlCallback *
clutterperl_script_connect_func_create (SV *func, SV *data)
{
        GType param_types[] = {
                CLUTTER_TYPE_SCRIPT,
                G_TYPE_OBJECT,
                G_TYPE_STRING,
                G_TYPE_STRING,
                G_TYPE_OBJECT,
                clutterperl_connect_flags_get_type ()
        };

        return gperl_callback_new (func, data,
                                   G_N_ELEMENTS (param_types),
                                   param_types,
                                   G_TYPE_NONE);
}

static void
clutterperl_script_connect_func (ClutterScript *script,
                                 GObject       *object,
                                 const gchar   *signal_name,
                                 const gchar   *handler_name,
                                 GObject       *connect_object,
                                 GConnectFlags  flags,
                                 gpointer       user_data)
{
        gperl_callback_invoke ((GPerlCallback *) user_data,
                               NULL,
                               script,
                               object,
                               signal_name,
                               handler_name,
                               connect_object,
                               flags);
}

MODULE = Clutter::Script        PACKAGE = Clutter::Script        PREFIX = clutter_script_

BOOT:
        gperl_register_fundamental (clutterperl_connect_flags_get_type (),
                                    "Glib::ConnectFlags");
        gperl_register_error_domain (CLUTTER_SCRIPT_ERROR,
                                     CLUTTER_TYPE_SCRIPT_ERROR,
                                     "Clutter::Script::Error");

ClutterScript_noinc *
clutter_script_new (class)
    C_ARGS:
        /* void */

=for apidoc __gerror__
=cut
guint
clutter_script_load_from_file (ClutterScript *script, const gchar *filename)
    PREINIT:
        GError *error = NULL;
    CODE:
        RETVAL = clutter_script_load_from_file (script, filename, &error);
        if (error)
                gperl_croak_gerror (NULL, error);
    OUTPUT:
        RETVAL

=for apidoc __gerror__
=cut
guint
clutter_script_load_from_data (ClutterScript *script, const gchar *data)
    PREINIT:
        gsize length;
        GError *error = NULL;
    CODE:
        length = sv_len (ST (1));
        RETVAL = clutter_script_load_from_data (script, data, length, &error);
        if (error)
                gperl_croak_gerror (NULL, error);
    OUTPUT:
        RETVAL

=for apidoc
=for signature objects = $script->get_object ($name, ...)
=for arg name (string) first object's name
=for arg ... list of object names
=cut
void
clutter_script_get_object (ClutterScript *script, const gchar *name, ...)
    PREINIT:
        GObject *gobject;
        int i;
    PPCODE:
        gobject = clutter_script_get_object (script, name);
        XPUSHs (sv_2mortal (newSVGObject (gobject)));
        for (i = 2; i < items; i++) {
                gobject = clutter_script_get_object (script, SvGChar (ST (i)));
                XPUSHs (sv_2mortal (newSVGObject (gobject)));
        }

void
clutter_script_unmerge_objects (ClutterScript *script, guint merge_id)

void
clutter_script_ensure_objects (ClutterScript *script)

#if 0 /* evil hack to convince Glib::GenPod to output docs for connect_signals */

# connect_signals is implemented in Clutter.pm
=for apidoc Clutter::Script::connect_signals
=for signature $script->connect_signals ($user_data)
=for signature $script->connect_signals ($user_data, $package)
=for signature $script->connect_signals ($user_data, %handlers)
=for arg ... (__hide__)

There are four ways to let Clutter::Script do the signal connecting work
for you:

=over

=item C<< $script->connect_signals ($user_data) >>

When invoked like this, Clutter::Script will connect signals to functions in
the calling package.  The callback names are specified in the UI description.

=item C<< $script->connect_signals ($user_data, $package) >>

When invoked like this, Clutter::Script will connect signals to functions in
the package I<$package>.

=item C<< $script->connect_signals ($user_data, $object) >>

When invoked like this, Clutter::Script will connect signals to method calls
against the object $object.

=item C<< $script->connect_signals ($user_data, %handlers) >>

When invoked like this, I<%handlers> is used as a mapping from handler names
to code references.

=back

=cut
void clutter_script_connect_signals (ClutterScript *script, ...);

#endif /* evil hack */

void
clutter_script_connect_signals_full (ClutterScript *script, SV *func, SV *user_data=NULL);
    PREINIT:
	GPerlCallback *callback;
    CODE:
	callback = clutterperl_script_connect_func_create (func, user_data);
    	clutter_script_connect_signals_full (script,
                                             clutterperl_script_connect_func,
                                             callback);
	gperl_callback_destroy (callback);

MODULE = Clutter::Script        PACKAGE = Clutter

=for object Clutter::main
=cut

const gchar_ornull *
get_script_id (GObject *gobject)
    CODE:
        RETVAL = clutter_get_script_id (gobject);
    OUTPUT:
        RETVAL

