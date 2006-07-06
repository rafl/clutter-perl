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
clutterperl_group_foreach_callback (ClutterActor  *actor,
				    GPerlCallback *callback)
{
	gperl_callback_invoke (callback, NULL, actor);
}


MODULE = Clutter::Group		PACKAGE = Clutter::Group	PREFIX = clutter_group_

ClutterActor *
clutter_group_new (class)
    C_ARGS:
        /* void */

=for apidoc
=for signature list = $group->get_children
=cut
void
clutter_group_get_children (ClutterGroup *group)
    PREINIT:
        GList *children = NULL, *l;
    PPCODE:
        children = clutter_group_get_children (group);
	
	for (l = children; l != NULL; l = l->next)
		XPUSHs (sv_2mortal (newSVClutterActor (l->data)));
	
	if (children)
		g_list_free (children);

## void
## clutter_group_add_many (ClutterGroup *group, ClutterActor *actor, ...)

=for apidoc
=for arg actor (__hide__)
=for arg ... list of actors
=cut
void
clutter_group_add (ClutterGroup *group, ClutterActor *actor, ...)
    PREINIT:
        int i;
    CODE:
    	clutter_group_add (group, actor);
	for (i = 2; i < items; i++)
		clutter_group_add (group, SvClutterActor (ST (i)));

void
clutter_group_remove (ClutterGroup *group, ClutterActor *actor)

void
clutter_group_show_all (ClutterGroup *group)

void
clutter_group_hide_all (ClutterGroup *group)

ClutterActor_noinc *
clutter_group_find_child_by_id (ClutterGroup *group, guint id)

void
clutter_group_raise (ClutterGroup *group, ClutterActor *actor, ClutterActor *sibling)

void
clutter_group_lower (ClutterGroup *group, ClutterActor *actor, ClutterActor *sibling)

void
clutter_group_sort_depth_order (ClutterGroup *group)

void
clutter_group_foreach (ClutterGroup *group, SV *callback, SV *callback_data=NULL)
    PREINIT:
    	GPerlCallback *real_callback;
	GType param_types [1];
    CODE:
	param_types[0] = CLUTTER_TYPE_ACTOR;
	real_callback = gperl_callback_new (callback, callback_data,
                                            1, param_types,
					    G_TYPE_NONE);
	clutter_group_foreach (group,
                               (ClutterCallback) clutterperl_group_foreach_callback,
                               real_callback);
	gperl_callback_destroy (real_callback);
