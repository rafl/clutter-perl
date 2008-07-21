#include "clutterperl.h"

MODULE = Clutter::Fixed         PACKAGE = Clutter::Fixed

=for position DESCRIPTION

=head1 DESCRIPTION

Fixed-point representation of fractionary numbers.

This class methods should only be used with the Clutter::Cogl API.

=cut

ClutterFixed
FROM_INT (class=NULL, gint value)
    CODE:
        RETVAL = CLUTTER_INT_TO_FIXED (value);
    OUTPUT:
        RETVAL

gint
TO_INT (class=NULL, ClutterFixed value)
    CODE:
        RETVAL = CLUTTER_FIXED_TO_INT (value);
    OUTPUT:
        RETVAL


ClutterFixed
FROM_FLOAT (class=NULL, gdouble value)
    CODE:
        RETVAL = CLUTTER_FLOAT_TO_FIXED (value);
    OUTPUT:
        RETVAL

gdouble
TO_FLOAT (class=NULL, ClutterFixed value)
    CODE:
        RETVAL = CLUTTER_FIXED_TO_DOUBLE (value);
    OUTPUT:
        RETVAL

MODULE = Clutter::Fixed         PACKAGE = Clutter::Angle

=for position DESCRIPTION

=head1 DESCRIPTION

Fixed-point representation of an angle.

This class methods should only be used with the Clutter::Cogl API.

=cut

ClutterAngle
FROM_DEG (class=NULL, gint degrees)
    CODE:
        RETVAL = CLUTTER_ANGLE_FROM_DEG (degrees);
    OUTPUT:
        RETVAL

ClutterAngle
FROM_DEGF (class=NULL, gdouble degrees)
    CODE:
        RETVAL = CLUTTER_ANGLE_FROM_DEGF (degrees);
    OUTPUT:
        RETVAL

gint
TO_DEG (class=NULL, ClutterAngle value)
    CODE:
        RETVAL = CLUTTER_ANGLE_TO_DEG (value);
    OUTPUT:
        RETVAL

gdouble
TO_DEGF (class=NULL, ClutterAngle value)
    CODE:
        RETVAL = CLUTTER_ANGLE_TO_DEGF (value);
    OUTPUT:
        RETVAL
