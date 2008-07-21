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
clutterperl_actor_show_all (ClutterActor *actor)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (actor));
        GV *slot = gv_fetchmethod (stash, "SHOW_ALL");

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                PUSHs (newSVClutterActor (actor));
                
                PUTBACK;
                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);
                SPAGAIN;

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_actor_hide_all (ClutterActor *actor)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (actor));
        GV *slot = gv_fetchmethod (stash, "HIDE_ALL");

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                PUSHs (newSVClutterActor (actor));
                
                PUTBACK;
                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);
                SPAGAIN;

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

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

                PUSHs (newSVClutterActor (actor));
                
                PUTBACK;
                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);
                SPAGAIN;

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_actor_allocate (ClutterActor          *actor,
                            const ClutterActorBox *box,
                            gboolean               origin_changed)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (actor));
        GV *slot = gv_fetchmethod (stash, "ALLOCATE");

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 3);
                PUSHs (newSVClutterActor (actor));
                PUSHs (sv_2mortal (newSVClutterActorBox (box)));
                PUSHs (sv_2mortal (newSViv (origin_changed)));
                
                PUTBACK;
                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);
                SPAGAIN;

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_actor_get_preferred_width (ClutterActor *actor,
                                       ClutterUnit   for_height,
                                       ClutterUnit  *min_width_p,
                                       ClutterUnit  *natural_width_p)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (actor));
        GV *slot = gv_fetchmethod (stash, "GET_PREFERRED_WIDTH");
        int count;

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 2);
                PUSHs (newSVClutterActor (actor));
                PUSHs (newSViv (for_height));

                PUTBACK;
                count = call_sv ((SV *) GvCV (slot), G_ARRAY);
                SPAGAIN;

                if (count != 2)
                        croak ("GET_PREFERRED_WIDTH must return an array "
                               "with two items -- (min_width, natural_width)");

                if (natural_width_p)
                        *natural_width_p = POPi;

                if (min_width_p)
                        *min_width_p = POPi;

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_actor_get_preferred_height (ClutterActor *actor,
                                        ClutterUnit   for_width,
                                        ClutterUnit  *min_height_p,
                                        ClutterUnit  *natural_height_p)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (actor));
        GV *slot = gv_fetchmethod (stash, "GET_PREFERRED_HEIGHT");
        int count;

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 2);
                PUSHs (newSVClutterActor (actor));
                PUSHs (newSViv (for_width));

                PUTBACK;
                count = call_sv ((SV *) GvCV (slot), G_ARRAY);
                SPAGAIN;

                if (count != 2)
                        croak ("GET_PREFERRED_HEIGHT must return an array "
                               "with two items -- (min_height, natural_height)");

                if (natural_height_p)
                        *natural_height_p = POPi;

                if (min_height_p)
                        *min_height_p = POPi;

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_actor_realize (ClutterActor *actor)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (actor));
        GV *slot = gv_fetchmethod (stash, "REALIZE");

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                PUSHs (newSVClutterActor (actor));
                
                PUTBACK;
                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);
                SPAGAIN;

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_actor_unrealize (ClutterActor *actor)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (actor));
        GV *slot = gv_fetchmethod (stash, "UNREALIZE");

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                PUSHs (newSVClutterActor (actor));
                
                PUTBACK;
                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);
                SPAGAIN;

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_actor_pick (ClutterActor       *actor,
                        const ClutterColor *pick_color)
{
        HV *stash = gperl_object_stash_from_type (G_OBJECT_TYPE (actor));
        GV *slot = gv_fetchmethod (stash, "PICK");

        if (slot && GvCV (slot)) {
                dSP;

                ENTER;
                SAVETMPS;
                PUSHMARK (SP);

                EXTEND (SP, 2);
                PUSHs (newSVClutterActor (actor));
                PUSHs (newSVClutterColor (pick_color));
                
                PUTBACK;
                call_sv ((SV *) GvCV (slot), G_VOID | G_DISCARD);
                SPAGAIN;

                PUTBACK;
                FREETMPS;
                LEAVE;
        }
}

