#include "clutter-perl.h"

MODULE = Clutter::Behaviour::Depth PACKAGE = Clutter::Behaviour::Depth PREFIX = clutter_behaviour_depth_

=for object Clutter::Behaviour::Depth - A behaviour controlling the Z position
=cut

=for position DESCRIPTION

=head1 SYNOPSIS

    my $behaviour = Clutter::Behaviour::Depth->new();
    $behaviour->set_alpha(Clutter::Alpha->new($timeline, 'ease-in-sine'));
    $behaviour->set_bounds(-200, 200);

    $behaviour->apply($rectangle);
    $behaviour->apply($texture);

    $timeline->start();

=head1 DESCRIPTION

B<Clutter::Behaviour::Depth is a simple L<Clutter::Behaviour> controlling
the depth of a set of actors between a start and end value.

=cut

=for position SEE_ALSO

=head1 SEE ALSO

L<Clutter::Behaviour>, L<Clutter::Alpha>

=cut

ClutterBehaviour_noinc *
clutter_behaviour_depth_new (class, alpha=NULL, depth_start, depth_end)
        ClutterAlpha_ornull *alpha
        gint depth_start
        gint depth_end
    C_ARGS:
        alpha, depth_start, depth_end

void
clutter_behaviour_depth_set_bounds (behaviour, start, end)
        ClutterBehaviourDepth *behaviour
        gint start
        gint end

=for apidoc
=for signature (start, end) = $behaviour->get_bounds
=cut
void
clutter_behaviour_depth_get_bounds (ClutterBehaviourDepth *behaviour)
    PREINIT:
        gint start, end;
    PPCODE:
        clutter_behaviour_depth_get_bounds (behaviour, &start, &end);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (start)));
        PUSHs (sv_2mortal (newSViv (end)));

