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

MODULE = Clutter::Actor		PACKAGE = Clutter::Actor	PREFIX = clutter_actor_


=for apidoc Clutter::Actor::realized
=for signature $actor->realized ($boolean)
=for signature boolean = $actor->realized
=for arg ... (__hide__)
=cut

=for apidoc Clutter::Actor::mapped
=for signature $actor->mapped ($boolean)
=for signature boolean = $actor->mapped
=for arg ... (__hide__)
=cut

=for apidoc Clutter::Actor::visible
=for signature $actor->visible ($boolean)
=for signatur boolean = $actor->visible
=for arg ... (__hide__)
=cut

gboolean
realized (actor, ...)
	ClutterActor *actor
    ALIAS:
        Clutter::Actor::realized = 0
        Clutter::Actor::mapped   = 1
	Clutter::Actor::visible  = 2
    PREINIT:
        gboolean value = FALSE;
	ClutterActorFlags flag = 0;
    CODE:
        if (items > 2) {
		croak ("Usage: boolean = $actor->%s\n"
		       "       $actor->%s (newvalue)\n"
		       "   too many arguments",
		       GvNAME (CvGV (cv)),
		       GvNAME (CvGV (cv)));
	}

	if (items == 1) {
		switch (ix) {
			case 0: RETVAL = CLUTTER_ACTOR_IS_REALIZED (actor); break;
			case 1: RETVAL = CLUTTER_ACTOR_IS_MAPPED   (actor); break;
			case 2: RETVAL = CLUTTER_ACTOR_IS_VISIBLE  (actor); break;
			default:
				RETVAL = FALSE;
				g_assert_not_reached ();
		}
	}
	else {
		value = (gboolean) SvIV (ST (1));
		switch (ix) {
			case 0: flag = CLUTTER_ACTOR_REALIZED; break;
			case 1: flag = CLUTTER_ACTOR_MAPPED;   break;
			case 2: croak ("actor flag visible is read only"); break;
			default:
				flag = FALSE;
				g_assert_not_reached ();
		}
		if (value) {
			CLUTTER_ACTOR_SET_FLAGS (actor, flag);
		}
		else {
			CLUTTER_ACTOR_UNSET_FLAGS (actor, flag);
		}
		RETVAL = value;
	}
    OUTPUT:
        RETVAL

ClutterActorFlags
flags (ClutterActor *actor)
    ALIAS:
        get_flags = 1
    CODE:
        PERL_UNUSED_VAR (ix);
	RETVAL = actor->flags;
    OUTPUT:
        RETVAL

void
set_flags (ClutterActor *actor, ClutterActorFlags flags)
    CODE:
        CLUTTER_ACTOR_SET_FLAGS (actor, flags);

void
unset_flags (ClutterActor *actor, ClutterActorFlags flags)
    CODE:
        CLUTTER_ACTOR_UNSET_FLAGS (actor, flags);

## factoring out all the methods with signature
##    void $actor->method (void)
## results in shaving off some kB from the resulting (stripped) object
## file on i686.
void
show (ClutterActor *actor)
    ALIAS:
        Clutter::Actor::hide         = 1
	Clutter::Actor::realize      = 2
	Clutter::Actor::unrealize    = 3
	Clutter::Actor::paint        = 4
	Clutter::Actor::queue_redraw = 5
	Clutter::Actor::destroy      = 6
	Clutter::Actor::unparent     = 7
    CODE:
        switch (ix) {
		case 0: clutter_actor_show         (actor); break;
		case 1: clutter_actor_hide         (actor); break;
		case 2: clutter_actor_realize      (actor); break;
		case 3: clutter_actor_unrealize    (actor); break;
		case 4: clutter_actor_paint        (actor); break;
		case 5: clutter_actor_queue_redraw (actor); break;
	        case 6: clutter_actor_destroy      (actor); break;
		case 7: clutter_actor_unparent     (actor); break;
		default:
			g_assert_not_reached ();
	}

void
clutter_actor_request_coords (ClutterActor *actor, ClutterActorBox *box)

void
clutter_actor_allocate_coords (ClutterActor *actor, ClutterActorBox *box)

void
clutter_actor_set_geometry (ClutterActor *actor, ClutterGeometry *geom)

ClutterGeometry_copy *
clutter_actor_get_geometry (ClutterActor *actor)
    PREINIT:
        ClutterGeometry geom;
    CODE:
        clutter_actor_get_geometry (actor, &geom);
	RETVAL = &geom;
    OUTPUT:
        RETVAL

=for apidoc
=for signature (x1, y1, x2, y2) = $actor->get_coords
=cut
void
clutter_actor_get_coords (ClutterActor *actor)
    PREINIT:
        gint x1, y1;
	gint x2, y2;
    PPCODE:
        clutter_actor_get_coords (actor, &x1, &y1, &x2, &y2);
	EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSViv (x1)));
	PUSHs (sv_2mortal (newSViv (y1)));
	PUSHs (sv_2mortal (newSViv (x2)));
	PUSHs (sv_2mortal (newSViv (y2)));

void
clutter_actor_set_position (ClutterActor *actor, gint x, gint y)

void
clutter_actor_set_size (ClutterActor *actor, gint width, gint height)

=for apidoc
=for signature (x, y) = $actor->get_abs_position
=cut
void
clutter_actor_get_abs_position (ClutterActor *actor)
    PREINIT:
        gint x, y;
    PPCODE:
        clutter_actor_get_abs_position (actor, &x, &y);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (x)));
	PUSHs (sv_2mortal (newSViv (y)));

guint
clutter_actor_get_width (ClutterActor *actor)

guint
clutter_actor_get_height (ClutterActor *actor)

gint
clutter_actor_get_x (ClutterActor *actor)

gint
clutter_actor_get_y (ClutterActor *actor)

void
clutter_actor_rotate_z (ClutterActor *actor, gfloat angle, gint x, gint y)

void
clutter_actor_rotate_x (ClutterActor *actor, gfloat angle, gint y, gint z)

void
clutter_actor_rotate_y (ClutterActor *actor, gfloat angle, gint x, gint z)

void
clutter_actor_set_opacity (ClutterActor *actor, guint8 opacity)

guint8
clutter_actor_get_opacity (ClutterActor *actor)

void
clutter_actor_set_name (ClutterActor *actor, const gchar *id)

const gchar *
clutter_actor_get_name (ClutterActor *actor)

guint32
clutter_actor_get_id (ClutterActor *actor)

void
clutter_actor_set_clip (ClutterActor *actor, gint xoff, gint yoff, gint width, gint height)

void
clutter_actor_remove_clip (ClutterActor *actor)

gboolean
clutter_actor_has_clip (ClutterActor *actor)

void
clutter_actor_set_parent (ClutterActor *actor, ClutterActor *parent)

ClutterActor_ornull *
clutter_actor_get_parent (ClutterActor *actor)

void
clutter_actor_raise (ClutterActor *actor, ClutterActor *below)

void
clutter_actor_lower (ClutterActor *actor, ClutterActor *above)

void
clutter_actor_raise_top (ClutterActor *actor)

void
clutter_actor_lower_bottom (ClutterActor *actor)

void
clutter_actor_set_depth (ClutterActor *actor, gint depth)

gint
clutter_actor_get_depth (ClutterActor *actor)
