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

static GPerlCallback *
clutterperl_behaviour_foreach_func_create (SV *func, SV *data)
{
        GType param_types[1] = { CLUTTER_TYPE_ACTOR, };
        return gperl_callback_new (func, data, 1, param_types, 0);
}

static void
clutterperl_behaviour_foreach_func (ClutterActor *actor,
                                    gpointer      data)
{
        gperl_callback_invoke ((GPerlCallback *) data, NULL, actor);
}


MODULE = Clutter::Behaviour     PACKAGE = Clutter::Behaviour    PREFIX = clutter_behaviour_

void
clutter_behaviour_apply (ClutterBehaviour *behaviour, ClutterActor *actor)

void
clutter_behaviour_remove (ClutterBehaviour *behaviour, ClutterActor *actor)

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
                                          (GFunc) clutterperl_behaviour_foreach_func,
                                          callback);
        gperl_callback_destroy (callback);

ClutterAlpha *
clutter_behaviour_get_alpha (ClutterBehaviour *behaviour)

void
clutter_behaviour_set_alpha (ClutterBehaviour *behaviour, ClutterAlpha *alpha)