static void
clutterperl_actor_class_init (ClutterActorClass *klass)
{
        klass->show_all             = clutterperl_actor_show_all;
        klass->hide_all             = clutterperl_actor_hide_all;
        klass->paint                = clutterperl_actor_paint;
        klass->realize              = clutterperl_actor_realize;
        klass->unrealize            = clutterperl_actor_unrealize;
        klass->pick                 = clutterperl_actor_pick;
        klass->allocate             = clutterperl_actor_allocate;
        klass->get_preferred_width  = clutterperl_actor_get_preferred_width;
        klass->get_preferred_height = clutterperl_actor_get_preferred_height;
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

=head1 TRANSFORMATIONS ORDER

The OpenGL modelview matrix for the actor is constructed from the actor
settings by the following order of operations:

=over

=item 1. Translation by actor (x, y) coordinates

=item 2. Scaling by I<scale_x> and I<scale_y>

=item 3. Negative translation by the anchor point (x, y) coordinates

=item 4. Rotation around z axis

=item 5. Rotation around y axis

=item 6. Rotation around x axis

=item 7. Translation by actor depth (z coordinate)

=item 8. Clip stencil is applied

B<Note>: clipping not an operation on the matrix as such, but done as part
of the transformation set up

=back

=head1 EVENT HANDLING

=over

=item Actors emit pointer events only if set reactive

=item The stage is always reactive by default

=item Events are handled by connecting signal handlers to the event signals

Event signals usually have the C< -event > postfix.

=item Event handlers B<must> return I<TRUE> if they handled the event

When an event handler returns I<TRUE> it will interrupt the event emission chain.
Event handlers B<must> return I<FALSE> if the emission should continue instead.

=item If an actor is grabbing events it will be the only receiver

B<Note>: Key focus can be seen a "soft grab"; an actor with key focus will
receive key events even if it's not grabbing them.

=item Keyboard events are emitted if an actor has key focus

B<Note>: By default, the stage has key focus.

=item Motion events (motion, enter, leave) are not emitted if not enabled

B<Note>: Motion events are enabled by default. The motion event is only
emitted by the L<Clutter::Stage> if the motion events delivery is disabled.

=item The event emission has two phases: I<capture> and I<bubble>

An emitted event starts in the I<capture> phase, beginning at the stage and
traversing every child actor until the event source actor is reached. The
emission then enters the I<bubble> phase, traversing back up the chain via
parents until it reaches the stage. Any event handler can abort this chain
by returning I<TRUE> (meaning "event handled")

=item Pointer events will 'pass through' non reactive actors

E.g., if two actors are overlaying, the non reactive actor will be ignored.

=back

=head1 DERIVING NEW ACTORS

Clutter intentionally provides only few default actors. You are encouraged to
derive a new actor from any of these, or directly from the Clutter::Actor class
itself.

The new actor must be a GObject, so you must follow the normal procedure
for creating a new Glib::Obect (i.e., either L<Glib::Object::Subclass> or
C<Glib::Type::register_object>).

If you want to control the size allocation and request for the newly created
actor class, you should provide a new implementation of the following methods:

=over

=item ALLOCATE ($actor, $box, $origin_changed)

=over

=item o $actor (Clutter::Actor)

=item o $box (Clutter::ActorBox)

=item o $origin_changed (boolean)

=back

This is called each time the user requests the actor to update its coordinates
and size. The I<box> contains the upper left and lower right coordinates of the
box surrounding the actor. Every class overriding the C< ALLOCATE >
method B<must> chain up to the parent's class method, using the usual
C< SUPER > mechanism provided by Perl, for instance:

  $actor->SUPER::ALLOCATE($box, $origin_changed);

See L<perlobj>.

=item  (minimum_width, natural_width) = GET_PREFERRED_WIDTH ($actor, $for_height)

=over

=item o $actor (Clutter::Actor)

=item o $for_height (Clutter::Unit)

=back

This is called each time the actor is queried for its preferred width.

The returned array must contains the minimum width and the natural width of
the actor for the given height passed in I<for_height>.

=item  (minimum_height, natural_height) = GET_PREFERRED_HEIGHT ($actor, $for_width)

=over

=item o $actor (Clutter::Actor)

=item o $for_width (Clutter::Unit)

=back

This is called each time the actor is queried for its preferred height.

The returned array must contains the minimum height and the natural height
of the actor for the given width passed in I<for_width>.

=back

Other overridable methods when deriving a C<Clutter::Actor> are:

=over

=item PAINT ($actor)

=over

=item o $actor (Clutter::Actor)

=back

This is called each time the actor needs to be painted. You can call native
GL calls using Perl bindings for the OpenGL API. If you are implementing a
containter actor, or if you are operating transformations on the actor while
painting, you should push the GL matrix first with C< glPushMatrix >, paint
and the pop it back with C< glPopMatrix >; this will allow your children to
follow the same transformations.

=item SHOW_ALL ($actor)

=item HIDE_ALL ($actor)

=over

=item o $actor (Clutter::Actor)

=back

By default, calling C<show_all> and C<hide_all> on a L<Clutter::Group> will
not recurse though its children. A recursive behaviour can be implemented by
overriding this method. This method is also useful for composite actors, where
some non-exposed children should be visible only if certain conditions arise.

=item REALIZE ($actor)

=item UNREALIZE ($actor)

=over

=item o $actor (Clutter::Actor)

=back

Actors might have to allocate resources before being shown for the first
time, for instance GL-specific data. The C< REALIZE > virtual function will
be called by the C< show > method. Inside this function you should set the
C< realized > flag, or chain up to the parent class C< REALIZE > method.

The C< UNREALIZE > virtual function will be called when destroying the
actor, and allows the release of the resources allocated inside C< REALIZE >.

=item PICK ($actor, $pick_color)

=over

=item o $actor (Clutter::Actor)

=item o $pick_color (Clutter::Color)

=back

The C< PICK > virtual function will be called when drawing the scene with
a mask of the actors in order to detect actor at a given pair of coordinates
relative to the stage (see the C<get_actor_at_pos> method of
L<Clutter::Stage>).

The actor should paint its bounding box with the passed I<pick_color>, and
its eventual children should be painted as well by invoking the C<paint>
method. The default implementation of the C< PICK > method is the equivalent
of:

  sub PICK {
    my ($self, $pick_color) = @_;

    glColor4ub($pick_color->red,
               $pick_color->green,
               $pick_color->blue,
               $pick_color->alpha);
    glRecti($self->get_x(),
            $self->get_y(),
            $self->get_x() + $self->get_width(),
            $self->get_y() + $self->get_height());
  }

Which will render the actor as a rectangle the size of its bounding box (Note:
there is no need to override the C< PICK > virtual function in this case).

An actor with internal children, or implementing the L<Clutter::Container>
interface should, instead, use:

  sub PICK {
    my ($self, $pick_color) = @_;

    # chain up to allow picking the container
    $self->SUPER::PICK ($pick_color);

    foreach my $child in ($self->get_children()) {
        $child->paint(); # this will result in the PICK method of
                         # the child being called
    }
  }

=back

=cut

=for apidoc Clutter::Actor::realized
=for signature $actor->realized ($boolean)
=for signature boolean = $actor->realized
=for arg ... (__hide__)
Checks if the actor is realized
=cut

=for apidoc Clutter::Actor::mapped
=for signature $actor->mapped ($boolean)
=for signature boolean = $actor->mapped
=for arg ... (__hide__)
Checks if the actor is mapped
=cut

=for apidoc Clutter::Actor::visible
=for signature $actor->visible ($boolean)
=for signaturs boolean = $actor->visible
=for arg ... (__hide__)
Checks if the actor is both realized and mapped
=cut

=for apidoc Clutter::Actor::reactive
=for signature $actor->reactive ($boolean)
=for signaturs boolean = $actor->reactive
=for arg ... (__hide__)
Checks if the actor is reactive to events
=cut

gboolean
realized (actor, ...)
	ClutterActor *actor
    ALIAS:
        Clutter::Actor::realized = 0
        Clutter::Actor::mapped   = 1
	Clutter::Actor::visible  = 2
        Clutter::Actor::reactive = 3
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
			case 3: RETVAL = CLUTTER_ACTOR_IS_REACTIVE (actor); break;
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
			case 3: flag = CLUTTER_ACTOR_REACTIVE; break;
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

=for apidoc
Retrieves the flags set on the actor
=cut
ClutterActorFlags
flags (ClutterActor *actor)
    ALIAS:
        get_flags = 1
    CODE:
        PERL_UNUSED_VAR (ix);
	RETVAL = actor->flags;
    OUTPUT:
        RETVAL

=for apidoc
Sets the given flags on the actor
=cut
void
set_flags (ClutterActor *actor, ClutterActorFlags flags)
    CODE:
        CLUTTER_ACTOR_SET_FLAGS (actor, flags);

=for apidoc
Unsets the given flags on the actor
=cut
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
        Clutter::Actor::hide           = 1
	Clutter::Actor::realize        = 2
	Clutter::Actor::unrealize      = 3
	Clutter::Actor::paint          = 4
	Clutter::Actor::queue_redraw   = 5
	Clutter::Actor::destroy        = 6
	Clutter::Actor::unparent       = 7
        Clutter::Actor::show_all       = 8
        Clutter::Actor::hide_all       = 9
        Clutter::Actor::queue_relayout = 10
        Clutter::Actor::raise_top      = 11
        Clutter::Actor::lower_bottom   = 12
    CODE:
        switch (ix) {
		case  0: clutter_actor_show           (actor); break;
		case  1: clutter_actor_hide           (actor); break;
		case  2: clutter_actor_realize        (actor); break;
		case  3: clutter_actor_unrealize      (actor); break;
		case  4: clutter_actor_paint          (actor); break;
		case  5: clutter_actor_queue_redraw   (actor); break;
	        case  6: clutter_actor_destroy        (actor); break;
		case  7: clutter_actor_unparent       (actor); break;
		case  8: clutter_actor_show_all       (actor); break;
		case  9: clutter_actor_hide_all       (actor); break;
                case 10: clutter_actor_queue_relayout (actor); break;
                case 11: clutter_actor_raise_top      (actor); break;
                case 12: clutter_actor_lower_bottom   (actor); break;
		default:
			g_assert_not_reached ();
	}



=for apidoc
A simple wrapper around Clutter::Actor::get_position() and
Clutter::Actor::get_size()
=cut
void
clutter_actor_set_geometry (ClutterActor *actor, ClutterGeometry *geom)

=for apidoc
A simple wrapper around Clutter::Actor::set_position() and
Clutter::Actor::set_size()
=cut
ClutterGeometry_copy *
clutter_actor_get_geometry (ClutterActor *actor)
    PREINIT:
        ClutterGeometry geom = { 0, };
    CODE:
        clutter_actor_get_geometry (actor, &geom);
	RETVAL = &geom;
    OUTPUT:
        RETVAL

=for apidoc
=for signature (x1, y1, x2, y2) = $actor->get_allocation_coords

Retrieves the coordinates of the allocation (top left corner, bottom
right corner), in pixels.
=cut
void
clutter_actor_get_allocation_coords (ClutterActor *actor)
    PREINIT:
        gint x1, y1;
	gint x2, y2;
    PPCODE:
        clutter_actor_get_allocation_coords (actor, &x1, &y1, &x2, &y2);
	EXTEND (SP, 4);
	PUSHs (sv_2mortal (newSViv (x1)));
	PUSHs (sv_2mortal (newSViv (y1)));
	PUSHs (sv_2mortal (newSViv (x2)));
	PUSHs (sv_2mortal (newSViv (y2)));

=for apidoc
Retrieves the allocation box in pixels
=cut
ClutterGeometry_copy *
clutter_actor_get_allocation_geometry (ClutterActor *actor)
    PREINIT:
        ClutterGeometry geom = { 0, };
    CODE:
        clutter_actor_get_allocation_geometry (actor, &geom);
        RETVAL = &geom;
    OUTPUT:
        RETVAL

=for apidoc
Retrieves the allocation box in Clutter units
=cut
ClutterActorBox_copy *
clutter_actor_get_allocation_box (ClutterActor *actor)
    PREINIT:
        ClutterActorBox box = { 0, };
    CODE:
        clutter_actor_get_allocation_box (actor, &box);
        RETVAL = &box;
    OUTPUT:
        RETVAL

void
clutter_actor_set_position (ClutterActor *actor, gint x, gint y)

=for apidoc
Unit-based version of Clutter::Actor::set_position().
=cut
void
clutter_actor_set_positionu (ClutterActor *actor, ClutterUnit x, ClutterUnit y)

=for apidoc
=for signature (x, y) = $actor->get_position
=cut
void
clutter_actor_get_position (ClutterActor *actor)
    PREINIT:
        gint x, y;
    PPCODE:
        clutter_actor_get_position (actor, &x, &y);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (x)));
        PUSHs (sv_2mortal (newSViv (y)));

