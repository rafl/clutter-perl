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
clutterperl_actor_paint (ClutterActor *actor)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (actor));
        GV *slot = gv_fetchmethod (stash, "PAINT");

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 1);
                PUSHs (newSVClutterActor (actor));
                
                PUTBACK;

                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);

                SPAGAIN;

                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_actor_request_coords (ClutterActor    *actor,
                                  ClutterActorBox *box)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (actor));
        GV *slot = gv_fetchmethod (stash, "REQUEST_COORDS");

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 2);
                PUSHs (newSVClutterActor (actor));
                PUSHs (sv_2mortal (newSVClutterActorBox (box)));
                
                PUTBACK;
                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);
                SPAGAIN;

                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_actor_query_coords (ClutterActor    *actor,
                                ClutterActorBox *box)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (actor));
        GV *slot = gv_fetchmethod (stash, "QUERY_COORDS");
        int count, i;

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 1);
                PUSHs (newSVClutterActor (actor));

                PUTBACK;
                count = call_sv ((SV *) GvCV (slot), G_ARRAY);
                SPAGAIN;

                if (count != 4)
                        croak ("QUERY_COORDS must return an array with "
                               "four items -- (x1, y1, x2, y2)");

                if (box) {
                        box->y2 = POPi;
                        box->x2 = POPi;
                        box->y1 = POPi;
                        box->x1 = POPi;
                }

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_actor_class_init (ClutterActorClass *klass)
{
        klass->paint = clutterperl_actor_paint;
        klass->request_coords = clutterperl_actor_request_coords;
        klass->query_coords = clutterperl_actor_query_coords;
}

static void
clutterperl_actor_sink (GObject *object)
{
  /* if only we had a g_initially_unowned_sink() */
  g_object_ref_sink (object);
  g_object_unref (object);
}

MODULE = Clutter::Actor		PACKAGE = Clutter::Actor	PREFIX = clutter_actor_

BOOT:
        /* we need to use our own homegrown sink function, since we do not
         * provide it inside the C library (you can use the usual GObject
         * API in there) but we need a single entry point in the bindings.
         * so, here it is where we register it
         */
        gperl_register_sink_func (CLUTTER_TYPE_ACTOR, clutterperl_actor_sink);

=for position DESCRIPTION

Clutter::Actor is the base class for actors. An actor in Clutter is a single
entity on the L<Clutter::Stage>; it has style and positional attributes, which
can be directly accessed and modified, or can be controlled using a subclass
of L<Clutter::Behaviour>.

=cut

=for position post_enums

=head1 DERIVING NEW ACTORS

Clutter provides some default actors. You may derive a new actor from any of
these, or directly from the Clutter::Actor class itself.

The new actor must be a GObject, so you must follow the normal procedure
for creating a new Glib::Obect (i.e., either L<Glib::Object::Subclass> or
C<Glib::Type::register_object>).

If you want to control the size allocation and request for the newly created
actor class, you should provide a new implementation of the following methods:

=over

=item PAINT ($actor)

=over

=item o $actor (Clutter::Actor)

=back

This is called each time the actor needs to be painted. You can call native
GL calls using Perl bindings for the OpenGL API.

=item REQUEST_COORDS ($actor, $box)

=over

=item o $actor (Clutter::Actor)

=item o $box (Clutter::ActorBox)

=back

This is called each time the user requests the actor to update its coordinates
and size. The I<box> contains the upper left and lower right coordinates of the
box surrounding the actor.

=item  (x1, y1, x2, y2) = QUERY_COORDS ($actor)

=over

=item o $actor (Clutter::Actor)

=back

This is called each time the actor is queried for its coordinates and size.
The returned array must contains the upper left and lower right coordinates of
the box surrounding the actor, in coordinates relative to the actor's parent.

=back

=cut

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
        Clutter::Actor::show_all     = 8
        Clutter::Actor::hide_all     = 9
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
		case 8: clutter_actor_show_all     (actor); break;
		case 9: clutter_actor_hide_all     (actor); break;
		default:
			g_assert_not_reached ();
	}

void
clutter_actor_request_coords (ClutterActor *actor, ClutterActorBox *box)

ClutterActorBox_copy *
clutter_actor_query_coords (ClutterActor *actor)
    PREINIT:
        ClutterActorBox box;
    CODE:
        clutter_actor_query_coords (actor, &box);
        RETVAL = &box;
    OUTPUT:
        RETVAL

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

void
clutter_actor_set_width (ClutterActor *actor, guint width)

guint
clutter_actor_get_width (ClutterActor *actor)

void
clutter_actor_set_height (ClutterActor *actor, guint height)

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
clutter_actor_reparent (ClutterActor *actor, ClutterActor *new_parent)

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

void
clutter_actor_set_scale (ClutterActor *actor, gdouble scale_x, gdouble scale_y)

=for apidoc
=for signature (scale_x, scale_y) = $actor->get_scale
=cut
void
clutter_actor_get_scale (ClutterActor *actor)
    PREINIT:
        gdouble scale_x, scale_y;
    PPCODE:
        clutter_actor_get_scale (actor, &scale_x, &scale_y);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVnv (scale_x)));
        PUSHs (sv_2mortal (newSVnv (scale_y)));

=for apidoc
=for signature (width, height) = $actor->get_abs_size
=cut
void
clutter_actor_get_abs_size (ClutterActor *actor)
    PREINIT:
        guint width, height;
    PPCODE:
        clutter_actor_get_abs_size (actor, &width, &height);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVuv (width)));
        PUSHs (sv_2mortal (newSVuv (height)));

