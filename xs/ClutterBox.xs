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
clutter_box_set_color (ClutterBox *box, const ClutterColor *color)

ClutterColor_copy *
clutter_box_get_color (ClutterBox *box)
    PREINIT:
        ClutterColor color = { 0, };
    CODE:
        clutter_box_get_color (box, &color);
        RETVAL = &color;
    OUTPUT:
        RETVAL

void
clutter_box_set_margin (ClutterBox *box, const ClutterMargin *margin)

ClutterMargin_copy *
clutter_box_get_margin (ClutterBox *box)
    PREINIT:
        ClutterMargin margin = { 0, };
    CODE:
        clutter_box_get_margin (box, &margin);
        RETVAL = &margin;
    OUTPUT:
        RETVAL

void
clutter_box_set_default_padding (box, top=0, right=0, bottom=0, left=0)
        ClutterBox *box
        gint top
        gint right
        gint bottom
        gint left

=for apidoc
=for signature (top, right, bottom, left) = $box->get_default_padding
=cut
void
clutter_box_get_default_padding (ClutterBox *box)
    PREINIT:
        gint top, right, bottom, left;
    PPCODE:
        clutter_box_get_default_padding (box, &top, &right, &bottom, &left);
        EXTEND (SP, 4);
        PUSHs (sv_2mortal (newSViv (top)));
        PUSHs (sv_2mortal (newSViv (right)));
        PUSHs (sv_2mortal (newSViv (bottom)));
        PUSHs (sv_2mortal (newSViv (left)));

void
clutter_box_pack_defaults (ClutterBox *box, ClutterActor *actor)

void
clutter_box_pack (box, actor, pack_type, padding)
        ClutterBox *box
        ClutterActor *actor
        ClutterPackType pack_type
        ClutterPadding *padding

void
clutter_box_remove_all (ClutterBox *box)

=for apidoc
=for signature (actor, coords, pack_type, padding) = $box->query_child ($actor)
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
            EXTEND (SP, 4);
            PUSHs (sv_2mortal (newSVClutterActor_noinc (query.actor)));
            PUSHs (sv_2mortal (newSVClutterActorBox (&(query.child_coords))));
            PUSHs (sv_2mortal (newSVClutterPackType (query.pack_type)));
            PUSHs (sv_2mortal (newSVClutterPadding (&(query.padding))));
          }

=for apidoc
=for signature (actor, pack_type) = $box->query_nth_child ($index)
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
            EXTEND (SP, 4);
            PUSHs (sv_2mortal (newSVClutterActor_noinc (query.actor)));
            PUSHs (sv_2mortal (newSVClutterActorBox (&(query.child_coords))));
            PUSHs (sv_2mortal (newSVClutterPackType (query.pack_type)));
            PUSHs (sv_2mortal (newSVClutterPadding (&(query.padding))));
          }