=for apidoc
=for signature (x, y) = $actor->get_positionu

Unit-based version of Clutter::Actor::get_position().
=cut
void
clutter_actor_get_positionu (ClutterActor *actor)
    PREINIT:
        ClutterUnit x, y;
    PPCODE:
        clutter_actor_get_positionu (actor, &x, &y);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (x)));
        PUSHs (sv_2mortal (newSViv (y)));

=for apidoc
=for signature (x, y) = $actor->get_transformed_position
Gets the absolute position of an actor in pixels relative to the stage
=cut
void
clutter_actor_get_transformed_position (ClutterActor *actor)
    PREINIT:
        gint x, y;
    PPCODE:
        clutter_actor_get_transformed_position (actor, &x, &y);
	EXTEND (SP, 2);
	PUSHs (sv_2mortal (newSViv (x)));
	PUSHs (sv_2mortal (newSViv (y)));

void
clutter_actor_set_size (ClutterActor *actor, gint width, gint height)

=for apidoc
Unit-based version of Clutter::Actor::set_size().
=cut
void
clutter_actor_set_sizeu (ClutterActor *actor, ClutterUnit width, ClutterUnit height)

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

=for apidoc
=for signature (width, height) = $actor->get_sizeu

Unit-based version of Clutter::Actor::get_size().
=cut
void
clutter_actor_get_sizeu (ClutterActor *actor)
    PREINIT:
        ClutterUnit width, height;
    PPCODE:
        clutter_actor_get_sizeu (actor, &width, &height);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (width)));
        PUSHs (sv_2mortal (newSViv (height)));

