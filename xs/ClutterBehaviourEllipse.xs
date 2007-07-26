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
clutter_behaviour_ellipse_set_angle_tilt (ellipse, tilt)
        ClutterBehaviourEllipse *ellipse
        gdouble tilt

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
clutter_behaviour_ellipse_get_angle_tilt (ClutterBehaviourEllipse *ellipse)

=for apidoc
=for signature (begin, end, tilt) = $ellipse->get_angles
=cut
void
clutter_behaviour_ellipse_get_angles (ClutterBehaviourEllipse *ellipse)
    PREINIT:
        gdouble begin, end, tilt;
    PPCODE:
        begin = end = tilt = 0.0;
        g_object_get (G_OBJECT (ellipse),
                      "angle-begin", &begin,
                      "angle-end", &end,
                      "angle-tilt", &tilt,
                      NULL);
        EXTEND (SP, 3);
        PUSHs (sv_2mortal (newSVnv (begin)));
        PUSHs (sv_2mortal (newSVnv (end)));
        PUSHs (sv_2mortal (newSVnv (tilt)));

ClutterRotateDirection
clutter_behaviour_ellipse_get_direction (ClutterBehaviourEllipse *ellipse)
