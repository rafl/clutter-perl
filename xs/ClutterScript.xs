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

/* This doesn't belong here.  But currently, this is the only place a GType for
 * GConnectFlags is needed, so adding extra API to Glib doesn't seem justified.
 */
static GType
clutterperl_connect_flags_get_type (void)
{
        static GType etype = 0;

        etype = g_type_from_name ("GConnectFlags");
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

=for object Clutter::Script - Loads a scene from UI definition data
=cut

=for position DESCRIPTION

=head1 SYNOPSIS

    my $ui =<<END_UI;
    {
      "id"     : "red-button",
      "type"   : "ClutterRectangle",
      "width"  : 100,
      "height" : 100,
      "color"  : "#ff0000ff"
    }
    END_UI

    my $script = Clutter::Script->new();

    $script->load_from_file('scene.json');
    $script->load_from_data($ui);

    my $stage = $script->get_object('stage');

    $stage->show();

=head1 DESCRIPTION

B<Clutter::Script> is an object used for loading and building parts or a
complete scenegraph from external definition data in forms of string
buffers or files.

The UI definition format is JSON, the JavaScript Object Notation as
described by RFC 4627. Clutter::Script can load a JSON data stream,
parse it and build all the objects defined into it. Each object must
have an "id" and a "type" properties defining the name to be used
to retrieve it from Clutter::Script with Clutter::Script::get_object(),
and the class type to be instanciated. Every other attribute will
be mapped to the class properties.

A Clutter::Script holds a reference on every object it creates from
the definition data, except for the stage. Every non-actor object
will be finalized when the Clutter::Script instance holding it will
be finalized, so they need to be referenced by a variable outside of
the scope in order for them to survive.

A simple object might be defined as:

    {
      "id"     : "red-button",
      "type"   : "ClutterRectangle",
      "width"  : 100,
      "height" : 100,
      "color"  : "#ff0000ff"
    }

This will produce a red L<Clutter::Rectangle>, 100x100 pixels wide, and
with a Clutter::Script id of "red-button"; it can be retrieved by calling:

    my $red_button = $script->get_object('red-button');

and then manipulated with the Clutter API. For every object created
using Clutter::Script it is possible to check the id by calling
Clutter::get_script_id().

Packing can be represented using the I<children> member, and passing an
array of objects or ids of objects already defined (but not packed: the
packing rules of Clutter still apply, and an actor cannot be packed
in multiple containers without unparenting it in between).

Behaviours and timelines can also be defined inside a UI definition string:

    {
      "id"          : "rotate-behaviour",
      "type"        : "ClutterBehaviourRotate",
      "angle-start" : 0.0,
      "angle-end"   : 360.0,
      "axis"        : "z-axis",
      "alpha"       : {
        "timeline" : { "duration" : 4000, "fps" : 60, "loop" : true },
        "function" : "sine"
      }
    }

And then to apply a defined behaviour to an actor defined inside the
definition of an actor, the "behaviour" member can be used:

    {
      "id" : "my-rotating-actor",
      "type" : "ClutterTexture",
      ...
      "behaviours" : [ "rotate-behaviour" ]
      ...
    }

A L<Clutter::Alpha> belonging to a L<Clutter::Behaviour> can only be
defined implicitely. A L<Clutter::Timeline> belonging to a L<Clutter::Alpha>
can be either defined implicitely or explicitely. Implicitely defined
L<Clutter::Alpha>s and L<Clutter::Timeline>s can omit the I<id> member, as
well as the I<type> member, but will not be available using
Clutter::Script::get_object() (they can, however, be extracted using the
L<Clutter::Behaviour> and L<Clutter::Alpha> API respectively).

Signal handlers can be defined inside a Clutter UI definition file and
then autoconnected to their respective signals using the
Clutter::Script::connect_signals() function:
  
     ...
     "signals" : [
       { "name" : "button-press-event", "handler" : "on_button_press" },
       {
         "name"    : "foo-signal",
         "handler" : "after_foo",
         "after"   : true
       },
    ],
    ...

Signal handler definitions must have a "name" and a "handler" members;
they can also have the "after" and "swapped" boolean members (for the
signal connection flags %G_CONNECT_AFTER and %G_CONNECT_SWAPPED
tespectively) and the "object" string member for calling
Glib::Signal::connect_object() instead of Glib::Signal::connect().

Clutter reserves the following names, so classes defining properties
through the usual GObject registration process should avoid using these
names to avoid collisions:

    "id"         := the unique name of a ClutterScript object
    "type"       := the class literal name, also used to infer the
                    type function
    "type_func"  := the GType function name, for non-standard classes
    "children"   := an array of names or objects to add as children
    "behaviours" := an array of names or objects to apply to an actor
    "signals"    := an array of signal definitions to connect to an
                    object
    "is-default" := a boolean flag used when defining the stage;
                    if set to "true" the default stage will be used
                    instead of creating a new Clutter::Stage instance

=cut

=for apidoc
Creates a new Clutter::Script
=cut
ClutterScript_noinc *
clutter_script_new (class)
    C_ARGS:
        /* void */

=for apidoc __gerror__
Loads all the object definitions from I<filename>.
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
Loads all the object definitions from I<data>.
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
Returns a list of all the requested objects built by I<script>
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

=for apidoc
=for signature objects = $script->list_objects()
Returns a list of all the objects built by I<script>
=cut
void
clutter_script_list_objects (ClutterScript *script)
    PREINIT:
        GList *objects, *l;
    PPCODE:
        objects = clutter_script_list_objects (script);
        if (objects) {
                EXTEND (SP, g_list_length (objects));
                for (l = objects; l != NULL; l = l->next) {
                        GObject *gobject = l->data;
                        PUSHs (sv_2mortal (newSVGObject (gobject)));
                }
                g_list_free (objects);
        }

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

=for apidoc
If I<gobject> has been built by a L<Clutter::Script>, this method returns
the script id of the object.
=cut
const gchar_ornull *
get_script_id (GObject *gobject)
    CODE:
        RETVAL = clutter_get_script_id (gobject);
    OUTPUT:
        RETVAL

