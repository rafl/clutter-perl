#include "clutterperl.h"

MODULE = Clutter::Units         PACKAGE = Clutter::Units

=for position DESCRIPTION

=head1 DESCRIPTION

Clutter uses device independent units, internally, to provide sub-pixel
positioning. While the public API does not always expose this for convenience
of the developer, when writing new L<Clutter::Actor> classes or when
implementing low-level interfaces like L<Clutter::Layout> you will be
exposed to this kind of units.

The following package methods are useful for converting device dependent
units, like pixels and percentages, into device independent units and vice
versa.

B<Note>: this is true for Clutter 0.4. In Clutter 0.6 (and relative Perl
bindings) the public API will always return device independent units as
well, and will be care of the developer to convert it to device units,
like pixels, font units, etc.

=cut

=for apidoc
Converts an integer value, like pixels, into a device independent unit.
=cut
gint32
FROM_INT (class=NULL, gint value)
    CODE:
        RETVAL = CLUTTER_UNITS_FROM_INT (value);
    OUTPUT:
        RETVAL

=for apidoc
=for arg units (integer) High precision units
Converts a device independent unit into an integer value, like pixels.
=cut
gint
TO_INT (class=NULL, gint32 units)
    CODE:
        RETVAL = CLUTTER_UNITS_TO_INT (units);
    OUTPUT:
        RETVAL

=for apidoc
Converts a floating point value, like a percentage, into a device independent
unit
=cut
gint32
FROM_FLOAT (class=NULL, gdouble value)
    CODE:
        RETVAL = CLUTTER_UNITS_FROM_FLOAT (value);
    OUTPUT:
        RETVAL

=for apidoc
=for arg units (integer) High precision units
Converts a device independent unit into a floating point value, like a
percentage
=cut
gdouble
TO_FLOAT (class=NULL, gint32 units)
    CODE:
        RETVAL = CLUTTER_UNITS_TO_FLOAT (units);
    OUTPUT:
        RETVAL

=for apidoc
Converts pixels into device independent units
=cut
gint32
FROM_DEVICE (class=NULL, gint value)
    CODE:
        RETVAL = CLUTTER_UNITS_FROM_DEVICE (value);
    OUTPUT:
        RETVAL

=for apidoc
=for arg units (integer) High precision units
Converts device independent units into pixels
=cut
gint
TO_DEVICE (class=NULL, gint32 units)
    CODE:
        RETVAL = CLUTTER_UNITS_TO_DEVICE (units);

=for apidoc
Converts Pango units into device independent units
=cut
gint32
FROM_PANGO_UNIT (class=NULL, gint value)
    CODE:
        RETVAL = CLUTTER_UNITS_FROM_PANGO_UNIT (value);
    OUTPUT:
        RETVAL

=for apidoc
Converts device independent units into Pango units
=cut
gint
TO_PANGO_UNIT (class=NULL, gint32 units)
    CODE:
        RETVAL = CLUTTER_UNITS_TO_PANGO_UNIT (units);
    OUTPUT:
        RETVAL

=for apidoc
Converts a percentage of the default stage's width into
device independed units
=cut
gint32
FROM_STAGE_WIDTH_PERCENTAGE (class=NULL, gint percent)
    CODE:
        RETVAL = CLUTTER_UNITS_FROM_STAGE_WIDTH_PERCENTAGE (percent);
    OUTPUT:
        RETVAL

=for apidoc
Converts a percentage of the default stage's height into
device independed units
=cut
gint32
FROM_STAGE_HEIGHT_PERCENTAGE (class=NULL, gint percent)
    CODE:
        RETVAL = CLUTTER_UNITS_FROM_STAGE_HEIGHT_PERCENTAGE (percent);
    OUTPUT:
        RETVAL

=for apidoc
Converts a percentage of an actor's parent widget width into
device independed units
=cut
gint32
FROM_PARENT_WIDTH_PERCENTAGE (class=NULL, ClutterActor *actor, gint percent)
    CODE:
        RETVAL = CLUTTER_UNITS_FROM_PARENT_WIDTH_PERCENTAGE (actor, percent);
    OUTPUT:
        RETVAL

=for apidoc
Converts a percentage of an actor's parent widget height into
device independed units
=cut
gint32
FROM_PARENT_HEIGHT_PERCENTAGE (class=NULL, ClutterActor *actor, gint percent)
    CODE:
        RETVAL = CLUTTER_UNITS_FROM_PARENT_HEIGHT_PERCENTAGE (actor, percent);
    OUTPUT:
        RETVAL

=for apidoc
Converts millimeters into device independent units
=cut
gint32
FROM_MM (class=NULL, gint millimeters)
    CODE:
        RETVAL = CLUTTER_UNITS_FROM_MM (millimeters);
    OUTPUT:
        RETVAL

=for apidoc
Converts font points into device independent units
=cut
gint32
FROM_POINTS (class=NULL, gint points)
    CODE:
        RETVAL = CLUTTER_UNITS_FROM_POINTS (points);
    OUTPUT:
        RETVAL