=for apidoc
=for signature (width, height) = $actor->get_size
=cut
void
clutter_actor_get_size (ClutterActor *actor)
    PREINIT:
        guint width, height;
    PPCODE:
        clutter_actor_get_size (actor, &width, &height);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVuv (width)));
        PUSHs (sv_2mortal (newSVuv (height)));

void
clutter_actor_move_by (ClutterActor *actor, gint dx, gint dy)

void
clutter_actor_pick (ClutterActor *actor, ClutterColor *color)

void
clutter_actor_set_scale_with_gravity (actor, scale_x, scale_y, gravity)
        ClutterActor *actor
        gdouble scale_x
        gdouble scale_y
        ClutterGravity gravity

=for apidoc
=for signature vertices = $actor->get_vertices
Returns an array of four Clutter::Vertex objects containing to the
vertices of $actor
=cut
void
clutter_actor_get_vertices (ClutterActor *actor)
    PREINIT:
        ClutterVertex vertices[4];
    PPCODE:
        clutter_actor_get_vertices (actor, vertices);
        EXTEND (SP, 4);
        PUSHs (sv_2mortal (newSVClutterVertex (&vertices[0])));
        PUSHs (sv_2mortal (newSVClutterVertex (&vertices[1])));
        PUSHs (sv_2mortal (newSVClutterVertex (&vertices[2])));
        PUSHs (sv_2mortal (newSVClutterVertex (&vertices[3])));

ClutterVertex_copy *
clutter_actor_apply_transform_to_point (ClutterActor *actor, ClutterVertex *vertex)
    PREINIT:
        ClutterVertex transformed;
    CODE:
        clutter_actor_apply_transform_to_point (actor, vertex, &transformed);
        RETVAL = &transformed;
    OUTPUT:
        RETVAL

=for apidoc Clutter::Actor::_INSTALL_OVERRIDES __hide__
=cut

void
_INSTALL_OVERRIDES (const char *package)
    PREINIT:
        GType gtype;
        ClutterActorClass *klass;
    CODE:
        gtype = gperl_object_type_from_package (package);
        if (!gtype) {
                croak("package `%s' is not registered with Clutter-Perl",
                      package);
        }
        if (!g_type_is_a (gtype, CLUTTER_TYPE_ACTOR)) {
                croak("package `%s' (%s) is not a Clutter::Actor",
                      package, g_type_name (gtype));
        }
        klass = g_type_class_peek (gtype);
        if (!klass) {
                croak("INTERNAL ERROR: can't peek a type class for `%s' (%d)",
                      g_type_name (gtype), gtype);
        }
        clutterperl_actor_class_init (klass);

## allow chaining up to the parent's methods from a perl subclass

=for apidoc Clutter::Actor::PAINT __hide__
=cut

=for apidoc Clutter::Actor::REQUEST_COORDS __hide__
=cut

=for apidoc Clutter::Actor::ALLOCATE_COORDS __hide__
=cut

void
PAINT (ClutterActor *actor)
    PREINIT:
        ClutterActorClass *klass;
        GType thisclass, parent_class;
        SV *saveddefsv;
    CODE:
        saveddefsv = newSVsv (DEFSV);
        eval_pv ("$_ = caller;", 0);
        thisclass = gperl_type_from_package (SvPV_nolen (DEFSV));
        SvSetSV (DEFSV, saveddefsv);
        if (!thisclass)
                thisclass = G_OBJECT_TYPE (actor);
        parent_class = g_type_parent (thisclass);
        if (!g_type_is_a (parent_class, CLUTTER_TYPE_ACTOR)) {
                croak ("parent of %s is not a Clutter::Actor",
                       g_type_name (thisclass));
        }
        klass = g_type_class_peek (parent_class);
        if (klass->paint) {
                klass->paint (actor);
        }

void
REQUEST_COORDS (ClutterActor *actor, ClutterActorBox *box)
    PREINIT:
        ClutterActorClass *klass;
        GType thisclass, parent_class;
        SV *saveddefsv;
    CODE:
        saveddefsv = newSVsv (DEFSV);
        eval_pv ("$_ = caller;", 0);
        thisclass = gperl_type_from_package (SvPV_nolen (DEFSV));
        SvSetSV (DEFSV, saveddefsv);
        if (!thisclass)
                thisclass = G_OBJECT_TYPE (actor);
        parent_class = g_type_parent (thisclass);
        if (!g_type_is_a (parent_class, CLUTTER_TYPE_ACTOR)) {
                croak ("parent of %s is not a Clutter::Actor",
                       g_type_name (thisclass));
        }
        klass = g_type_class_peek (parent_class);
        if (klass->request_coords) {
                klass->request_coords (actor, box);
        }

void
QUERY_COORDS (ClutterActor *actor, ClutterActorBox *box)
    PREINIT:
        ClutterActorClass *klass;
        GType thisclass, parent_class;
        SV *saveddefsv;
    CODE:
        saveddefsv = newSVsv (DEFSV);
        eval_pv ("$_ = caller;", 0);
        thisclass = gperl_type_from_package (SvPV_nolen (DEFSV));
        SvSetSV (DEFSV, saveddefsv);
        if (!thisclass)
                thisclass = G_OBJECT_TYPE (actor);
        parent_class = g_type_parent (thisclass);
        if (!g_type_is_a (parent_class, CLUTTER_TYPE_ACTOR)) {
                croak ("parent of %s is not a Clutter::Actor",
                       g_type_name (thisclass));
        }
        klass = g_type_class_peek (parent_class);
        if (klass->query_coords) {
                klass->query_coords (actor, box);
        }