=for apidoc
=for signature (width, height) = $actor->get_transformed_size
Gets the absolute size of an actor taking into account any scaling factors
=cut
void
clutter_actor_get_transformed_size (ClutterActor *actor)
    PREINIT:
        guint width, height;
    PPCODE:
        clutter_actor_get_transformed_size (actor, &width, &height);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVuv (width)));
        PUSHs (sv_2mortal (newSVuv (height)));

void
clutter_actor_set_width (ClutterActor *actor, guint width)

void
clutter_actor_set_widthu (ClutterActor *actor, ClutterUnit width)

guint
clutter_actor_get_width (ClutterActor *actor)

ClutterUnit
clutter_actor_get_widthu (ClutterActor *actor)

void
clutter_actor_set_height (ClutterActor *actor, guint height)

void
clutter_actor_set_heightu (ClutterActor *actor, ClutterUnit height)

guint
clutter_actor_get_height (ClutterActor *actor)

ClutterUnit
clutter_actor_get_heightu (ClutterActor *actor)

void
clutter_actor_set_x (ClutterActor *actor, gint x)

void
clutter_actor_set_xu (ClutterActor *actor, ClutterUnit x)

gint
clutter_actor_get_x (ClutterActor *actor)

ClutterUnit
clutter_actor_get_xu (ClutterActor *actor)

