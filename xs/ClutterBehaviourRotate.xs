#include "clutterperl.h"

MODULE = Clutter::Behaviour::Rotate PACKAGE = Clutter::Behaviour::Rotate PREFIX = clutter_behaviour_rotate_

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
