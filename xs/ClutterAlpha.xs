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

#include "clutter-perl-private.h"

gulong
clutter_perl_animation_mode_from_sv (SV *sv)
{
        gint n;

        if (looks_like_number (sv))
                return SvIV (sv);

        if (!gperl_try_convert_enum (CLUTTER_TYPE_ANIMATION_MODE, sv, &n))
                croak ("mode should be either a ClutterAnimationMode or "
                       "an integer value");

        return n;
}

SV *
clutter_perl_animation_mode_to_sv (gulong mode)
{
        if (mode > CLUTTER_ANIMATION_LAST)
                return sv_2mortal (newSViv (mode));

        return gperl_convert_back_enum_pass_unknown (CLUTTER_TYPE_ANIMATION_MODE, mode);
}

static void
clutterperl_alpha_sink (GObject *object)
{
        g_object_ref_sink (object);
        g_object_unref (object);
}

MODULE = Clutter::Alpha PACKAGE = Clutter::Alpha PREFIX = clutter_alpha_

BOOT:
        gperl_register_sink_func (CLUTTER_TYPE_ALPHA, clutterperl_alpha_sink);

=for position DESCRIPTION

=head1 DESCRIPTION

The B<Clutter::Alpha> class binds together a L<Clutter::Timeline> and a
function. At each frame of the timeline, the Alpha object will call the given
function, which will receive the value of the frame and must return a value
between -1.0 and 2.0.

This is an example of a simple alpha function that increments linearly:

  sub linear {
      my ($alpha) = shift;

      return $alpha->get_timeline()->get_progress();
  }

A slightly more useful example:

  use Math::Trig;

  sub sine {
      my ($alpha) = @_;

      return sin($alpha->get_timeline()->get_progress() * pi);
  }

Instead of using real functions you can use a logical id for common
easing functions, like: Clutter::LINEAR, Clutter::EASE_IN_CUBIC,
Clutter::EASE_OUT_BOUNCE, etc. See L<Clutter::AnimationMode>.

Alphas are used by L<Clutter::Behaviour>s and L<Clutter::Animations>s to
create implicit animations. By changing the alpha function inside a
C<Clutter::Alpha> object it's possible to change the progress of the
animation.

=cut

=for enum Clutter::AnimationMode
=cut

ClutterAlpha_noinc *
clutter_alpha_new (class, ClutterTimeline *timeline=NULL, SV *mode=NULL)
    CODE:
        RETVAL = clutter_alpha_new ();
        if (timeline) {
                clutter_alpha_set_timeline (RETVAL, timeline);
        }
        if (mode) {
                clutter_alpha_set_mode (RETVAL, clutter_perl_animation_mode_from_sv (mode));
        }
    OUTPUT:
        RETVAL

gdouble
clutter_alpha_get_alpha (ClutterAlpha *alpha)

=for apidoc
=for arg func a code reference or undef
=for arg data a scalar to pass to I<func> or undef
Sets the alpha function for I<alpha>.
=cut
void
clutter_alpha_set_func (ClutterAlpha *alpha, SV *func, SV *data=NULL)
    CODE:
        clutter_alpha_set_closure (alpha, gperl_closure_new (func, data, FALSE));

void
clutter_alpha_set_timeline (ClutterAlpha *alpha, ClutterTimeline *timeline)

ClutterTimeline *
clutter_alpha_get_timeline (ClutterAlpha *alpha)

void
clutter_alpha_set_mode (ClutterAlpha *alpha, SV *mode)
    CODE:
        clutter_alpha_set_mode (alpha, clutter_perl_animation_mode_from_sv (mode));

SV *
clutter_alpha_get_mode (ClutterAlpha *alpha)
    CODE:
        RETVAL = clutter_perl_animation_mode_to_sv (clutter_alpha_get_mode (alpha));
    OUTPUT:
        RETVAL

gulong
register_func (SV *class, SV *func, SV *data)
    CODE:
        RETVAL = clutter_alpha_register_closure (gperl_closure_new (func, data, FALSE));
    OUTPUT:
        RETVAL