void
clutter_actor_set_y (ClutterActor *actor, gint y)

void
clutter_actor_set_yu (ClutterActor *actor, ClutterUnit y)

gint
clutter_actor_get_y (ClutterActor *actor)

ClutterUnit
clutter_actor_get_yu (ClutterActor *actor)

=for apidoc
Sets the rotation angle of I<actor> around the given I<axis>.

The rotation center coordinates depend on the value of I<axis>:

=over

=item 'x-axis' requires I<y> and I<z>

=item 'y-axis' requires I<x> and I<z>

=item 'z-axis' requires I<x> and I<y>

=back

=cut
void
clutter_actor_set_rotation (actor, axis, angle, x=0, y=0, z=0)
        ClutterActor *actor
        ClutterRotateAxis axis
        gdouble angle
        gint x
        gint y
        gint z

=for apidoc
=for signature angle = $actor->get_rotation ($axis)
=for signature (angle, x, y, z) = $actor->get_rotation ($axis)
Retrieves the angle and center of rotation on the given axis.
=cut
void
clutter_actor_get_rotation (ClutterActor *actor, ClutterRotateAxis axis)
    PREINIT:
        gdouble angle;
        gint x, y, z;
    PPCODE:
        angle = clutter_actor_get_rotation (actor, axis, &x, &y, &z);
        XPUSHs (sv_2mortal (newSVnv (angle)));
        if (GIMME_V == G_ARRAY) {
                EXTEND (SP, 3);
                PUSHs (sv_2mortal (newSViv (x)));
                PUSHs (sv_2mortal (newSViv (y)));
                PUSHs (sv_2mortal (newSViv (z)));
        }

