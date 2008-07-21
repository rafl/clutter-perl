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
between 0 and L<Clutter::Alpha::MAX_ALPHA>.

This is an example of a simple alpha function that increments linearly:

  sub linear {
      my $alpha    = shift;
      my $timeline = $alpha->get_timeline();

      return int($timeline->get_progress() * Clutter::Alpha->MAX_ALPHA);
  }

Alphas are used by L<Clutter::Behaviour>s to create implicit animations. By
changing the alpha function inside a Clutter::Alpha object it's possible to
change the speed of the animation.

Clutter provides some common alpha function, like ramps, sines, smoothsteps,
exponential and square waves.

=cut

ClutterAlpha_noinc *
clutter_alpha_new (class, timeline=NULL, func=NULL, data=NULL)
        ClutterTimeline *timeline
        SV *func
        SV *data
    CODE:
        RETVAL = clutter_alpha_new ();
        if (timeline) {
                clutter_alpha_set_timeline (RETVAL, timeline);
        }
        if (func) {
                GClosure *closure = gperl_closure_new (func, data, FALSE);
                clutter_alpha_set_closure (RETVAL, closure);
        }
    OUTPUT:
        RETVAL

guint32
clutter_alpha_get_alpha (ClutterAlpha *alpha)

void
clutter_alpha_set_func (ClutterAlpha *alpha, SV *func, SV *data=NULL)
    PREINIT:
        GPerlCallback *callback;
    CODE:
        clutter_alpha_set_closure (alpha, gperl_closure_new (func, data, FALSE));

void
clutter_alpha_set_timeline (ClutterAlpha *alpha, ClutterTimeline *timeline)

ClutterTimeline *
clutter_alpha_get_timeline (ClutterAlpha *alpha)

guint32
MAX_ALPHA (class)
    CODE:
        RETVAL = CLUTTER_ALPHA_MAX_ALPHA;
    OUTPUT:
        RETVAL

## compress every alpha functions Clutter provides in here; this saves
## some space in the resulting shared object and also avoids pure perl
## implementations which might end up slower and are definitely harder
## to maintain. -- Emmanuele

guint32
ramp (class=NULL, ClutterAlpha *alpha)
    ALIAS:
        Clutter::Alpha::ramp           =  0
        Clutter::Alpha::ramp_inc       =  1
        Clutter::Alpha::ramp_dec       =  2
        Clutter::Alpha::sine           =  3
        Clutter::Alpha::sine_inc       =  4
        Clutter::Alpha::sine_dec       =  5
        Clutter::Alpha::sine_half      =  6
        Clutter::Alpha::square         =  7
        Clutter::Alpha::smoothstep_inc =  8
        Clutter::Alpha::smoothstep_dec =  9
        Clutter::Alpha::exp_inc        = 10
        Clutter::Alpha::exp_dec        = 11
    CODE:
        switch (ix) {
          case  0: RETVAL = clutter_ramp_func (alpha, NULL);           break;
          case  1: RETVAL = clutter_ramp_inc_func (alpha, NULL);       break;
          case  2: RETVAL = clutter_ramp_dec_func (alpha, NULL);       break;
          case  3: RETVAL = clutter_sine_func (alpha, NULL);           break;
          case  4: RETVAL = clutter_sine_inc_func (alpha, NULL);       break;
          case  5: RETVAL = clutter_sine_dec_func (alpha, NULL);       break;
          case  6: RETVAL = clutter_sine_half_func (alpha, NULL);      break;
          case  7: RETVAL = clutter_square_func (alpha, NULL);         break;
          case  8: RETVAL = clutter_smoothstep_inc_func (alpha, NULL); break;
          case  9: RETVAL = clutter_smoothstep_dec_func (alpha, NULL); break;
          case 10: RETVAL = clutter_exp_inc_func (alpha, NULL);        break;
          case 11: RETVAL = clutter_exp_dec_func (alpha, NULL);        break;
          default:
            g_assert_not_reached ();
            RETVAL = 0;
            break;
       }
    OUTPUT:
        RETVAL
