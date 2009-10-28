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

MODULE = Clutter::Behaviour::Scale    PACKAGE = Clutter::Behaviour::Scale   PREFIX = clutter_behaviour_scale_

=for object Clutter::Behaviour::Scale - A behaviour controlling scale
=cut

=for position DESCRIPTION

=head1 SYNOPSIS

    my $behaviour = Clutter::Behaviour::Scale->new(
        Clutter::Alpha->new($timeline, 'ease-in-quad'),
        1.0, 1.0,       # initial scaling factors
        2.0, 2.0,       # final scaling factors
    );

=head1 DESCRIPTION

B<Clutter::Behaviour::Scale> interpolates actors scaling factors between
two values.

=cut

=for position SEE_ALSO

=head1 SEE ALSO

L<Clutter::Behaviour>, L<Clutter::Alpha>

=cut

=for enum ClutterGravity
=cut

ClutterBehaviour_noinc *
clutter_behaviour_scale_new (class, alpha=NULL, x_start, y_start, x_end, y_end)
        ClutterAlpha_ornull *alpha
        gdouble x_start
        gdouble y_start
        gdouble x_end
        gdouble y_end
    C_ARGS:
        alpha, x_start, y_start, x_end, y_end

void
clutter_behaviour_scale_set_bounds (scale, x_start, y_start, x_end, y_end)
        ClutterBehaviourScale *scale
        gdouble x_start
        gdouble y_start
        gdouble x_end
        gdouble y_end

=for apidoc
=for signature (x_start, y_start, x_end, y_end) = $scale->get_bounds
=cut
void
clutter_behaviour_scale_get_bounds (ClutterBehaviourScale *scale)
    PREINIT:
        gdouble x_start, x_end;
        gdouble y_start, y_end;
    PPCODE:
        clutter_behaviour_scale_get_bounds (scale,
                                            &x_start, &y_start,
                                            &x_end, &y_end);
        EXTEND (SP, 4);
        PUSHs (sv_2mortal (newSVnv (x_start)));
        PUSHs (sv_2mortal (newSVnv (y_start)));
        PUSHs (sv_2mortal (newSVnv (x_end)));
        PUSHs (sv_2mortal (newSVnv (y_end)));
