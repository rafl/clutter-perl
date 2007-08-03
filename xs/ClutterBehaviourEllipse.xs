#include "clutterperl.h"

MODULE = Clutter::Behaviour::Ellipse    PACKAGE = Clutter::Behaviour::Ellipse   PREFIX = clutter_behaviour_ellipse_

=for apidoc
=for arg center an array reference containing the x and y coordinates
=for arg size an array reference containing the width and height of the ellipse
=for arg angles an array reference containing the initial and final angles
=cut
ClutterBehaviour_noinc *
clutter_behaviour_ellipse_new (class, alpha=NULL, center, size, direction, angles)
        ClutterAlpha_ornull *alpha
        SV *center
        SV *size
        ClutterRotateDirection direction
        SV *angles
    PREINIT:
        gint x, y, width, height;
        gdouble begin, end;
        AV *av;
        SV **svp;
    CODE:
#define AV_FETCH_IV(_av,_index)                                         \
        (((svp = av_fetch ((_av), (_index), FALSE)) && SvOK (*svp))     \
         ? SvIV (*svp)                                                  \
         : 0)
#define AV_FETCH_NV(_av,_index)                                         \
        (((svp = av_fetch ((_av), (_index), FALSE)) && SvOK (*svp))     \
         ? SvNV (*svp)                                                  \
         : 0.0)

        if ((!SvRV (center)) || (SvTYPE (SvRV (center))) != SVt_PVAV)
                croak("Invalid center, expecting an array of two integers");
        if ((!SvRV (size)) || (SvTYPE (SvRV (size))) != SVt_PVAV)
                croak("Invalid size, expecting an array of two integers");
        if ((!SvRV (angles)) || (SvTYPE (SvRV (angles))) != SVt_PVAV)
                croak("Invalid size, expecting an array of two floats");
        av = (AV *) SvRV (center);
        x = AV_FETCH_IV (av, 0); y = AV_FETCH_IV (av, 1);
        av = (AV *) SvRV (size);
        width = AV_FETCH_IV (av, 0); height = AV_FETCH_IV (av, 1);
        av = (AV *) SvRV (angles);
        begin = AV_FETCH_NV (av, 0); end = AV_FETCH_NV (av, 1);
#undef AV_FETCH_IV
#undef AV_FETCH_NV
        RETVAL = clutter_behaviour_ellipse_new (alpha,
                                                x, y, width, height,
                                                direction,
                                                begin, end);
    OUTPUT:
        RETVAL

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
clutter_behaviour_ellipse_set_size (ellipse, width, height)
        ClutterBehaviourEllipse *ellipse
        gint width
        gint height
    CODE:
        g_object_set (G_OBJECT (ellipse), "width", width, "height", height, NULL);

void
clutter_behaviour_ellipse_set_angle_begin (ellipse, begin)
        ClutterBehaviourEllipse *ellipse
        gdouble begin

void
clutter_behaviour_ellipse_set_angle_end (ellipse, end)
        ClutterBehaviourEllipse *ellipse
        gdouble end

void
clutter_behaviour_ellipse_set_angles (ellipse, begin, end)
        ClutterBehaviourEllipse *ellipse
        gdouble begin
        gdouble end
    CODE:
        g_object_set (G_OBJECT (ellipse), "angle-begin", begin, "angle-end", end, NULL);

void
clutter_behaviour_ellipse_set_angle_tilt (ellipse, axis, tilt)
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

=for apidoc
=for signature (width, height) = $ellipse->get_size
=cut
void
clutter_behaviour_ellipse_get_size (ClutterBehaviourEllipse *ellipse)
    PREINIT:
        gint width, height;
    PPCODE:
        width = height = 0;
        g_object_get (G_OBJECT (ellipse), "width", &width, "height", &height, NULL);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSViv (width)));
        PUSHs (sv_2mortal (newSViv (height)));

gdouble
clutter_behaviour_ellipse_get_angle_begin (ClutterBehaviourEllipse *ellipse)

gdouble
clutter_behaviour_ellipse_get_angle_end (ClutterBehaviourEllipse *ellipse)

=for apidoc
=for signature (begin, end) = $behaviour->get_angles
=cut
void
clutter_behaviour_ellipse_get_angles (ClutterBehaviourEllipse *ellipse)
    PREINIT:
        gdouble begin, end;
    PPCODE:
        begin = end = 0;
        g_object_get (G_OBJECT (ellipse),
                      "angle-begin", &begin,
                      "angle-end", &end,
                      NULL);
        EXTEND (SP, 2);
        PUSHs (sv_2mortal (newSVnv (begin)));
        PUSHs (sv_2mortal (newSVnv (end)));

gdouble
clutter_behaviour_ellipse_get_angle_tilt (ellipse, axis)
        ClutterBehaviourEllipse *ellipse
        ClutterRotateAxis axis

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