=for apidoc
Sets the actor's opacity, with 0 being fully transparent and 255 being
fully opaque
=cut
void
clutter_actor_set_opacity (ClutterActor *actor, guint8 opacity)

guint8
clutter_actor_get_opacity (ClutterActor *actor)

guint8
clutter_actor_get_paint_opacity (ClutterActor *actor)

void
clutter_actor_set_name (ClutterActor *actor, const gchar *id)

const gchar *
clutter_actor_get_name (ClutterActor *actor)

guint32
clutter_actor_get_gid (ClutterActor *actor)

void
clutter_actor_set_clip (ClutterActor *actor, gint xoff, gint yoff, gint width, gint height)

void
clutter_actor_remove_clip (ClutterActor *actor)

gboolean
clutter_actor_has_clip (ClutterActor *actor)

=for apidoc
=for signature (xoff, yoff, width, height) = $actor->get_clip
=cut
void
clutter_actor_get_clip (ClutterActor *actor)
    PREINIT:
        gint xoff, yoff, width, height;
    PPCODE:
        clutter_actor_get_clip (actor, &xoff, &yoff, &width, &height);
        EXTEND (SP, 4);
        PUSHs (sv_2mortal (newSViv (xoff)));
        PUSHs (sv_2mortal (newSViv (yoff)));
        PUSHs (sv_2mortal (newSViv (width)));
        PUSHs (sv_2mortal (newSViv (height)));

void
clutter_actor_set_parent (ClutterActor *actor, ClutterActor *parent)

ClutterActor_ornull *
clutter_actor_get_parent (ClutterActor *actor)

ClutterActor_ornull *
clutter_actor_get_stage (ClutterActor *actor)

void
clutter_actor_reparent (ClutterActor *actor, ClutterActor *new_parent)

void
clutter_actor_raise (ClutterActor *actor, ClutterActor *below)

void
clutter_actor_lower (ClutterActor *actor, ClutterActor *above)

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

gboolean
clutter_actor_is_scaled (ClutterActor *actor)

gboolean
clutter_actor_is_rotated (ClutterActor *actor)

gboolean
clutter_actor_get_fixed_position_set (ClutterActor *actor)

void
clutter_actor_set_fixed_position_set (ClutterActor *actor, gboolean is_set)

void
clutter_actor_move_by (ClutterActor *actor, gint dx, gint dy)

void
clutter_actor_pick (ClutterActor *actor, ClutterColor *color)

=for apidoc
Sets whether the actor should react to events
=cut
void
clutter_actor_set_reactive (ClutterActor *actor, gboolean reactive)

gboolean
clutter_actor_get_reactive (ClutterActor *actor)

