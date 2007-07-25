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

ClutterActor *
clutter_group_new (class)
    C_ARGS:
        /* void */

void
clutter_group_remove_all (ClutterGroup *group)

ClutterActor *
clutter_group_find_child_by_id (ClutterGroup *group, guint id)

gint
clutter_group_get_n_children (ClutterGroup *group)

ClutterActor *
clutter_group_get_nth_child (ClutterGroup *group, gint index)

void
clutter_group_raise (ClutterGroup *group, ClutterActor *actor, ClutterActor *sibling)

void
clutter_group_lower (ClutterGroup *group, ClutterActor *actor, ClutterActor *sibling)

void
clutter_group_sort_depth_order (ClutterGroup *group)
