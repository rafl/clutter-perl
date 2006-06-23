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

MODULE = Clutter::Group		PACKAGE = Clutter::Group	PREFIX = clutter_group_

ClutterGroup_noinc *
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
	if (!children)
		return;
	for (l = children; l != NULL; l = l->next)
		XPUSHs (sv_2mortal (newSVClutterActor (l->data)));
	g_list_free (children);

## void
## clutter_group_add (ClutterGroup *group, ClutterActor *actor)

=for apidoc
=for arg actor (__hide__)
=for arg ... list of actors
=cut
void
clutter_group_add_many (ClutterGroup *group, ClutterActor *actor, ...)
    PREINIT:
        int i;
    CODE:
    	clutter_group_add (group, actor);
	for (i = 2; i < items; i++)
		clutter_group_add (group, SvClutterActor (ST (i)));
