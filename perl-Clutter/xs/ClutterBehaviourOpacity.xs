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

MODULE = Clutter::Behaviour::Opacity    PACKAGE = Clutter::Behaviour::Opacity   PREFIX = clutter_behaviour_opacity_

=for object Clutter::Behaviour::Opacity - A behaviour controlling opacity
=cut

=for position DESCRIPTION

=head1 SYNOPSIS

    my $behaviour = Clutter::Behaviour::Opacity->new();
    $behaviour->set_alpha(Clutter::Alpha->new($timeline, 'linear'));
    $behaviour->set_bounds(255, 0);     # fade out
    $behaviour->apply($actor);

    $timeline->start();

=head1 DESCRIPTION

B<Clutter::Behaviour::Opacity> interpolates the opacity of the actors
to which it has been applied between two values.

=cut

=for position SEE_ALSO

=head1 SEE ALSO

L<Clutter::Behaviour>, L<Clutter::Alpha>

=cut

ClutterBehaviour_noinc *
clutter_behaviour_opacity_new (class, alpha=NULL, opacity_start, opacity_end)
        ClutterAlpha_ornull *alpha
        guint8 opacity_start
        guint8 opacity_end
    C_ARGS:
        alpha, opacity_start, opacity_end

void
clutter_behaviour_opacity_set_bounds (behaviour, start, end)
        ClutterBehaviourOpacity *behaviour
        guint8 start
        guint8 end

=for apidoc
=for signature (start, end) = $behaviour->get_bounds
=cut
void
clutter_behaviour_opacity_get_bounds (ClutterBehaviourOpacity *behaviour)
    PREINIT:
        guint8 start, end;
    PPCODE:
        clutter_behaviour_opacity_get_bounds (behaviour, &start, &end);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVuv (start)));
        PUSHs (sv_2mortal (newSVuv (end)));

