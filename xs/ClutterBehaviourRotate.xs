#include "clutter-perl-private.h"

MODULE = Clutter::Behaviour::Rotate PACKAGE = Clutter::Behaviour::Rotate PREFIX = clutter_behaviour_rotate_

=for object Clutter::Behaviour::Rotate - A behaviour controlling rotation
=cut

=for position DESCRIPTION

=head1 SYNOPSIS

    my $behaviour = Clutter::Behaviour::Rotate->new();
    $behaviour->set_alpha(Clutter::Alpha->new($timeline, 'ease-out-quad'));
    $behaviour->set_axis('z-axis');
    $behaviour->set_direction('ccw');
    $behaviour->set_bounds(270, 90);

=head1 DESCRIPTION

B<Clutter::Behaviour::Rotate> rotates actors between a starting and ending
angle on a given axis.

=cut

=for position SEE_ALSO

=head1 SEE ALSO

L<Clutter::Behaviour>, L<Clutter::Alpha>

=cut

ClutterBehaviour_noinc *
clutter_behaviour_rotate_new (class, alpha=NULL, axis, direction, angle_begin, angle_end)
        ClutterAlpha_ornull *alpha
        ClutterRotateAxis axis
        ClutterRotateDirection direction
        gdouble angle_begin
        gdouble angle_end
    C_ARGS:
        alpha, axis, direction, angle_begin, angle_end

ClutterRotateAxis
clutter_behaviour_rotate_get_axis (ClutterBehaviourRotate *rotate)

ClutterRotateDirection
clutter_behaviour_rotate_get_direction (ClutterBehaviourRotate *rotate)

=for apidoc
=for signature (angle_begin, angle_end) = $rotate->get_bounds
=cut
void
clutter_behaviour_rotate_get_bounds (ClutterBehaviourRotate *rotate)
    PREINIT:
        gdouble angle_begin, angle_end;
    PPCODE:
        clutter_behaviour_rotate_get_bounds (rotate, &angle_begin, &angle_end);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVnv (angle_begin)));
        PUSHs (sv_2mortal (newSVnv (angle_end)));

void
clutter_behaviour_rotate_set_axis (ClutterBehaviourRotate *rotate, ClutterRotateAxis axis)

void
clutter_behaviour_rotate_set_direction (ClutterBehaviourRotate *rotate, ClutterRotateDirection direction)

void
clutter_behaviour_rotate_set_bounds (ClutterBehaviourRotate *rotate, gdouble angle_begin, gdouble angle_end)

void
clutter_behaviour_rotate_set_center (rotate, x, y, z)
        ClutterBehaviourRotate *rotate
        gint x
        gint y
        gint z

=for apidoc
=for signature (x, y, z) = $rotate->get_center
=cut
void
clutter_behaviour_rotate_get_center (ClutterBehaviourRotate *rotate)
    PREINIT:
        gint x, y, z;
    PPCODE:
        x = y = z = 0;
        clutter_behaviour_rotate_get_center (rotate, &x, &y, &z);
        EXTEND (SP, 3);
        PUSHs (sv_2mortal (newSViv (x)));
        PUSHs (sv_2mortal (newSViv (y)));
        PUSHs (sv_2mortal (newSViv (z)));