=for apidoc
=for signature vertices = $actor->get_allocation_vertices
Returns an array of four Clutter::Vertex objects containing the
transformed coordinates of the vertices of I<actor>
=cut
void
clutter_actor_get_allocation_vertices (ClutterActor *actor, ClutterActor_ornull *ancestor)
    PREINIT:
        ClutterVertex vertices[4];
    PPCODE:
        clutter_actor_get_allocation_vertices (actor, ancestor, vertices);
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

ClutterVertex_copy *
clutter_actor_apply_relative_transform_to_point (ClutterActor *actor, ClutterActor_ornull *ancestor, ClutterVertex *vertex)
    PREINIT:
        ClutterVertex transformed = { 0, };
    CODE:
        clutter_actor_apply_relative_transform_to_point (actor, ancestor, vertex, &transformed);
        RETVAL = &transformed;
    OUTPUT:
        RETVAL

gboolean
clutter_actor_should_pick_paint (ClutterActor *actor)

gboolean
clutter_actor_set_shader (ClutterActor *actor, ClutterShader_ornull *shader)

ClutterShader_ornull *
clutter_actor_get_shader (ClutterActor *actor)

void
clutter_actor_set_shader_param (actor, param, value)
      ClutterActor *actor
      const gchar *param
      gfloat value

=for apidoc
Sets the I<anchor point> of the I<actor>. The anchor is a point in the
coordinates space of the actor (with origin set at the top left corner
of the bounding box). The anchor point is taken into account when applying
any transformation to an actor.
=cut
void
clutter_actor_set_anchor_point (ClutterActor *actor, gint x, gint y)

void
clutter_actor_set_anchor_pointu (ClutterActor *actor, ClutterUnit x, ClutterUnit y)

=for apidoc
=for signature (x, y) = $actor->get_anchor_point
=cut
void
clutter_actor_get_anchor_point (ClutterActor *actor)
    PREINIT:
        gint x, y;
    PPCODE:
        clutter_actor_get_anchor_point (actor, &x, &y);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (x)));
        PUSHs (sv_2mortal (newSViv (y)));

=for apidoc
=for signature (x, y) = $actor->get_anchor_pointu
=cut
void
clutter_actor_get_anchor_pointu (ClutterActor *actor)
    PREINIT:
        ClutterUnit x, y;
    PPCODE:
        clutter_actor_get_anchor_pointu (actor, &x, &y);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (x)));
        PUSHs (sv_2mortal (newSViv (y)));

void
clutter_actor_set_anchor_point_from_gravity (actor, gravity)
        ClutterActor *actor
        ClutterGravity gravity

=for apidoc
=for signature (actor_x, actor_y) = $actor->transform_stage_point ($x, $y)
=cut
void
clutter_actor_transform_stage_point (actor, x, y)
        ClutterActor *actor
        gint32 x
        gint32 y
    PREINIT:
        ClutterUnit out_x, out_y;
    PPCODE:
        if (clutter_actor_transform_stage_point (actor, x, y, &out_x, &out_y)) {
                EXTEND (SP, 2);
                PUSHs (sv_2mortal (newSViv (out_x)));
                PUSHs (sv_2mortal (newSViv (out_y)));
        }

=for apidoc
=for signature (min_width, min_height, natural_width, natural_height) = $actor->get_preferred_size
=cut
void
clutter_actor_get_preferred_size (ClutterActor *actor)
    PREINIT:
        ClutterUnit min_width, min_height;
        ClutterUnit natural_width, natural_height;
    PPCODE:
        clutter_actor_get_preferred_size (actor,
                                          &min_width,
                                          &min_height,
                                          &natural_width,
                                          &natural_height);
        EXTEND (SP, 4);
        PUSHs (sv_2mortal (newSViv (min_width)));
        PUSHs (sv_2mortal (newSViv (min_height)));
        PUSHs (sv_2mortal (newSViv (natural_width)));
        PUSHs (sv_2mortal (newSViv (natural_height)));

void
clutter_actor_allocate (actor, box, origin_changed)
        ClutterActor *actor
        const ClutterActorBox *box
        gboolean origin_changed

