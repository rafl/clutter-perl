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
clutterperl_behaviour_alpha_notify (ClutterBehaviour *behaviour,
                                    guint32           alpha_value)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (behaviour));
        GV *slot = gv_fetchmethod (stash, "ALPHA_NOTIFY");

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 2);
                PUSHs (newSVClutterBehaviour (behaviour));
                PUSHs (sv_2mortal (newSVuv (alpha_value)));

                PUTBACK;
                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);

                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_behaviour_class_init (ClutterBehaviourClass *klass)
{
        klass->alpha_notify = clutterperl_behaviour_alpha_notify;
}

static GPerlCallback *
clutterperl_behaviour_foreach_func_create (SV *func, SV *data)
{
        GType param_types[] = {
                CLUTTER_TYPE_BEHAVIOUR,
                CLUTTER_TYPE_ACTOR,
        };
        guint n_param_types = G_N_ELEMENTS (param_types);

        return gperl_callback_new (func, data, n_param_types, param_types, 0);
}

static void
clutterperl_behaviour_foreach_func (ClutterBehaviour *behaviour,
                                    ClutterActor     *actor,
                                    gpointer          data)
{
        gperl_callback_invoke ((GPerlCallback *) data, NULL,
                               behaviour,
                               actor);
}


MODULE = Clutter::Behaviour     PACKAGE = Clutter::Behaviour    PREFIX = clutter_behaviour_

=for position DESCRIPTION

=head1 DESCRIPTION

B<Clutter::Behaviour> is the base class for objects controlling the behaviour
of actors.  These objects are used primarily to drive a set of actors
depending on the position on a timeline, using an "alpha" function; the
alpha function is held by the L<Clutter::Alpha> object, which automatically
binds a L<Clutter::Timeline> to the function.

=cut

=for position post_enums

=head1 DERIVING NEW BEHAVIOURS

Clutter provides various behaviours, like L<Clutter::Behaviour::Opacity>,
L<Clutter::Behaviour::Path> and L<Clutter::Behaviour::Scale>. You may derive a
new behaviour from any of these, or directly from the Clutter::Behaviour
class itself.

The new behaviour must be a GObject, so you must follow the normal procedure
for creating a new Glib::Object (i.e., either using the Glib::Object::Subclass
pragmatic module or by directly calling the Glib::Type::register_object
function).  The new subclass can customize the behaviour by providing a new
implementation of the following method:

=over

=item B<ALPHA_NOTIFY ($behaviour, $alpha_value)>

=over

=item o $behaviour (Clutter::Behaviour)

=item o $alpha_value (integer) The value computed by the alpha function

=back

This is called each time the value of the alpha function held by the
L<Clutter::Alpha> object bound to the behaviour changes.  You should update
the property, or the properties, of the actors controlled by your behaviour
using I<alpha_value>, scaled accordingly.

=back

=cut

void
clutter_behaviour_apply (ClutterBehaviour *behaviour, ClutterActor *actor)

void
clutter_behaviour_remove (ClutterBehaviour *behaviour, ClutterActor *actor)

void
clutter_behaviour_remove_all (ClutterBehaviour *behaviour)

gboolean
clutter_behaviour_is_applied (ClutterBehaviour *behaviour, ClutterActor *actor)

void
clutter_behaviour_actors_foreach (behaviour, func, data)
        ClutterBehaviour *behaviour
        SV *func
        SV *data
    PREINIT:
        GPerlCallback *callback;
    CODE:
        callback = clutterperl_behaviour_foreach_func_create (func, data);
        clutter_behaviour_actors_foreach (behaviour,
                                          clutterperl_behaviour_foreach_func,
                                          callback);
        gperl_callback_destroy (callback);

=for apidoc
=for signature actors = $behaviour->get_actors
=cut
void
clutter_behaviour_get_actors (ClutterBehaviour *behaviour)
    PREINIT:
        GSList *actors, *l;
    PPCODE:
        actors = clutter_behaviour_get_actors (behaviour);
        for (l = actors; l != NULL; l = l->next) {
                ClutterActor *actor = l->data;
                XPUSHs (sv_2mortal (newSVClutterActor (actor)));
        }
        g_slist_free (actors);

gint
clutter_behaviour_get_n_actors (ClutterBehaviour *behaviour)

ClutterActor *
clutter_behaviour_get_nth_actor (ClutterBehaviour *behaviour, gint index)

ClutterAlpha *
clutter_behaviour_get_alpha (ClutterBehaviour *behaviour)

void
clutter_behaviour_set_alpha (ClutterBehaviour *behaviour, ClutterAlpha *alpha)

=for apidoc Clutter::Behaviour::_INSTALL_OVERRIDES __hide__
=cut

void
_INSTALL_OVERRIDES (const char *package)
    PREINIT:
        GType gtype;
        ClutterBehaviourClass *klass;
    CODE:
        gtype = gperl_object_type_from_package (package);
        if (!gtype) {
                croak ("package `%s' is not registered with Clutter-Perl",
                       package);
        }
        if (!g_type_is_a (gtype, CLUTTER_TYPE_BEHAVIOUR)) {
                croak ("package `%s'(%s) is not a Clutter::Behaviour",
                       package, g_type_name (gtype));
        }
        klass = g_type_class_peek (gtype);
        if (!klass) {
                croak ("INTERNAL ERROR: can't peek a type class for %s (%d)",
                       g_type_name (gtype), gtype);
        }
        clutterperl_behaviour_class_init (klass);

## allow chain up of the parent's alpha_notify vfunc

=for apidoc Clutter::Behaviour::ALPHA_NOTIFY __hide__
=cut

void
ALPHA_NOTIFY (ClutterBehaviour *behaviour, guint32 alpha_value)
    PREINIT:
        ClutterBehaviourClass *klass;
        GType thisclass, parent_class;
        SV *saveddefsv;
    CODE:
        saveddefsv = newSVsv (DEFSV);
        eval_pv ("$_ = caller;", 0);
        thisclass = gperl_type_from_package (SvPV_nolen (DEFSV));
        SvSetSV (DEFSV, saveddefsv);
        if (!thisclass)
                thisclass = G_OBJECT_TYPE (behaviour);
        parent_class = g_type_parent (thisclass);
        if (!g_type_is_a (parent_class, CLUTTER_TYPE_BEHAVIOUR)) {
                croak ("parent of %s is not a Clutter::Behaviour",
                       g_type_name (thisclass));
        }
        klass = g_type_class_peek (parent_class);
        if (klass->alpha_notify) {
                klass->alpha_notify (behaviour, alpha_value);
        }
