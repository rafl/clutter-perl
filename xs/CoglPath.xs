#include "clutterperl.h"

MODULE = Clutter::Cogl::Path    PACKAGE = Clutter::Cogl::Path   PREFIX = cogl_path_

=for position DESCRIPTION

=head1 DESCRIPTION

There are three levels on which drawing with Clutter::Cogl can be used.
The highest level functions construct various simple primitive shapes
to be either filled or stroked. Using a lower-level set of functions
more complex and arbitrary paths can be constructed by concatenating
straight line, bezier curve and arc segments. Additionally there
are utility functions that draw the most common primitives - rectangles
and trapezoids - in a maximaly optimized fashion.

When constructing arbitrary paths, the current pen location is
initialized using the C< move_to > command. The subsequent path segments
implicitly use the last pen location as their first vertex and move
the pen location to the last vertex they produce at the end. Also
there are special versions of functions that allow specifying the
vertices of the path segments relative to the last pen location
rather then in the absolute coordinates.

=cut

=for apidoc
Fills the constructed shape using the current drawing color
=cut
void
cogl_path_fill (class=NULL)
    C_ARGS:
        /* void */

=for apidoc
Fills the constructed shape using the current drawing color and
preserves the path to be used again.
=cut
void
cogl_path_fill_preserve (class=NULL)
    C_ARGS:
        /* void */

=for apidoc
Strokes the constructed shape using the current drawing color
and a width of 1 pixel (regardless of the current transformation
matrix)
=cut
void
cogl_path_stroke (class=NULL)
    C_ARGS:
        /* void */

=for apidoc
Strokes the constructed shape using the current drawing color and
preserves the path to be used again.
=cut
void
cogl_path_stroke_preserve (class=NULL)
    C_ARGS:
        /* void */

=for apidoc
Clears the current path and starts a new one.
=cut
void
cogl_path_clear (class=NULL)
    CODE:
        cogl_path_new ();

=for apidoc
Clears the previously constructed shape and begins a new path
contour by moving the pen to the given coordinates
=cut
void
cogl_path_move_to (class=NULL, float x, float y)
    C_ARGS:
        x, y

=for apidoc
Clears the previously constructed shape and begins a new path
contour by moving the pen to the given coordinates relative
to the current pen location
=cut
void
cogl_path_rel_move_to (class=NULL, float x, float y)
    C_ARGS:
        x, y

=for apidoc
Adds a straight line segment to the current path that ends at the
given coordinates
=cut
void
cogl_path_line_to (class=NULL, float x, float y)
    C_ARGS:
        x, y

=for apidoc
Adds a straight line segment to the current path that ends at the
given coordinates relative to the current pen location
=cut
void
cogl_path_rel_line_to (class=NULL, float x, float y)
    C_ARGS:
        x, y

=for apidoc
Adds an elliptical arc segment to the current path. A straight line
segment will link the current pen location with the first vertex
of the arc. If you perform a I<move_to> to the arc start just before
drawing it you create a free standing arc.
=cut
void
cogl_path_arc (class=NULL, center_x, center_y, radius_x, radius_y, angle_start, angle_end)
        float center_x
        float center_y
        float radius_x
        float radius_y
        float angle_start
        float angle_end
    C_ARGS:
        center_x, center_y, radius_x, radius_y, angle_start, angle_end

=for apidoc
Adds a cubic bezier curve segment to the current path with the given
second, third and fourth control points and using current pen location
as the first control point.
=cut
void
cogl_path_curve_to (class=NULL, x1, y1, x2, y2, x3, y3)
        float x1
        float y1
        float x2
        float y2
        float x3
        float y3
    C_ARGS:
        x1, y1, x2, y2, x3, y3

=for apidoc
Adds a cubic bezier curve segment to the current path with the given
second, third and fourth control points and using current pen location
as the first control point. The given coordinates are relative to the
current pen location
=cut
void
cogl_path_rel_curve_to (class=NULL, x1, y1, x2, y2, x3, y3)
        float x1
        float y1
        float x2
        float y2
        float x3
        float y3
    C_ARGS:
        x1, y1, x2, y2, x3, y3

=for apidoc
Closes the path being constructed by adding a straight line segment
to it that ends at the first vertex of the path
=cut
void
cogl_path_close (class=NULL)
    C_ARGS:
        /* void */

=for apidoc
Clears the previously constructed shape and constructs a straight
line shape start and ending at the given coordinates
=cut
void
cogl_path_line (class=NULL, float x1, float y1, float x2, float y2)
    C_ARGS:
        x1, y1, x2, y2

##=for apidoc
##Clears the previously constructed shape and constructs a series of straight
##line segments, starting from the first given vertex coordinate. Each
##subsequent segment stars where the previous one ended and ends at the next
##given vertex coordinate.
##
##I<coords> is a reference to an array containing the X and Y coordinates of
##each vertex.
##
##C<scalar @coords - 1> lines will be constructed.
##=cut
##void
##cogl_path_polyline (class=NULL, SV *coords)

##=for apidoc
##Clears the previously constructed shape and constructs a polygonal
##shape of the given number of vertices.
##
##I<coords> is a reference to an array containing the X and Y coordinates of
##each vertex.
##
##C<scalar @coords> lines will be constructed.
##=cut
##void
##cogl_path_polygon (class=NULL, SV *coords)

=for apidoc
Clears the previously constructed shape and constructs a rectangular
shape at the given coordinates
=cut
void
cogl_path_rectangle (class=NULL, float x1, float y1, float x2, float y2)
     C_ARGS:
        x1, y1, x2, y2

=for apidoc
Clears the previously constructed shape and constructs an ellipse shape
=cut
void
cogl_path_ellipse (class=NULL, float center_x, float center_y, float radius_x, float radius_y)
    C_ARGS:
        center_x, center_y, radius_x, radius_y

=for apidoc
Clears the previously constructed shape and constructs a rectangular
shape with rounded corners
=cut
void
cogl_path_round_rectangle (class=NULL, x1, y1, x2, y2, radius, arc_step)
        float x1
        float y1
        float x2
        float y2
        float radius
        float arc_step
    C_ARGS:
        x1, y1, x2, y2, radius, arc_step