void
clutter_actor_allocate_preferred_size (ClutterActor *actor, gboolean origin_changed)

=for apidoc
=for signature (min_width, natural_width) = $actor->get_preferred_width ($for_height)
=cut
void
clutter_actor_get_preferred_width (ClutterActor *actor, ClutterUnit for_height)
    PREINIT:
        ClutterUnit min_width, natural_width;
    PPCODE:
        min_width = natural_width = 0;
        clutter_actor_get_preferred_width (actor, for_height,
                                           &min_width,
                                           &natural_width);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (min_width)));
        PUSHs (sv_2mortal (newSViv (natural_width)));

=for apidoc
=for signature (min_height, natural_height) = $actor->get_preferred_height ($for_width)
=cut
void
clutter_actor_get_preferred_height (ClutterActor *actor, ClutterUnit for_width)
    PREINIT:
        ClutterUnit min_height, natural_height;
    PPCODE:
        min_height = natural_height = 0;
        clutter_actor_get_preferred_height (actor, for_width,
                                            &min_height,
                                            &natural_height);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (min_height)));
        PUSHs (sv_2mortal (newSViv (natural_height)));

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

=for apidoc Clutter::Actor::SHOW_ALL __hide__
=cut

=for apidoc Clutter::Actor::HIDE_ALL __hide__
=cut

=for apidoc Clutter::Actor::PAINT __hide__
=cut

=for apidoc Clutter::Actor::PICK __hide__
=cut

=for apidoc Clutter::Actor::ALLOCATE __hide__
=cut

=for apidoc Clutter::Actor::GET_PREFERRED_WIDTH __hide__
=cut

=for apidoc Clutter::Actor::GET_PREFERRED_HEIGHT __hide__
=cut

=for apidoc Clutter::Actor::REALIZE __hide__
=cut

=for apidoc Clutter::Actor::UNREALIZE __hide__
=cut

void
SHOW_ALL (ClutterActor *actor)
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
        if (klass->show_all) {
                klass->show_all (actor);
        }

void
HIDE_ALL (ClutterActor *actor)
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
        if (klass->hide_all) {
                klass->hide_all (actor);
        }

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
ALLOCATE (ClutterActor *actor, const ClutterActorBox *box, gboolean origin_changed)
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
        klass->allocate (actor, box, origin_changed);

void
GET_PREFERRED_WIDTH (actor, for_height)
        ClutterActor *actor
        ClutterUnit for_height
    PREINIT:
        ClutterActorClass *klass;
        GType thisclass, parent_class;
        SV *saveddefsv;
        ClutterUnit min_width = 0;
        ClutterUnit natural_width = 0;
    PPCODE:
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
        klass->get_preferred_width (actor, for_height, &min_width, &natural_width);
        /* allow doing:
         *   return $self->SUPER::GET_PREFERRED_WIDTH($for_height);
         * in Perl subclasses
         */
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (min_width)));
        PUSHs (sv_2mortal (newSViv (natural_width)));

void
GET_PREFERRED_HEIGHT (actor, for_width)
        ClutterActor *actor
        ClutterUnit for_width
    PREINIT:
        ClutterActorClass *klass;
        GType thisclass, parent_class;
        SV *saveddefsv;
        ClutterUnit min_height = 0;
        ClutterUnit natural_height = 0;
    PPCODE:
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
        klass->get_preferred_height (actor, for_width, &min_height, &natural_height);
        /* allow doing:
         *   return $self->SUPER::GET_PREFERRED_HEIGHT($for_width);
         * in Perl subclasses
         */
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (min_height)));
        PUSHs (sv_2mortal (newSViv (natural_height)));

void
REALIZE (ClutterActor *actor)
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
        if (klass->realize) {
                klass->realize (actor);
        }

void
UNREALIZE (ClutterActor *actor)
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
        if (klass->unrealize) {
                klass->unrealize (actor);
        }

void
PICK (ClutterActor *actor, const ClutterColor *pick_color)
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
        if (klass->pick) {
                klass->pick (actor, pick_color);
        }

