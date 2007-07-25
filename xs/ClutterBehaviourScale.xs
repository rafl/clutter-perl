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

MODULE = Clutter::Behaviour::Scale    PACKAGE = Clutter::Behaviour::Scale   PREFIX = clutter_behaviour_scale_

=for enum ClutterGravity
=cut

ClutterBehaviour_noinc *
clutter_behaviour_scale_new (class, alpha=NULL, scale_begin, scale_end, gravity)
        ClutterAlpha_ornull *alpha
        gdouble scale_begin
        gdouble scale_end
        ClutterGravity gravity
    C_ARGS:
        alpha, scale_begin, scale_end, gravity

=for apidoc
=for signature (scale_begin, scale_end) = $scale->get_bounds
=cut
void
clutter_behaviour_scale_get_bounds (ClutterBehaviourScale *scale)
    PREINIT:
        gdouble scale_begin, scale_end;
    PPCODE:
        clutter_behaviour_scale_get_bounds (scale, &scale_begin, &scale_end);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVnv (scale_begin)));
        PUSHs (sv_2mortal (newSVnv (scale_end)));

ClutterGravity
clutter_behaviour_scale_get_gravity (ClutterBehaviourScale *scale)

