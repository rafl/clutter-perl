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

MODULE = Clutter::Box   PACKAGE = Clutter::Box  PREFIX = clutter_box_

=for enum Clutter::PackType
=cut

void
clutter_box_set_spacing (ClutterBox *box, guint spacing)

guint
clutter_box_get_spacing (ClutterBox *box)

void
clutter_box_pack_start (ClutterBox *box, ClutterActor *actor)

void
clutter_box_pack_end (ClutterBox *box, ClutterActor *actor)

=for apidoc
=for signature (actor, pack_type) = $box->query_child ($actor)
Queries I<box> for its child. If I<actor> is a child of I<box>, a list
containing a reference to the actor and the pack type is returned.
=cut
void
clutter_box_query_child (ClutterBox *box, ClutterActor *actor)
    PREINIT:
        ClutterBoxChild query;
    PPCODE:
        if (clutter_box_query_child (box, actor, &query))
          {
            EXTEND (SP, 2);
            PUSHs (sv_2mortal (newSVClutterActor_noinc (query.actor)));
            PUSHs (sv_2mortal (newSVClutterPackType (query.pack_type)));
          }

=for apidoc
=for signature (actor, pack_type) = $box->query_child ($index)
=for arg index (integer)
Queries I<box> for its child at I<index>.
=cut
void
clutter_box_query_nth_child (ClutterBox *box, guint index)
    PREINIT:
        ClutterBoxChild query;
    PPCODE:
        if (clutter_box_query_nth_child (box, index, &query))
          {
            EXTEND (SP, 2);
            PUSHs (sv_2mortal (newSVClutterActor_noinc (query.actor)));
            PUSHs (sv_2mortal (newSVClutterPackType (query.pack_type)));
          }
