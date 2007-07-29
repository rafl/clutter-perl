#include "clutterperl.h"

MODULE = Clutter::Behaviour::Ellipse    PACKAGE = Clutter::Behaviour::Ellipse   PREFIX = clutter_behaviour_ellipse_

ClutterBehaviour_noinc *
clutter_behaviour_ellipse_new (class, alpha=NULL, x, y, width, height, begin, end)
        ClutterAlpha_ornull *alpha
        gint x
        gint y
        gint width
        gint height
        gdouble begin
        gdouble end
    C_ARGS:
        alpha, x, y, width, height, begin, end

void
clutter_behaviour_ellipse_set_center (ellipse, x, y)
        ClutterBehaviourEllipse *ellipse
        gint x
        gint y

void
clutter_behaviour_ellipse_set_width (ellipse, width)
        ClutterBehaviourEllipse *ellipse
        gint width

void
clutter_behaviour_ellipse_set_height (ellipse, height)
        ClutterBehaviourEllipse *ellipse
        gint height

void
clutter_behaviour_ellipse_set_angle_begin (ellipse, begin)
        ClutterBehaviourEllipse *ellipse
        gdouble begin

void
clutter_behaviour_ellipse_set_angle_end (ellipse, end)
        ClutterBehaviourEllipse *ellipse
        gdouble end

void
clutter_behaviour_ellipse_set_angle_tilt (ellipse, tilt, axis)
        ClutterBehaviourEllipse *ellipse
        ClutterRotateAxis axis
        gdouble tilt

void
clutter_behaviour_ellipse_set_tilt (ellipse, tilt_x, tilt_y, tilt_z)
        ClutterBehaviourEllipse *ellipse
        gdouble tilt_x
        gdouble tilt_y
        gdouble tilt_z

void
clutter_behaviour_ellipse_set_direction (ellipse, direction)
        ClutterBehaviourEllipse *ellipse
        ClutterRotateDirection direction

=for apidoc
=for signature (x, y) = $ellipse->get_center
=cut
void
clutter_behaviour_ellipse_get_center (ClutterBehaviourEllipse *ellipse)
    PREINIT:
        gint x, y;
    PPCODE:
        clutter_behaviour_ellipse_get_center (ellipse, &x, &y);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (x)));
        PUSHs (sv_2mortal (newSViv (y)));

gint
clutter_behaviour_ellipse_get_width (ClutterBehaviourEllipse *ellipse)

gint
clutter_behaviour_ellipse_get_height (ClutterBehaviourEllipse *ellipse)

gdouble
clutter_behaviour_ellipse_get_angle_begin (ClutterBehaviourEllipse *ellipse)

gdouble
clutter_behaviour_ellipse_get_angle_end (ClutterBehaviourEllipse *ellipse)

gdouble
clutter_behaviour_ellipse_get_angle_tilt (ClutterBehaviourEllipse *ellipse, ClutterRotateAxis axis)

=for apidoc
=for signature (tilt_x, tilt_y, tilt_z) = $ellipse->get_tilt
=cut
void
clutter_behaviour_ellipse_get_tilt (ClutterBehaviourEllipse *ellipse)
    PREINIT:
        gdouble tilt_x, tilt_y, tilt_z;
    PPCODE:
        tilt_x = tilt_y = tilt_z  = 0.0;
        clutter_behaviour_ellipse_get_tilt (ellipse, &tilt_x, &tilt_y, &tilt_z);
        EXTEND (SP, 3);
        PUSHs (sv_2mortal (newSVnv (tilt_x)));
        PUSHs (sv_2mortal (newSVnv (tilt_y)));
        PUSHs (sv_2mortal (newSVnv (tilt_z)));

ClutterRotateDirection
clutter_behaviour_ellipse_get_direction (ClutterBehaviourEllipse *ellipse)
